/* Public domain.
   Char-graphics host for EditForthAnd. Forth owns the cell buffer it blits;
   this file keeps a host copy, a key/mouse queue, and calls Qt UI hooks. */

#include "host_gfx_android.h"

#include <android/log.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define GFX_LOG(...) \
    __android_log_print(ANDROID_LOG_INFO, "EditForthAnd", __VA_ARGS__)

#define KEY_MAX 64

static pthread_mutex_t gfx_mu = PTHREAD_MUTEX_INITIALIZER;
static pthread_mutex_t key_mu = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t key_cv = PTHREAD_COND_INITIALIZER;

static android_gfx_open_fn ui_open;
static android_gfx_close_fn ui_close;
static android_gfx_refresh_fn ui_refresh;
static android_gfx_name_fn ui_name;

static int g_opened;
static int g_cols;
static int g_rows;
static unsigned char g_cells[ANDROID_GFX_CELL_MAX];
static unsigned char *g_pix;
static int g_pix_bytes;
static int g_pix_w;
static int g_pix_h;
static int g_has_pix;
static uint32_t g_pal[256];
static int g_pal_ready;
static long long g_keys[KEY_MAX];
static int g_key_n;
static long long g_mouse_x;
static long long g_mouse_y;
static long long g_mouse_b;
static long long g_pend_cols;
static long long g_pend_rows;
static int g_size_dirty;

static void palette_init(void)
{
    int i;
    int idx;
    int r;
    int g;
    int b;
    static const unsigned char rgb16[16][3] = {
        {0, 0, 0}, {0, 0, 170}, {0, 170, 0}, {0, 170, 170},
        {170, 0, 0}, {170, 0, 170}, {170, 85, 0}, {170, 170, 170},
        {85, 85, 85}, {85, 85, 255}, {85, 255, 85}, {85, 255, 255},
        {255, 85, 85}, {255, 85, 255}, {255, 255, 85}, {255, 255, 255}
    };

    if (g_pal_ready)
        return;
    for (i = 0; i < 16; i++) {
        g_pal[i] = (uint32_t)rgb16[i][2] | ((uint32_t)rgb16[i][1] << 8) |
                   ((uint32_t)rgb16[i][0] << 16) | 0xFF000000u;
    }
    idx = 16;
    for (r = 0; r < 6; r++) {
        for (g = 0; g < 6; g++) {
            for (b = 0; b < 6; b++) {
                g_pal[idx++] = (uint32_t)(b * 51) | ((uint32_t)(g * 51) << 8) |
                               ((uint32_t)(r * 51) << 16) | 0xFF000000u;
            }
        }
    }
    for (i = 0; i < 24; i++) {
        unsigned v = (unsigned)(8 + i * 10);
        if (v > 255)
            v = 255;
        g_pal[232 + i] = v | (v << 8) | (v << 16) | 0xFF000000u;
    }
    g_pal_ready = 1;
}

static void expand_pixels(const unsigned char *src, int n, int depth, int w, int h)
{
    int need;
    int stride;
    int x;
    int y;
    int i;
    unsigned char *dst;
    const unsigned char *row;

    if (w < 1 || h < 1)
        return;
    if (depth == 8) {
        stride = w;
        need = w * h;
    } else if (depth == 32) {
        stride = w * 4;
        need = w * h * 4;
    } else {
        depth = 1;
        stride = (w + 7) / 8;
        need = stride * h;
    }
    if (need <= 0 || need > ANDROID_GFX_PIX_MAX)
        return;
    dst = (unsigned char *)malloc((size_t)w * (size_t)h * 4u);
    if (dst == NULL)
        return;
    if (n > need)
        n = need;
    if (depth == 32) {
        memset(dst, 0, (size_t)w * (size_t)h * 4u);
        if (n > 0)
            memcpy(dst, src, (size_t)n);
        for (i = 3; i < w * h * 4; i += 4) {
            if (dst[i] == 0)
                dst[i] = 255;
        }
    } else if (depth == 8) {
        palette_init();
        for (i = 0; i < w * h; i++) {
            uint32_t c = 0xFF000000u;
            if (i < n)
                c = g_pal[src[i]];
            dst[i * 4] = (unsigned char)(c & 255);
            dst[i * 4 + 1] = (unsigned char)((c >> 8) & 255);
            dst[i * 4 + 2] = (unsigned char)((c >> 16) & 255);
            dst[i * 4 + 3] = 255;
        }
    } else {
        for (y = 0; y < h; y++) {
            row = src + y * stride;
            for (x = 0; x < w; x++) {
                int on = 0;
                int o = (y * w + x) * 4;
                if (y * stride + (x >> 3) < n)
                    on = (row[x >> 3] & (1 << (x & 7))) != 0;
                if (on) {
                    dst[o] = 178;
                    dst[o + 1] = 255;
                    dst[o + 2] = 178;
                    dst[o + 3] = 255;
                } else {
                    dst[o] = 0;
                    dst[o + 1] = 0;
                    dst[o + 2] = 0;
                    dst[o + 3] = 255;
                }
            }
        }
    }
    free(g_pix);
    g_pix = dst;
    g_pix_bytes = w * h * 4;
    g_pix_w = w;
    g_pix_h = h;
    g_has_pix = 1;
}

void android_gfx_set_hooks(android_gfx_open_fn open_fn, android_gfx_close_fn close_fn,
                           android_gfx_refresh_fn refresh_fn, android_gfx_name_fn name_fn)
{
    ui_open = open_fn;
    ui_close = close_fn;
    ui_refresh = refresh_fn;
    ui_name = name_fn;
}

void android_gfx_push_key(long long c)
{
    pthread_mutex_lock(&key_mu);
    if (g_key_n < KEY_MAX)
        g_keys[g_key_n++] = c;
    pthread_cond_signal(&key_cv);
    pthread_mutex_unlock(&key_mu);
}

void android_gfx_set_mouse(long long x, long long y, long long buttons)
{
    pthread_mutex_lock(&gfx_mu);
    g_mouse_x = x;
    g_mouse_y = y;
    g_mouse_b = buttons;
    pthread_mutex_unlock(&gfx_mu);
}

void android_gfx_note_closed(void)
{
    pthread_mutex_lock(&gfx_mu);
    g_opened = 0;
    pthread_mutex_unlock(&gfx_mu);
    android_gfx_push_key(27);
}

int android_gfx_is_open(void)
{
    int on;
    pthread_mutex_lock(&gfx_mu);
    on = g_opened;
    pthread_mutex_unlock(&gfx_mu);
    return on;
}

int android_gfx_copy_cells(unsigned char *dst, int cap, int *cols, int *rows)
{
    int n = 0;
    pthread_mutex_lock(&gfx_mu);
    if (cols)
        *cols = g_cols;
    if (rows)
        *rows = g_rows;
    if (dst != NULL && cap > 0 && g_cols > 0 && g_rows > 0) {
        n = g_cols * g_rows;
        if (n > cap)
            n = cap;
        memcpy(dst, g_cells, (size_t)n);
    }
    pthread_mutex_unlock(&gfx_mu);
    return n;
}

int android_gfx_copy_pixels(unsigned char *dst, int cap, int *w, int *h, int *has)
{
    int n = 0;
    pthread_mutex_lock(&gfx_mu);
    if (has)
        *has = g_has_pix;
    if (w)
        *w = g_pix_w;
    if (h)
        *h = g_pix_h;
    if (dst != NULL && cap > 0 && g_has_pix && g_pix != NULL && g_pix_bytes > 0) {
        n = g_pix_bytes;
        if (n > cap)
            n = cap;
        memcpy(dst, g_pix, (size_t)n);
    }
    pthread_mutex_unlock(&gfx_mu);
    return n;
}

static long long take_key(void)
{
    long long c = -1;
    int i;
    pthread_mutex_lock(&key_mu);
    if (g_key_n > 0) {
        c = g_keys[0];
        for (i = 1; i < g_key_n; i++)
            g_keys[i - 1] = g_keys[i];
        g_key_n--;
    }
    pthread_mutex_unlock(&key_mu);
    return c;
}

long long host_app_open(long long cols, long long rows)
{
    long long ior = -1;
    int c = (int)cols;
    int r = (int)rows;

    if (c < 1)
        c = 80;
    if (r < 1)
        r = 25;
    if (c > ANDROID_GFX_COLS_MAX)
        c = ANDROID_GFX_COLS_MAX;
    if (r > ANDROID_GFX_ROWS_MAX)
        r = ANDROID_GFX_ROWS_MAX;

    pthread_mutex_lock(&key_mu);
    g_key_n = 0;
    pthread_mutex_unlock(&key_mu);

    pthread_mutex_lock(&gfx_mu);
    g_cols = c;
    g_rows = r;
    memset(g_cells, ' ', (size_t)c * (size_t)r);
    free(g_pix);
    g_pix = NULL;
    g_pix_bytes = 0;
    g_pix_w = 0;
    g_pix_h = 0;
    g_has_pix = 0;
    g_mouse_x = 0;
    g_mouse_y = 0;
    g_mouse_b = 0;
    g_size_dirty = 0;
    g_pend_cols = c;
    g_pend_rows = r;
    pthread_mutex_unlock(&gfx_mu);

    if (ui_open == NULL) {
        GFX_LOG("host_app_open %dx%d: no UI hooks", c, r);
        return -1;
    }
    GFX_LOG("host_app_open %dx%d …", c, r);
    ior = ui_open(c, r);
    pthread_mutex_lock(&gfx_mu);
    g_opened = (ior == 0) ? 1 : 0;
    pthread_mutex_unlock(&gfx_mu);
    GFX_LOG("host_app_open → %lld opened=%d", (long long)ior, g_opened);
    return ior;
}

void host_app_close(void)
{
    pthread_mutex_lock(&gfx_mu);
    g_opened = 0;
    free(g_pix);
    g_pix = NULL;
    g_pix_bytes = 0;
    g_pix_w = 0;
    g_pix_h = 0;
    g_has_pix = 0;
    pthread_mutex_unlock(&gfx_mu);
    if (ui_close != NULL)
        ui_close();
    android_gfx_push_key(27);
}

void host_app_blit(const void *addr, long long nbytes)
{
    int need;
    if (addr == NULL || nbytes < 0)
        return;
    pthread_mutex_lock(&gfx_mu);
    if (!g_opened || g_cols < 1 || g_rows < 1) {
        pthread_mutex_unlock(&gfx_mu);
        return;
    }
    need = g_cols * g_rows;
    if (nbytes < need)
        need = (int)nbytes;
    if (need > 0)
        memcpy(g_cells, addr, (size_t)need);
    pthread_mutex_unlock(&gfx_mu);
    if (ui_refresh != NULL)
        ui_refresh();
}

void host_app_cblit(const void *addr, long long nbytes, long long depth)
{
    int w;
    int h;
    int d;

    if (addr == NULL || nbytes <= 0)
        return;
    pthread_mutex_lock(&gfx_mu);
    if (!g_opened || g_cols < 1 || g_rows < 1) {
        pthread_mutex_unlock(&gfx_mu);
        return;
    }
    w = g_cols * 8;
    h = g_rows * 16;
    d = (int)depth;
    if (d != 8 && d != 32)
        d = 1;
    expand_pixels((const unsigned char *)addr, (int)nbytes, d, w, h);
    pthread_mutex_unlock(&gfx_mu);
    if (ui_refresh != NULL)
        ui_refresh();
}

void host_app_pblit(const void *addr, long long nbytes)
{
    host_app_cblit(addr, nbytes, 1);
}

long long host_app_keyq(void)
{
    int n;
    pthread_mutex_lock(&key_mu);
    n = g_key_n;
    pthread_mutex_unlock(&key_mu);
    if (n == 0)
        usleep(1000);
    return n > 0 ? -1 : 0;
}

long long host_app_key(void)
{
    int i;
    long long c;

    c = take_key();
    if (c >= 0)
        return c;
    for (i = 0; i < 20; i++) {
        if (!android_gfx_is_open())
            return 27;
        usleep(25000);
        c = take_key();
        if (c >= 0)
            return c;
    }
    return -1;
}

void host_app_name(const void *addr, long long nbytes)
{
    if (ui_name == NULL)
        return;
    if (addr == NULL || nbytes <= 0) {
        ui_name("EditForthAnd GRAPHICS", 22);
        return;
    }
    ui_name((const char *)addr, nbytes);
}

void host_app_tone(long long freq, long long dur)
{
    (void)freq;
    (void)dur;
    /* No audio host yet. */
}

void host_app_pump(void)
{
    usleep(10000);
}

void host_app_mouse(long long *x, long long *y, long long *buttons)
{
    pthread_mutex_lock(&gfx_mu);
    if (!g_opened) {
        if (x)
            *x = 0;
        if (y)
            *y = 0;
        if (buttons)
            *buttons = 0;
        pthread_mutex_unlock(&gfx_mu);
        return;
    }
    if (x)
        *x = g_mouse_x;
    if (y)
        *y = g_mouse_y;
    if (buttons)
        *buttons = g_mouse_b;
    pthread_mutex_unlock(&gfx_mu);
}

long long host_app_size(long long *cols, long long *rows)
{
    long long flag = 0;
    pthread_mutex_lock(&gfx_mu);
    if (cols)
        *cols = g_pend_cols;
    if (rows)
        *rows = g_pend_rows;
    if (g_size_dirty) {
        g_size_dirty = 0;
        flag = -1;
    }
    pthread_mutex_unlock(&gfx_mu);
    return flag;
}

long long host_app_img_choose(void) { return -1; }
long long host_app_img_load(const void *path, long long nbytes)
{
    (void)path;
    (void)nbytes;
    return -2;
}
void host_app_img_size(long long *w, long long *h)
{
    if (w)
        *w = 0;
    if (h)
        *h = 0;
}
long long host_app_img_render(void *dest, long long dest_w, long long dest_h, long long cx,
                              long long cy, long long zoom100)
{
    (void)dest;
    (void)dest_w;
    (void)dest_h;
    (void)cx;
    (void)cy;
    (void)zoom100;
    return -1;
}
long long host_app_file_choose(void) { return -1; }
long long host_app_file_save_as(void) { return -1; }
long long host_app_file_path(void *dest, long long max)
{
    (void)dest;
    (void)max;
    return -1;
}
long long host_app_file_slurp(void *dest, long long max, long long *out_u)
{
    (void)dest;
    (void)max;
    if (out_u)
        *out_u = 0;
    return -1;
}
long long host_app_file_spew(const void *src, long long nbytes)
{
    (void)src;
    (void)nbytes;
    return -1;
}
long long host_oop_call(long long a, long long b, long long c, long long d, long long op)
{
    (void)a;
    (void)b;
    (void)c;
    (void)d;
    (void)op;
    return 0;
}

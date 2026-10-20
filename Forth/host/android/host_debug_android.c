/* Public domain.
   Editor debug span + pause paint for in-process Android (mirrors debug_win.c). */

#include "host_debug_android.h"

#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern uint64_t debug_armed;
extern uint64_t debug_busy;
extern uint64_t debug_cfa;
extern uint64_t debug_xt;
extern uint64_t debug_bp_go;
extern uint64_t debug_break_asap;
extern unsigned char debug_name[];
extern unsigned char view_paths[];
extern uint64_t view_file_n;

static int64_t span_off;
static int64_t span_len;
static android_debug_flush_fn debug_flush;
static android_debug_paint_fn debug_paint;

static pthread_mutex_t key_mu = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t key_cv = PTHREAD_COND_INITIALIZER;
static int key_pending = -1;
static int key_quit;

void android_debug_set_hooks(android_debug_flush_fn flush, android_debug_paint_fn paint)
{
    debug_flush = flush;
    debug_paint = paint;
}

void host_debug_set_span(int64_t off, int64_t len)
{
    if (len > 0 && off >= 0) {
        span_off = off;
        span_len = len;
    } else {
        span_off = 0;
        span_len = 0;
    }
}

void host_debug_get_span(int64_t *off, int64_t *len)
{
    if (off != NULL)
        *off = span_off;
    if (len != NULL)
        *len = span_len;
}

static int stamped_path(uint64_t cfa, char *path, int cap, int *line)
{
    uint64_t flags;
    uint64_t file;
    uint64_t ln;
    const unsigned char *slot;
    int n;

    if (cfa == 0 || (cfa & 7) != 0 || cap < 2)
        return 0;
    flags = *(uint64_t *)(uintptr_t)(cfa - 8);
    ln = (flags >> 32) & 0xFFFFULL;
    file = (flags >> 48) & 0x1FFFULL;
    if (ln == 0 || file == 0 || file > view_file_n || file > 256)
        return 0;
    slot = view_paths + (size_t)(file - 1) * 256;
    n = slot[0];
    if (n <= 0 || n > 255)
        return 0;
    if (n >= cap)
        n = cap - 1;
    memcpy(path, slot + 1, (size_t)n);
    path[n] = '\0';
    *line = (int)ln;
    return 1;
}

static void copy_pause_name(char *dst, int cap)
{
    int n;
    int i;

    dst[0] = '\0';
    if (cap < 2)
        return;
    n = debug_name[0];
    if (n <= 0 || n > 31)
        return;
    if (n >= cap)
        n = cap - 1;
    for (i = 0; i < n; i++) {
        unsigned char c = debug_name[1 + i];
        if (c < 32 || c > 126) {
            dst[0] = '\0';
            return;
        }
        dst[i] = (char)c;
    }
    dst[n] = '\0';
}

void host_debug_paint(void)
{
    char path[512];
    char name[40];
    int line = 0;
    int off = 0;
    int len = 0;
    int armed;
    int paused;

    armed = debug_armed != 0;
    paused = armed && debug_busy != 0;
    path[0] = '\0';
    name[0] = '\0';
    if (paused) {
        if (!stamped_path(debug_cfa, path, (int)sizeof path, &line)) {
            line = 0;
            path[0] = '\0';
            if (!stamped_path(debug_xt, path, (int)sizeof path, &line)) {
                line = 0;
                path[0] = '\0';
            }
        }
        copy_pause_name(name, (int)sizeof name);
        if (span_len > 0 && span_off >= 0 && span_off <= 0x7FFFFFFF &&
            span_len <= 0x7FFFFFFF) {
            off = (int)span_off;
            len = (int)span_len;
        }
    }
    span_off = 0;
    span_len = 0;
    if (debug_flush != NULL)
        debug_flush();
    if (debug_paint != NULL)
        debug_paint(armed, paused, line, off, len, name, path);
}

void android_debug_clear_key(void)
{
    pthread_mutex_lock(&key_mu);
    key_pending = -1;
    key_quit = 0;
    pthread_mutex_unlock(&key_mu);
}

void android_debug_request_quit(void)
{
    pthread_mutex_lock(&key_mu);
    key_quit = 1;
    key_pending = 27;
    pthread_cond_broadcast(&key_cv);
    pthread_mutex_unlock(&key_mu);
}

void android_debug_post_key(int key)
{
    pthread_mutex_lock(&key_mu);
    key_pending = key;
    pthread_cond_signal(&key_cv);
    pthread_mutex_unlock(&key_mu);
}

void android_debug_post_arm(void)
{
    debug_bp_go = 1;
    android_debug_post_key('g');
}

int android_debug_signal_break(void)
{
    debug_break_asap = 1;
    return 1;
}

int android_debug_key(void)
{
    int k;

    if (debug_busy == 0)
        return -1;
    pthread_mutex_lock(&key_mu);
    while (key_pending < 0 && key_quit == 0)
        pthread_cond_wait(&key_cv, &key_mu);
    k = key_quit ? 27 : key_pending;
    key_pending = -1;
    pthread_mutex_unlock(&key_mu);
    return k;
}

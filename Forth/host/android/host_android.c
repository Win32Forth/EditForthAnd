/* Public domain.
   Minimal Android/Bionic host for the EditForthAnd native kernel.
   Emit goes to a buffer that ForthPipe_android reads after kernel_eval.
   Most facility/file/graphics calls are stubs until ported. */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include "emit_buf.h"
#include "host_view.h"

void host_outs(const char *s);

/* ---- time ---- */

unsigned long long host_ms(void)
{
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0)
        return 0;
    return (unsigned long long)ts.tv_sec * 1000ull +
           (unsigned long long)ts.tv_nsec / 1000000ull;
}

void host_sleep(long long ms)
{
    if (ms > 0)
        usleep((useconds_t)(ms * 1000));
}

void host_time_date(long long *y, long long *mo, long long *d, long long *h,
                    long long *mi, long long *s)
{
    time_t now = time(NULL);
    struct tm tm;
    localtime_r(&now, &tm);
    if (y) *y = tm.tm_year + 1900;
    if (mo) *mo = tm.tm_mon + 1;
    if (d) *d = tm.tm_mday;
    if (h) *h = tm.tm_hour;
    if (mi) *mi = tm.tm_min;
    if (s) *s = tm.tm_sec;
}

/* ---- memory ---- */

void *host_alloc(unsigned long long n)
{
    return n ? malloc((size_t)n) : NULL;
}

void host_free(void *p)
{
    free(p);
}

void *host_alloc_exec(unsigned long long n)
{
    return host_alloc(n);
}

void host_free_exec(void *p)
{
    host_free(p);
}

void host_mprotect(void *p, unsigned long long n, long long prot)
{
    (void)p;
    (void)n;
    (void)prot;
}

void host_icache_inval(void *p, unsigned long long n)
{
    (void)p;
    (void)n;
}

void host_resize(void)
{
}

long long host_native_ret7(long long a, long long b, long long c, long long d,
                           long long e, long long f, long long g)
{
    (void)a; (void)b; (void)c; (void)d; (void)e; (void)f; (void)g;
    return 0;
}

/* Path/file ops live in host_file_android.c. */

long long host_accept(char *buf, long long n)
{
    (void)buf; (void)n;
    return 0;
}

long long host_system(const char *cmd, long long n) { (void)cmd; (void)n; return -1; }
void host_edit(const char *p, long long n)
{
    android_edit_post(p, n, 1);
}
void host_edit_at(const char *p, long long n, long long line)
{
    android_edit_post(p, n, line > 0 ? line : 1);
}
long long host_include_dialog(void) { return 0; }

void host_clip_set(const char *p, long long n) { (void)p; (void)n; }
long long host_clip_get(char *dst, long long cap)
{
    if (dst && cap > 0)
        dst[0] = '\0';
    return 0;
}

void host_facility_xy(long long *x, long long *y)
{
    if (x) *x = 0;
    if (y) *y = 0;
}

/* ---- debug paint stubs ---- */

void host_debug_paint(void) {}
void host_debug_set_span(int64_t off, int64_t len) { (void)off; (void)len; }
void host_debug_get_span(int64_t *off, int64_t *len)
{
    if (off) *off = 0;
    if (len) *len = 0;
}

/* ---- graphics / app stubs ---- */

long long host_app_open(long long cols, long long rows)
{
    (void)cols; (void)rows;
    return 0;
}
void host_app_close(void) {}
void host_app_blit(const void *addr, long long nbytes) { (void)addr; (void)nbytes; }
void host_app_cblit(const void *addr, long long nbytes, long long depth)
{
    (void)addr; (void)nbytes; (void)depth;
}
void host_app_pblit(const void *addr, long long nbytes) { (void)addr; (void)nbytes; }
long long host_app_keyq(void) { return 0; }
long long host_app_key(void) { return -1; }
void host_app_name(const void *addr, long long nbytes) { (void)addr; (void)nbytes; }
void host_app_tone(long long freq, long long dur) { (void)freq; (void)dur; }
void host_app_pump(void) {}
void host_app_mouse(long long *x, long long *y, long long *buttons)
{
    if (x) *x = 0;
    if (y) *y = 0;
    if (buttons) *buttons = 0;
}
long long host_app_size(long long *cols, long long *rows)
{
    if (cols) *cols = 0;
    if (rows) *rows = 0;
    return 0;
}
long long host_app_img_choose(void) { return 0; }
long long host_app_img_load(const void *path, long long nbytes)
{
    (void)path; (void)nbytes;
    return 0;
}
void host_app_img_size(long long *w, long long *h)
{
    if (w) *w = 0;
    if (h) *h = 0;
}
long long host_app_img_render(void *dest, long long dest_w, long long dest_h,
                              long long a, long long b)
{
    (void)dest; (void)dest_w; (void)dest_h; (void)a; (void)b;
    return 0;
}
long long host_app_file_choose(void) { return 0; }
long long host_app_file_save_as(void) { return 0; }
long long host_app_file_path(void *dest, long long max)
{
    (void)dest; (void)max;
    return 0;
}
long long host_app_file_slurp(void *dest, long long max, long long *out_u)
{
    (void)dest; (void)max;
    if (out_u) *out_u = 0;
    return 0;
}
long long host_app_file_spew(const void *src, long long nbytes)
{
    (void)src; (void)nbytes;
    return 0;
}
long long host_oop_call(long long a, long long b, long long c, long long d, long long op)
{
    (void)a; (void)b; (void)c; (void)d; (void)op;
    return 0;
}

/* ---- bigint stubs ---- */

void host_bi_mul(long long a, long long b, long long r)
{
    (void)a; (void)b; (void)r;
}
void host_bi_divmod(long long num, long long den, long long quot, long long rem)
{
    (void)num; (void)den; (void)quot; (void)rem;
}
void host_bi_isqrt(long long a, long long r) { (void)a; (void)r; }

/* ---- console helpers used by float host / SA-PRINT ---- */

void host_outs(const char *s)
{
    if (s == NULL)
        return;
    while (*s)
        emit_buf_putc((unsigned char)*s++);
}

void host_out(const void *p, size_t n)
{
    const unsigned char *b = (const unsigned char *)p;
    size_t i;
    if (b == NULL)
        return;
    for (i = 0; i < n; i++)
        emit_buf_putc(b[i]);
}

/* Stand-alone (SA-PRINT) calls this when the emit hook cell is zero. */
void sa_win_putchar(unsigned long long c)
{
    emit_buf_putc((int)(unsigned char)c);
}

/* sa_win_file_op is implemented in host_file_android.c. */

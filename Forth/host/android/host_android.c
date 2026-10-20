/* Public domain.
   Minimal Android/Bionic host for the EditForthAnd native kernel.
   Emit goes to a buffer that ForthPipe_android reads after kernel_eval.
   Facility/file stubs remain here; GRAPHICS is in host_gfx_android.c. */

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

/* Kernel passes one pointer to int64 out[6]: sec, min, hour, day, month, year. */
void host_time_date(long long *out)
{
    time_t now;
    struct tm tm;

    if (out == NULL)
        return;
    now = time(NULL);
    if (localtime_r(&now, &tm) == NULL) {
        out[0] = 0;
        out[1] = 0;
        out[2] = 0;
        out[3] = 1;
        out[4] = 1;
        out[5] = 1970;
        return;
    }
    out[0] = tm.tm_sec;
    out[1] = tm.tm_min;
    out[2] = tm.tm_hour;
    out[3] = tm.tm_mday;
    out[4] = tm.tm_mon + 1;
    out[5] = tm.tm_year + 1900;
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

/* host_debug_paint / set_span / get_span live in host_debug_android.c */
/* host_app_* / host_oop_call live in host_gfx_android.c */

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

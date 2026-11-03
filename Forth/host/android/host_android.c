/* Public domain.
   Minimal Android/Bionic host for the EditForthAnd native kernel.
   Emit goes to a buffer that ForthPipe_android reads after kernel_eval.
   Facility/file stubs remain here; GRAPHICS is in host_gfx_android.c. */

#define _GNU_SOURCE

#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

/* Bionic declares posix_spawn only when __ANDROID_API__ >= 28.
   minSdk is 26, and ANDROID_PLATFORM android-26 compiles this file at API 26,
   so that call is a hard error. API 26 and 27 launch with fork/exec.
   API 28 and later, and the Linux smoke build, keep posix_spawn. */
#if defined(__ANDROID__) && __ANDROID_API__ < 28
#define HOST_SYSTEM_USE_FORK 1
#else
#define HOST_SYSTEM_USE_FORK 0
#include <spawn.h>
#endif

#include "emit_buf.h"
#include "host_view.h"

extern char **environ;

void host_outs(const char *s);
void host_out(const void *p, size_t n);

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

static void drain_fd(int fd)
{
    char buf[1024];
    ssize_t got;

    if (fd < 0)
        return;
    for (;;) {
        got = read(fd, buf, sizeof buf);
        if (got <= 0)
            return;
        host_out(buf, (size_t)got);
    }
}

static const char *android_shell(void)
{
    if (access("/system/bin/sh", X_OK) == 0)
        return "/system/bin/sh";
    return "/bin/sh";
}

/* Launch sh -c. Returns 0 and stores the child pid, or -1. */
static int launch_shell(char *line, int out_wr, int err_wr, int out_rd, int err_rd,
                        pid_t *pid_out)
{
#if HOST_SYSTEM_USE_FORK
    pid_t pid;
    int nul;
    const char *shell = android_shell();

    pid = fork();
    if (pid < 0)
        return -1;
    if (pid == 0) {
        nul = open("/dev/null", O_RDONLY);
        if (nul >= 0) {
            dup2(nul, STDIN_FILENO);
            if (nul > STDERR_FILENO)
                close(nul);
        }
        dup2(out_wr, STDOUT_FILENO);
        dup2(err_wr, STDERR_FILENO);
        if (out_rd >= 0)
            close(out_rd);
        if (err_rd >= 0)
            close(err_rd);
        if (out_wr > STDERR_FILENO)
            close(out_wr);
        if (err_wr > STDERR_FILENO && err_wr != out_wr)
            close(err_wr);
        execl(shell, "sh", "-c", line, (char *)NULL);
        _exit(127);
    }
    *pid_out = pid;
    return 0;
#else
    posix_spawn_file_actions_t actions;
    char *argv[4];
    int spawned;

    if (posix_spawn_file_actions_init(&actions) != 0)
        return -1;
    if (posix_spawn_file_actions_addopen(&actions, STDIN_FILENO, "/dev/null",
                                         O_RDONLY, 0) != 0 ||
        posix_spawn_file_actions_adddup2(&actions, out_wr, STDOUT_FILENO) != 0 ||
        posix_spawn_file_actions_adddup2(&actions, err_wr, STDERR_FILENO) != 0 ||
        posix_spawn_file_actions_addclose(&actions, out_rd) != 0 ||
        posix_spawn_file_actions_addclose(&actions, err_rd) != 0 ||
        posix_spawn_file_actions_addclose(&actions, out_wr) != 0 ||
        posix_spawn_file_actions_addclose(&actions, err_wr) != 0) {
        posix_spawn_file_actions_destroy(&actions);
        return -1;
    }
    argv[0] = (char *)"sh";
    argv[1] = (char *)"-c";
    argv[2] = line;
    argv[3] = NULL;
    spawned = posix_spawn(pid_out, android_shell(), &actions, NULL, argv, environ);
    posix_spawn_file_actions_destroy(&actions);
    return spawned == 0 ? 0 : -1;
#endif
}

/* SYSTEM ( c-addr u -- n ). Run via sh -c in the Forth cwd.
   stdout and stderr are emitted. n is the exit status, or -1. */
long long host_system(const char *cmd, long long n)
{
    char *line = NULL;
    int out_pipe[2] = {-1, -1};
    int err_pipe[2] = {-1, -1};
    pid_t pid = 0;
    int start;
    int end;
    int status = 0;
    long long rc = -1;
    int waited_ms = 0;
    const int limit_ms = 20000;

    if (cmd == NULL || n <= 0) {
        host_outs("SYSTEM: empty command\n");
        return -1;
    }
    if (n > 8192) {
        host_outs("SYSTEM: command is too long\n");
        return -1;
    }
    start = 0;
    end = (int)n;
    while (start < end && (cmd[start] == ' ' || cmd[start] == '\t' ||
                           cmd[start] == '\r' || cmd[start] == '\n'))
        start++;
    while (end > start && (cmd[end - 1] == ' ' || cmd[end - 1] == '\t' ||
                           cmd[end - 1] == '\r' || cmd[end - 1] == '\n'))
        end--;
    if (end <= start) {
        host_outs("SYSTEM: empty command\n");
        return -1;
    }
    line = (char *)malloc((size_t)(end - start) + 1);
    if (line == NULL) {
        host_outs("SYSTEM: failed to launch\n");
        return -1;
    }
    memcpy(line, cmd + start, (size_t)(end - start));
    line[end - start] = '\0';
    if (pipe(out_pipe) != 0 || pipe(err_pipe) != 0) {
        host_outs("SYSTEM: failed to launch\n");
        free(line);
        if (out_pipe[0] >= 0) {
            close(out_pipe[0]);
            close(out_pipe[1]);
        }
        if (err_pipe[0] >= 0) {
            close(err_pipe[0]);
            close(err_pipe[1]);
        }
        return -1;
    }
    if (launch_shell(line, out_pipe[1], err_pipe[1], out_pipe[0], err_pipe[0], &pid) != 0) {
        host_outs("SYSTEM: failed to launch\n");
        pid = 0;
        goto done;
    }
    close(out_pipe[1]);
    out_pipe[1] = -1;
    close(err_pipe[1]);
    err_pipe[1] = -1;
    free(line);
    line = NULL;
    for (;;) {
        fd_set rfds;
        struct timeval tv;
        int maxfd = -1;
        int ready;

        FD_ZERO(&rfds);
        if (out_pipe[0] >= 0) {
            FD_SET(out_pipe[0], &rfds);
            maxfd = out_pipe[0];
        }
        if (err_pipe[0] >= 0) {
            FD_SET(err_pipe[0], &rfds);
            if (err_pipe[0] > maxfd)
                maxfd = err_pipe[0];
        }
        tv.tv_sec = 0;
        tv.tv_usec = 30000;
        ready = (maxfd < 0) ? 0 : select(maxfd + 1, &rfds, NULL, NULL, &tv);
        if (ready > 0) {
            if (out_pipe[0] >= 0 && FD_ISSET(out_pipe[0], &rfds)) {
                char buf[1024];
                ssize_t got = read(out_pipe[0], buf, sizeof buf);
                if (got > 0)
                    host_out(buf, (size_t)got);
                else {
                    close(out_pipe[0]);
                    out_pipe[0] = -1;
                }
            }
            if (err_pipe[0] >= 0 && FD_ISSET(err_pipe[0], &rfds)) {
                char buf[1024];
                ssize_t got = read(err_pipe[0], buf, sizeof buf);
                if (got > 0)
                    host_out(buf, (size_t)got);
                else {
                    close(err_pipe[0]);
                    err_pipe[0] = -1;
                }
            }
        }
        if (pid > 0 && waitpid(pid, &status, WNOHANG) == pid) {
            pid = 0;
            break;
        }
        waited_ms += 30;
        if (waited_ms > limit_ms) {
            if (pid > 0)
                kill(pid, SIGKILL);
            host_outs("SYSTEM: timed out\n");
            if (pid > 0)
                waitpid(pid, &status, 0);
            pid = 0;
            rc = -1;
            goto done;
        }
    }
    if (out_pipe[0] >= 0)
        drain_fd(out_pipe[0]);
    if (err_pipe[0] >= 0)
        drain_fd(err_pipe[0]);
    if (WIFEXITED(status))
        rc = WEXITSTATUS(status);
    else if (WIFSIGNALED(status))
        rc = 128 + WTERMSIG(status);
    else
        rc = -1;
done:
    if (out_pipe[0] >= 0)
        close(out_pipe[0]);
    if (out_pipe[1] >= 0)
        close(out_pipe[1]);
    if (err_pipe[0] >= 0)
        close(err_pipe[0]);
    if (err_pipe[1] >= 0)
        close(err_pipe[1]);
    free(line);
    if (pid > 0) {
        kill(pid, SIGKILL);
        waitpid(pid, &status, 0);
    }
    return rc;
}
void host_edit(const char *p, long long n)
{
    android_edit_post(p, n, 1);
}
void host_edit_at(const char *p, long long n, long long line)
{
    android_edit_post(p, n, line > 0 ? line : 1);
}
long long host_include_dialog(void) { return 0; }

static android_clip_set_fn clip_set_fn;
static android_clip_get_fn clip_get_fn;

void android_host_set_clip_hooks(android_clip_set_fn set, android_clip_get_fn get)
{
    clip_set_fn = set;
    clip_get_fn = get;
}

void host_clip_set(const char *p, long long n)
{
    if (clip_set_fn != NULL)
        clip_set_fn(p, n);
}

long long host_clip_get(char *dst, long long cap)
{
    if (clip_get_fn != NULL)
        return clip_get_fn(dst, cap);
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

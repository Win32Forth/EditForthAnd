#include "emit_buf.h"

#include <android/log.h>
#include <string.h>

#define EMIT_CAP 65536
#define EMIT_FLUSH_AT 4096

static char g_buf[EMIT_CAP];
static size_t g_len;
static emit_buf_flush_fn g_flush;
static char g_line[512];
static size_t g_line_len;

void emit_buf_set_flush(emit_buf_flush_fn flush)
{
    g_flush = flush;
}

static void log_line_flush(void)
{
    if (g_line_len == 0)
        return;
    g_line[g_line_len] = '\0';
    __android_log_print(ANDROID_LOG_INFO, "EditForthAnd", "%s", g_line);
    g_line_len = 0;
}

void emit_buf_reset(void)
{
    log_line_flush();
    g_len = 0;
    g_buf[0] = '\0';
}

static void maybe_flush_ui(int force)
{
    if (g_flush == NULL || g_len == 0)
        return;
    if (!force && g_len < EMIT_FLUSH_AT)
        return;
    g_flush();
}

void emit_buf_putc(int c)
{
    unsigned char ch = (unsigned char)c;

    if (ch == '\r')
        return;

    if (ch == '\n') {
        log_line_flush();
    } else if (g_line_len + 1 < sizeof g_line) {
        g_line[g_line_len++] = (char)ch;
    } else {
        log_line_flush();
        g_line[g_line_len++] = (char)ch;
    }

    if (g_len + 1 >= EMIT_CAP) {
        maybe_flush_ui(1);
        if (g_len + 1 >= EMIT_CAP)
            return;
    }
    g_buf[g_len++] = (char)ch;
    g_buf[g_len] = '\0';
    if (ch == '\n')
        maybe_flush_ui(0);
}

void android_emit_char(int c)
{
    emit_buf_putc(c);
}

const char *emit_buf_text(void)
{
    return g_buf;
}

size_t emit_buf_len(void)
{
    return g_len;
}

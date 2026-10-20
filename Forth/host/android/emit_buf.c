#include "emit_buf.h"

#include <string.h>

#define EMIT_CAP 65536

static char g_buf[EMIT_CAP];
static size_t g_len;

void emit_buf_reset(void)
{
    g_len = 0;
    g_buf[0] = '\0';
}

void emit_buf_putc(int c)
{
    unsigned char ch = (unsigned char)c;
    if (g_len + 1 >= EMIT_CAP)
        return;
    g_buf[g_len++] = (char)ch;
    g_buf[g_len] = '\0';
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

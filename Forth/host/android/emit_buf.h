#ifndef EDITFORTHAND_EMIT_BUF_H
#define EDITFORTHAND_EMIT_BUF_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

void emit_buf_reset(void);
void emit_buf_putc(int c);
const char *emit_buf_text(void);
size_t emit_buf_len(void);

/* Char emit hook installed into the kernel via kernel_set_emit. */
void android_emit_char(int c);

#ifdef __cplusplus
}
#endif

#endif

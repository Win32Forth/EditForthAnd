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

/* Optional live flush (e.g. to the Qt console). Called from emit on newlines
   and when the buffer nears capacity so long FLOAD/ANS/Hayes do not truncate. */
typedef void (*emit_buf_flush_fn)(void);
void emit_buf_set_flush(emit_buf_flush_fn flush);

/* Char emit hook installed into the kernel via kernel_set_emit. */
void android_emit_char(int c);

#ifdef __cplusplus
}
#endif

#endif

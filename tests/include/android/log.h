#pragma once

/* Host stand-in for <android/log.h> so emit_buf.c links on Linux. */
#define ANDROID_LOG_INFO 4

static inline int __android_log_print(int prio, const char *tag, const char *fmt, ...)
{
    (void)prio;
    (void)tag;
    (void)fmt;
    return 0;
}

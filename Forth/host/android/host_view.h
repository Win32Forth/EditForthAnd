#ifndef EDITFORTHAND_HOST_VIEW_H
#define EDITFORTHAND_HOST_VIEW_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Same jobs as companion.c send_last / send_view, for in-process Android. */
int android_last_name(char *dst, size_t cap);
/* Returns 0 ok (path filled), -1 missing/undefined. line is 1-based. */
int android_view_word(const char *name, char *path, size_t path_cap, long long *line);

/* Pending host_edit_at request for ForthPipe to turn into editReceived. */
void android_edit_clear(void);
void android_edit_post(const char *p, long long n, long long line);
int android_edit_take(char *path, size_t path_cap, long long *line);

#ifdef __cplusplus
}
#endif

#endif

/* Public domain.
   In-process debugger bridge for EditForthAnd (paint notify + KEY queue). */

#ifndef EDITFORTHAND_HOST_DEBUG_ANDROID_H
#define EDITFORTHAND_HOST_DEBUG_ANDROID_H

#ifdef __cplusplus
extern "C" {
#endif

/* Flush pending Forth emit before a debug JSON/UI update. */
typedef void (*android_debug_flush_fn)(void);
/* Deliver a pause/arm paint to the UI (may be called from the Forth thread). */
typedef void (*android_debug_paint_fn)(int armed, int paused, int line, int off, int len,
                                      const char *name, const char *path);

void android_debug_set_hooks(android_debug_flush_fn flush, android_debug_paint_fn paint);

/* Install as kernel_set_key. Blocks while debug_busy until post_key / quit. */
int android_debug_key(void);

void android_debug_post_key(int key);
/* Continue from pause: set debug_bp_go and deliver 'g'. */
void android_debug_post_arm(void);
/* Async pause request while Forth is running. */
int android_debug_signal_break(void);
/* Wake a blocked KEY with ESC (shutdown / stop engine). */
void android_debug_request_quit(void);
void android_debug_clear_key(void);

#ifdef __cplusplus
}
#endif

#endif

/* Public domain.
   Android GRAPHICS host (char + pixel window) + hooks into the Qt overlay. */

#ifndef EDITFORTHAND_HOST_GFX_ANDROID_H
#define EDITFORTHAND_HOST_GFX_ANDROID_H

#ifdef __cplusplus
extern "C" {
#endif

#define ANDROID_GFX_COLS_MAX 256
#define ANDROID_GFX_ROWS_MAX 128
#define ANDROID_GFX_CELL_MAX (ANDROID_GFX_COLS_MAX * ANDROID_GFX_ROWS_MAX)
#define ANDROID_GFX_PIX_MAX (16 * 1024 * 1024)

/* UI-thread hooks installed by GraphicsBridge. open returns 0 ok, -1 fail. */
typedef long long (*android_gfx_open_fn)(long long cols, long long rows);
typedef void (*android_gfx_close_fn)(void);
typedef void (*android_gfx_refresh_fn)(void);
typedef void (*android_gfx_name_fn)(const char *title, long long nbytes);

void android_gfx_set_hooks(android_gfx_open_fn open_fn, android_gfx_close_fn close_fn,
                           android_gfx_refresh_fn refresh_fn, android_gfx_name_fn name_fn);

/* Called from the Qt graphics widget (UI thread). */
void android_gfx_push_key(long long c);
void android_gfx_set_mouse(long long x, long long y, long long buttons);
void android_gfx_note_closed(void);

/* Snapshot cells for paint. Returns byte count copied; fills cols/rows. */
int android_gfx_copy_cells(unsigned char *dst, int cap, int *cols, int *rows);
/* Snapshot BGRA pixels (w*h*4). has=1 when a cblit is live. Returns bytes. */
int android_gfx_copy_pixels(unsigned char *dst, int cap, int *w, int *h, int *has);
int android_gfx_is_open(void);

#ifdef __cplusplus
}
#endif

#endif

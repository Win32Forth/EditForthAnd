/* Public domain.
   Android POSIX file host for EditForthAnd. */

#ifndef HOST_FILE_ANDROID_H
#define HOST_FILE_ANDROID_H

#ifdef __cplusplus
extern "C" {
#endif

/* Set the AppDataLocation/EditForthAnd tree as user root, derive Library,
   and chdir there. Call once before kernel_init / INCLUDE. */
void android_host_set_roots(const char *user_root_path);

/* After kernel_init: evaluate AutoLoad/autoload.fth as one buffer (same as
   Windows forth_autoload), then run MAIN if defined. No-op if missing. */
void android_host_autoload(void);

#ifdef __cplusplus
}
#endif

#endif

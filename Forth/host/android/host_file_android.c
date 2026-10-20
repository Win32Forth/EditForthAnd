/* Public domain.
   POSIX file host for EditForthAnd (Android/Bionic).
   Mirrors Forth/host/main.c file ops used by (SA-FILES) / INCLUDE. */

#include "host_file_android.h"

#include "kernel_api.h"

#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fnmatch.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#ifndef HOST_FILES
#define HOST_FILES 16
#endif
#ifndef HOST_PATH
#define HOST_PATH 1024
#endif
#ifndef HOST_LOADS
#define HOST_LOADS 8
#endif
#ifndef HOST_REGS
#define HOST_REGS 64
#endif

/* Windows FILE_ATTRIBUTE_DIRECTORY bit — FILE-STATUS consumers often test it. */
#ifndef FILE_ATTR_DIRECTORY
#define FILE_ATTR_DIRECTORY 0x10
#endif
#ifndef FILE_ATTR_NORMAL
#define FILE_ATTR_NORMAL 0x80
#endif

void host_outs(const char *s);
void host_out(const void *p, size_t n);

static FILE *host_fp[HOST_FILES];
static char *host_mem[HOST_FILES];
static long long host_mem_len[HOST_FILES];
static long long host_mem_pos[HOST_FILES];
static char load_dir[HOST_LOADS][HOST_PATH];
static char load_prev[HOST_LOADS][HOST_PATH];
static int load_len[HOST_LOADS];
static int load_n;
static int fromlib_armed;
static char user_root[HOST_PATH];
static char library_root[HOST_PATH];
static char reg_path[HOST_REGS][256];
static int reg_len[HOST_REGS];
static int reg_n;
static char last_path[256];
static int last_len;

static void host_slashes(char *s)
{
    for (; s != NULL && *s != '\0'; s++) {
        if (*s == '\\')
            *s = '/';
    }
}

static int host_abs(const char *s, long long n)
{
    if (n >= 1 && (s[0] == '/' || s[0] == '~'))
        return 1;
    return 0;
}

static int host_is_dir(const char *path)
{
    struct stat st;
    if (path == NULL || path[0] == '\0')
        return 0;
    if (stat(path, &st) != 0)
        return 0;
    return S_ISDIR(st.st_mode);
}

static int host_is_file(const char *path)
{
    struct stat st;
    if (path == NULL || path[0] == '\0')
        return 0;
    if (stat(path, &st) != 0)
        return 0;
    return S_ISREG(st.st_mode);
}

static int host_ci_eq(const char *a, const char *b)
{
    unsigned char ca;
    unsigned char cb;

    if (a == NULL || b == NULL)
        return 0;
    while (*a != '\0' && *b != '\0') {
        ca = (unsigned char)*a++;
        cb = (unsigned char)*b++;
        if (ca >= 'A' && ca <= 'Z')
            ca = (unsigned char)(ca + 32);
        if (cb >= 'A' && cb <= 'Z')
            cb = (unsigned char)(cb + 32);
        if (ca != cb)
            return 0;
    }
    return *a == '\0' && *b == '\0';
}

static int host_ci_prefix(const char *s, const char *prefix)
{
    unsigned char ca;
    unsigned char cb;

    if (s == NULL || prefix == NULL)
        return 0;
    while (*prefix != '\0') {
        if (*s == '\0')
            return 0;
        ca = (unsigned char)*s++;
        cb = (unsigned char)*prefix++;
        if (ca >= 'A' && ca <= 'Z')
            ca = (unsigned char)(ca + 32);
        if (cb >= 'A' && cb <= 'Z')
            cb = (unsigned char)(cb + 32);
        if (ca != cb)
            return 0;
    }
    return 1;
}

/* Library/… (and AutoLoad/Docs/Config) are rooted at the Forth user tree,
   even while INCLUDE has pushed AutoLoad/ as load-cwd for sibling scripts.
   Matches autoload.fth: paths relative to the EditForthAnd root, not AutoLoad. */
static int host_is_user_tree_rel(const char *s)
{
    static const char *roots[] = {"Library/", "AutoLoad/", "Docs/", "Config/"};
    size_t i;

    if (s == NULL || s[0] == '\0')
        return 0;
    for (i = 0; i < sizeof roots / sizeof roots[0]; i++) {
        if (host_ci_prefix(s, roots[i]))
            return 1;
    }
    /* Bare folder name with no slash still counts (e.g. DIR Library). */
    if (host_ci_eq(s, "Library") || host_ci_eq(s, "AutoLoad") ||
        host_ci_eq(s, "Docs") || host_ci_eq(s, "Config"))
        return 1;
    return 0;
}

/* Android volumes are case-sensitive; Win32Forth sources assume Windows case
   folding (autoload vs AutoLoad, HYPER vs Hyper). SELinux blocks opendir("/"),
   so folding only walks components under the app-owned user_root. */
static int host_case_fold(char *path, size_t cap)
{
    char built[HOST_PATH];
    char rest[HOST_PATH];
    char *save = NULL;
    char *tok;
    size_t out;
    size_t root_n;
    const char *suffix;
    struct stat st;

    if (path == NULL || cap < 2 || path[0] == '\0')
        return 0;
    if (stat(path, &st) == 0)
        return 1;
    if (user_root[0] == '\0')
        return 0;
    root_n = strlen(user_root);
    if (root_n == 0 || root_n >= sizeof built)
        return 0;
    /* Path must live under the Forth root (exact prefix we chdir'd to). */
    if (strncmp(path, user_root, root_n) != 0)
        return 0;
    if (path[root_n] != '\0' && path[root_n] != '/')
        return 0;
    if (stat(user_root, &st) != 0)
        return 0;
    memcpy(built, user_root, root_n + 1);
    out = root_n;
    suffix = path + root_n;
    if (*suffix == '/')
        suffix++;
    if (*suffix == '\0')
        return 1;
    if (strlen(suffix) >= sizeof rest)
        return 0;
    memcpy(rest, suffix, strlen(suffix) + 1);
    for (tok = strtok_r(rest, "/", &save); tok != NULL; tok = strtok_r(NULL, "/", &save)) {
        DIR *dir;
        struct dirent *ent;
        int matched = 0;
        size_t tl;

        dir = opendir(built);
        if (dir == NULL)
            return 0;
        while ((ent = readdir(dir)) != NULL) {
            if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
                continue;
            if (!host_ci_eq(ent->d_name, tok))
                continue;
            tl = strlen(ent->d_name);
            if (out + 1 + tl >= sizeof built) {
                closedir(dir);
                return 0;
            }
            built[out++] = '/';
            memcpy(built + out, ent->d_name, tl + 1);
            out += tl;
            matched = 1;
            break;
        }
        closedir(dir);
        if (!matched)
            return 0;
    }
    if (out >= cap)
        return 0;
    memcpy(path, built, out + 1);
    return stat(path, &st) == 0;
}

static int host_join(char *dst, int cap, const char *dir, const char *rel)
{
    int n;
    int m;

    if (dst == NULL || cap < 4 || dir == NULL || rel == NULL)
        return 0;
    n = (int)strlen(dir);
    m = (int)strlen(rel);
    if (n <= 0 || n + 1 + m >= cap)
        return 0;
    memcpy(dst, dir, (size_t)n);
    if (dst[n - 1] != '/')
        dst[n++] = '/';
    memcpy(dst + n, rel, (size_t)m + 1);
    return 1;
}

/* Collapse . and .. and duplicate slashes. Does not require the path to exist. */
static int host_normalize(char *dst, size_t cap, const char *src)
{
    char tmp[HOST_PATH];
    char *parts[HOST_PATH / 2];
    int nparts = 0;
    size_t i;
    size_t len;
    int absolute;
    char *tok;
    char *save = NULL;
    size_t out = 0;

    if (dst == NULL || cap < 2 || src == NULL)
        return 0;
    len = strlen(src);
    if (len >= sizeof tmp)
        return 0;
    memcpy(tmp, src, len + 1);
    host_slashes(tmp);
    absolute = (tmp[0] == '/');

    for (tok = strtok_r(tmp, "/", &save); tok != NULL; tok = strtok_r(NULL, "/", &save)) {
        if (tok[0] == '\0' || (tok[0] == '.' && tok[1] == '\0'))
            continue;
        if (tok[0] == '.' && tok[1] == '.' && tok[2] == '\0') {
            if (nparts > 0)
                nparts--;
            continue;
        }
        if (nparts >= (int)(sizeof parts / sizeof parts[0]))
            return 0;
        parts[nparts++] = tok;
    }

    if (absolute) {
        if (out + 1 >= cap)
            return 0;
        dst[out++] = '/';
    }
    for (i = 0; i < (size_t)nparts; i++) {
        size_t pl = strlen(parts[i]);
        if (i > 0 || (absolute && out > 1) || (!absolute && out > 0)) {
            if (out + 1 >= cap)
                return 0;
            dst[out++] = '/';
        }
        if (out + pl >= cap)
            return 0;
        memcpy(dst + out, parts[i], pl);
        out += pl;
    }
    if (out == 0) {
        if (absolute) {
            dst[0] = '/';
            dst[1] = '\0';
            return 1;
        }
        dst[0] = '.';
        dst[1] = '\0';
        return 1;
    }
    dst[out] = '\0';
    return 1;
}

static int host_expand_home(char *dst, size_t cap, const char *src)
{
    const char *home;
    size_t home_n;
    size_t rest_n;
    const char *rest;
    int sep;

    if (src == NULL)
        return 0;
    if (src[0] != '~') {
        rest_n = strlen(src);
        if (rest_n >= cap)
            return 0;
        memcpy(dst, src, rest_n + 1);
        return 1;
    }
    rest = src + 1;
    if (*rest == '/' || *rest == '\\')
        rest++;
    else if (*rest != '\0') {
        rest_n = strlen(src);
        if (rest_n >= cap)
            return 0;
        memcpy(dst, src, rest_n + 1);
        return 1;
    }
    home = user_root[0] != '\0' ? user_root : getenv("HOME");
    if (home == NULL || home[0] == '\0')
        return 0;
    home_n = strlen(home);
    rest_n = strlen(rest);
    sep = (rest_n > 0 && home[home_n - 1] != '/') ? 1 : 0;
    if (home_n + (size_t)sep + rest_n >= cap)
        return 0;
    memcpy(dst, home, home_n);
    if (sep)
        dst[home_n++] = '/';
    memcpy(dst + home_n, rest, rest_n + 1);
    return 1;
}

static int host_copy_path(const char *p, long long n, char *dst, size_t cap)
{
    char raw[HOST_PATH];
    char expanded[HOST_PATH];
    size_t nout;

    if (p == NULL || n <= 0 || (unsigned long long)n >= sizeof raw || dst == NULL)
        return 0;
    memcpy(raw, p, (size_t)n);
    raw[n] = '\0';
    if (!host_expand_home(expanded, sizeof expanded, raw))
        return 0;
    host_slashes(expanded);
    nout = strlen(expanded);
    if (nout >= cap)
        return 0;
    memcpy(dst, expanded, nout + 1);
    return 1;
}

static void host_mkdir_parents(const char *path)
{
    char buf[HOST_PATH];
    char *p;
    size_t n;

    if (path == NULL)
        return;
    n = strlen(path);
    if (n == 0 || n >= sizeof buf)
        return;
    memcpy(buf, path, n + 1);
    host_slashes(buf);
    p = buf;
    if (*p == '/')
        p++;
    for (; *p != '\0'; p++) {
        if (*p != '/')
            continue;
        *p = '\0';
        if (buf[0] != '\0')
            mkdir(buf, 0755);
        *p = '/';
    }
}

static int host_slot(void)
{
    int i;
    for (i = 1; i < HOST_FILES; i++) {
        if (host_fp[i] == NULL && host_mem[i] == NULL)
            return i;
    }
    return 0;
}

static FILE *host_lookup(long long id)
{
    if (id < 1 || id >= HOST_FILES)
        return NULL;
    return host_fp[id];
}

void android_host_set_roots(const char *user_root_path)
{
    size_t n;

    user_root[0] = '\0';
    library_root[0] = '\0';
    if (user_root_path == NULL || user_root_path[0] == '\0')
        return;
    n = strlen(user_root_path);
    if (n >= sizeof user_root)
        n = sizeof user_root - 1;
    memcpy(user_root, user_root_path, n);
    user_root[n] = '\0';
    host_slashes(user_root);
    mkdir(user_root, 0755);
    if (snprintf(library_root, sizeof library_root, "%s/Library", user_root) >=
        (int)sizeof library_root)
        library_root[0] = '\0';
    if (chdir(user_root) != 0) {
        /* keep going; resolve still uses user_root / load_dir */
    }
}

/* One kernel_eval of the whole file (words may span lines). */
static int android_eval_file(const char *path)
{
    FILE *fp;
    long sz;
    char *buf;
    size_t nread;
    int rc;
    char msg[HOST_PATH + 64];

    fp = fopen(path, "rb");
    if (fp == NULL) {
        snprintf(msg, sizeof msg, "cannot open %s\n", path);
        host_outs(msg);
        return -1;
    }
    if (fseek(fp, 0, SEEK_END) != 0) {
        fclose(fp);
        snprintf(msg, sizeof msg, "cannot size %s\n", path);
        host_outs(msg);
        return -1;
    }
    sz = ftell(fp);
    if (sz < 0 || sz > 8 * 1024 * 1024) {
        fclose(fp);
        snprintf(msg, sizeof msg, "cannot size %s\n", path);
        host_outs(msg);
        return -1;
    }
    if (fseek(fp, 0, SEEK_SET) != 0) {
        fclose(fp);
        snprintf(msg, sizeof msg, "cannot read %s\n", path);
        host_outs(msg);
        return -1;
    }
    buf = (char *)malloc((size_t)sz + 1);
    if (buf == NULL) {
        fclose(fp);
        host_outs("out of memory\n");
        return -1;
    }
    nread = fread(buf, 1, (size_t)sz, fp);
    fclose(fp);
    buf[nread] = '\0';
    rc = kernel_eval(buf, nread);
    free(buf);
    return rc;
}

/* Match Windows forth_autoload: eval AutoLoad/autoload.fth as one buffer from
   user_root (not INCLUDE, so load-cwd stays off AutoLoad), then MAIN. */
void android_host_autoload(void)
{
    char path[HOST_PATH];
    static const char main_line[] = "[DEFINED] MAIN [IF] MAIN [THEN]";
    struct stat st;
    int rc;
    int n;

    if (user_root[0] == '\0')
        return;
    n = snprintf(path, sizeof path, "%s/AutoLoad/autoload.fth", user_root);
    if (n <= 0 || (size_t)n >= sizeof path)
        return;
    if (stat(path, &st) != 0 || !S_ISREG(st.st_mode))
        return;
    if (chdir(user_root) != 0) {
        /* resolve still uses user_root */
    }
    rc = android_eval_file(path);
    if (rc != 0)
        host_outs("autoload did not finish\n");
    (void)kernel_eval(main_line, sizeof main_line - 1);
    if (chdir(user_root) != 0) {
    }
}

long long host_library_path(char *dst, long long cap)
{
    size_t n;

    if (dst == NULL || cap < 2)
        return 0;
    n = strlen(library_root);
    if (n >= (size_t)cap)
        n = (size_t)cap - 1;
    if (n > 0)
        memcpy(dst, library_root, n);
    dst[n] = '\0';
    return (long long)n;
}

long long host_resolve(const char *p, long long n, char *out, long long cap)
{
    char tmp[HOST_PATH];
    char joined[HOST_PATH];
    char cwd[HOST_PATH];
    const char *src;
    size_t sl;

    if (out == NULL || cap < 2)
        return 0;
    if (p == NULL || n < 0)
        n = 0;
    if (n > HOST_PATH - 1)
        n = HOST_PATH - 1;
    if (n > 0)
        memcpy(tmp, p, (size_t)n);
    tmp[n] = '\0';
    if (!host_expand_home(joined, sizeof joined, tmp))
        return 0;
    memcpy(tmp, joined, strlen(joined) + 1);
    host_slashes(tmp);
    src = tmp;

    if (!host_abs(tmp, (long long)strlen(tmp)) && fromlib_armed) {
        fromlib_armed = 0;
        if (library_root[0] == '\0' || !host_is_dir(library_root) ||
            !host_join(joined, (int)sizeof joined, library_root, tmp)) {
            host_outs("FROMLIB: Library is missing\n");
            return 0;
        }
        src = joined;
    } else if (!host_abs(tmp, (long long)strlen(tmp)) && host_is_user_tree_rel(tmp)) {
        /* Prefer the Forth root over load-cwd so AutoLoad's
           REQUIRE Library/... finds EditForthAnd/Library, not AutoLoad/Library. */
        if (user_root[0] == '\0' ||
            !host_join(joined, (int)sizeof joined, user_root, tmp))
            return 0;
        src = joined;
    } else if (!host_abs(tmp, (long long)strlen(tmp)) && load_n > 0 &&
               load_len[load_n - 1] > 0) {
        int dl = load_len[load_n - 1];
        size_t room;
        size_t cn;

        if (dl > HOST_PATH - 2)
            dl = HOST_PATH - 2;
        memcpy(joined, load_dir[load_n - 1], (size_t)dl);
        if (joined[dl - 1] != '/')
            joined[dl++] = '/';
        room = (size_t)(HOST_PATH - 1 - dl);
        cn = strlen(tmp);
        if (cn > room)
            cn = room;
        memcpy(joined + dl, tmp, cn);
        joined[dl + cn] = '\0';
        src = joined;
    } else if (!host_abs(tmp, (long long)strlen(tmp))) {
        if (getcwd(cwd, sizeof cwd) == NULL)
            cwd[0] = '\0';
        if (cwd[0] != '\0') {
            if (!host_join(joined, (int)sizeof joined, cwd, tmp))
                return 0;
            src = joined;
        } else if (user_root[0] != '\0') {
            if (!host_join(joined, (int)sizeof joined, user_root, tmp))
                return 0;
            src = joined;
        }
    }

    if (!host_normalize(out, (size_t)cap, src)) {
        sl = strlen(src);
        if (sl >= (size_t)cap)
            sl = (size_t)cap - 1;
        memcpy(out, src, sl);
        out[sl] = '\0';
    }
    /* Fold case for Android (autoload→AutoLoad, HYPER→Hyper, …). */
    if (!host_is_file(out) && !host_is_dir(out))
        host_case_fold(out, (size_t)cap);
    return (long long)strlen(out);
}

/* ---- Virtual Config/HYPER.SPECS (expand HYPER.CFG like Windows/Mac host) ---- */

typedef struct HostList {
    char **v;
    int n;
    int cap;
} HostList;

static void host_list_free(HostList *list)
{
    int i;

    if (list == NULL)
        return;
    for (i = 0; i < list->n; i++)
        free(list->v[i]);
    free(list->v);
    list->v = NULL;
    list->n = 0;
    list->cap = 0;
}

static int host_list_add(HostList *list, const char *s)
{
    char *copy;
    char **grown;
    int cap;

    if (list == NULL || s == NULL)
        return 0;
    if (list->n >= list->cap) {
        cap = list->cap == 0 ? 64 : list->cap * 2;
        grown = (char **)realloc(list->v, (size_t)cap * sizeof(char *));
        if (grown == NULL)
            return 0;
        list->v = grown;
        list->cap = cap;
    }
    copy = strdup(s);
    if (copy == NULL)
        return 0;
    list->v[list->n++] = copy;
    return 1;
}

static int host_list_has_ci(const HostList *list, const char *s)
{
    int i;

    if (list == NULL || s == NULL)
        return 0;
    for (i = 0; i < list->n; i++) {
        if (strcasecmp(list->v[i], s) == 0)
            return 1;
    }
    return 0;
}

static int host_contains_ci(const char *hay, const char *needle)
{
    size_t nlen;
    size_t i;
    size_t hlen;

    if (hay == NULL || needle == NULL || needle[0] == '\0')
        return 0;
    nlen = strlen(needle);
    hlen = strlen(hay);
    if (nlen > hlen)
        return 0;
    for (i = 0; i + nlen <= hlen; i++) {
        if (strncasecmp(hay + i, needle, nlen) == 0)
            return 1;
    }
    return 0;
}

static int host_suffix_ci(const char *s, const char *suffix)
{
    size_t ns;
    size_t nsu;

    if (s == NULL || suffix == NULL)
        return 0;
    ns = strlen(s);
    nsu = strlen(suffix);
    if (nsu > ns)
        return 0;
    return strcasecmp(s + (ns - nsu), suffix) == 0;
}

static int host_path_cmp(const void *a, const void *b)
{
    const char *sa = *(const char *const *)a;
    const char *sb = *(const char *const *)b;
    return strcasecmp(sa, sb);
}

static void host_trim_span(const char *s, size_t n, char *dst, size_t cap)
{
    while (n > 0 && (s[0] == ' ' || s[0] == '\t' || s[0] == '\r')) {
        s++;
        n--;
    }
    while (n > 0 && (s[n - 1] == ' ' || s[n - 1] == '\t' || s[n - 1] == '\r'))
        n--;
    if (n >= cap)
        n = cap - 1;
    memcpy(dst, s, n);
    dst[n] = '\0';
}

static int host_under_root(const char *full, const char *root, const char **rest)
{
    size_t n;

    if (full == NULL || root == NULL || root[0] == '\0')
        return 0;
    n = strlen(root);
    if (strncasecmp(full, root, n) != 0)
        return 0;
    if (full[n] == '/') {
        *rest = full + n + 1;
        return 1;
    }
    if (full[n] == '\0') {
        *rest = full + n;
        return 1;
    }
    return 0;
}

static int host_to_ndx(const char *full, char *ndx, size_t cap)
{
    const char *rest = NULL;
    const char *prefix = "";
    char tmp[HOST_PATH];
    int n;

    if (library_root[0] != '\0' && host_under_root(full, library_root, &rest))
        prefix = "Library/";
    else if (user_root[0] != '\0' && host_under_root(full, user_root, &rest))
        prefix = "";
    else
        return 0;
    if (rest == NULL)
        return 0;
    n = snprintf(tmp, sizeof tmp, "%s%s", prefix, rest);
    if (n <= 0 || (size_t)n >= sizeof tmp || (size_t)n >= cap)
        return 0;
    if (strchr(tmp, '/') == NULL)
        return 0;
    memcpy(ndx, tmp, (size_t)n + 1);
    return 1;
}

static int host_spec_disk(const char *spec, char *disk, size_t cap)
{
    char norm[HOST_PATH];
    const char *rel;
    size_t i;
    size_t n;
    int out;

    n = strlen(spec);
    if (n == 0 || n >= sizeof norm)
        return 0;
    for (i = 0; i <= n; i++)
        norm[i] = (spec[i] == '\\') ? '/' : spec[i];
    if (host_ci_prefix(norm, "Resources/Library/"))
        rel = norm + strlen("Resources/Library/");
    else if (host_ci_prefix(norm, "Library/"))
        rel = norm + strlen("Library/");
    else if (host_ci_prefix(norm, "Resources/")) {
        rel = norm + strlen("Resources/");
        if (user_root[0] == '\0')
            return 0;
        out = snprintf(disk, cap, "%s/%s", user_root, rel);
        return out > 0 && (size_t)out < cap;
    } else {
        rel = norm;
        if (user_root[0] == '\0')
            return 0;
        out = snprintf(disk, cap, "%s/%s", user_root, rel);
        return out > 0 && (size_t)out < cap;
    }
    if (library_root[0] == '\0')
        return 0;
    out = snprintf(disk, cap, "%s/%s", library_root, rel);
    return out > 0 && (size_t)out < cap;
}

static const char *host_glob_ext(const char *spec)
{
    if (host_suffix_ci(spec, ".fth"))
        return ".fth";
    if (host_suffix_ci(spec, ".fs"))
        return ".fs";
    if (host_suffix_ci(spec, ".inc"))
        return ".inc";
    if (host_suffix_ci(spec, ".h"))
        return ".h";
    if (host_suffix_ci(spec, ".s"))
        return ".s";
    return NULL;
}

static void host_walk_files(const char *dir, const char *ext, HostList *out, int depth)
{
    DIR *d;
    struct dirent *ent;
    char child[HOST_PATH];
    struct stat st;
    int n;

    if (dir == NULL || dir[0] == '\0' || depth > 32)
        return;
    d = opendir(dir);
    if (d == NULL)
        return;
    while ((ent = readdir(d)) != NULL) {
        if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
            continue;
        n = snprintf(child, sizeof child, "%s/%s", dir, ent->d_name);
        if (n <= 0 || n >= (int)sizeof child)
            continue;
        if (stat(child, &st) != 0)
            continue;
        if (S_ISDIR(st.st_mode))
            host_walk_files(child, ext, out, depth + 1);
        else if (S_ISREG(st.st_mode) &&
                 (ext == NULL || host_suffix_ci(ent->d_name, ext)))
            host_list_add(out, child);
    }
    closedir(d);
}

static void host_expand_spec(const char *spec, HostList *batch)
{
    char disk[HOST_PATH];
    struct stat st;

    if (spec == NULL || spec[0] == '\0')
        return;
    if (strchr(spec, '*') == NULL && strchr(spec, '?') == NULL) {
        if (!host_spec_disk(spec, disk, sizeof disk))
            return;
        if (stat(disk, &st) != 0 || !S_ISREG(st.st_mode))
            return;
        host_list_add(batch, disk);
        return;
    }
    if (host_ci_prefix(spec, "Resources/Library/") || host_ci_prefix(spec, "Library/")) {
        if (library_root[0] != '\0')
            host_walk_files(library_root, host_glob_ext(spec), batch, 0);
    } else if (user_root[0] != '\0') {
        host_walk_files(user_root, host_glob_ext(spec), batch, 0);
    }
}

static void host_parse_hyper_cfg(const char *text, HostList *specs, HostList *excludes)
{
    const char *p;

    if (text == NULL)
        return;
    p = text;
    while (*p != '\0') {
        const char *eol = p;
        size_t n;
        char line[HOST_PATH];
        char rest[HOST_PATH];

        while (*eol != '\0' && *eol != '\n')
            eol++;
        n = (size_t)(eol - p);
        host_trim_span(p, n, line, sizeof line);
        p = (*eol == '\n') ? eol + 1 : eol;
        if (line[0] == '\0' || line[0] == '#')
            continue;
        if (strcmp(line, ";") == 0)
            break;
        if (host_ci_prefix(line, "*EXCLUDE")) {
            host_trim_span(line + 8, strlen(line + 8), rest, sizeof rest);
            if (rest[0] != '\0')
                host_list_add(excludes, rest);
            continue;
        }
        if (host_ci_prefix(line, "SPECS")) {
            host_trim_span(line + 5, strlen(line + 5), rest, sizeof rest);
            if (rest[0] != '\0')
                host_list_add(specs, rest);
        }
    }
}

static void host_hyper_defaults(HostList *specs, HostList *excludes)
{
    static const char *default_specs[] = {
        "Resources/Library/Sources/boot_words.inc",
        "Resources/Library/Sources/boot_words_end.inc",
        "Resources/Library/Sources/colon_words.inc",
        "Resources/Library/Sources/kernel_api.h",
        "Resources/Library/**/*.fth",
        "Resources/Library/**/*.FTH",
    };
    static const char *default_excludes[] = {
        "Testing", "HayesTest", "ANSValidate", "DbgSpanSmoke",
        "Benchmarks", "HYPER.NDX",
    };
    int i;

    if (specs->n == 0) {
        for (i = 0; i < (int)(sizeof default_specs / sizeof default_specs[0]); i++)
            host_list_add(specs, default_specs[i]);
    }
    if (excludes->n == 0) {
        for (i = 0; i < (int)(sizeof default_excludes / sizeof default_excludes[0]); i++)
            host_list_add(excludes, default_excludes[i]);
    }
}

static char *host_read_file_text(const char *path)
{
    FILE *fp;
    char *buf;
    long sz;

    fp = fopen(path, "rb");
    if (fp == NULL)
        return NULL;
    if (fseek(fp, 0, SEEK_END) != 0) {
        fclose(fp);
        return NULL;
    }
    sz = ftell(fp);
    if (sz < 0 || sz > 1024 * 1024) {
        fclose(fp);
        return NULL;
    }
    if (fseek(fp, 0, SEEK_SET) != 0) {
        fclose(fp);
        return NULL;
    }
    buf = (char *)malloc((size_t)sz + 1);
    if (buf == NULL) {
        fclose(fp);
        return NULL;
    }
    if (sz > 0 && fread(buf, 1, (size_t)sz, fp) != (size_t)sz) {
        free(buf);
        fclose(fp);
        return NULL;
    }
    buf[sz] = '\0';
    fclose(fp);
    return buf;
}

static int host_excluded(const char *ndx, const char *full, const HostList *excludes)
{
    int i;

    for (i = 0; i < excludes->n; i++) {
        if (host_contains_ci(ndx, excludes->v[i]) || host_contains_ci(full, excludes->v[i]))
            return 1;
    }
    return 0;
}

static char *host_hyper_specs_text(long long *out_len)
{
    char cfg_path[HOST_PATH];
    char *cfg = NULL;
    char *text = NULL;
    char ndx[HOST_PATH];
    HostList specs;
    HostList excludes;
    HostList seen;
    size_t total;
    size_t used;
    int i;
    int n;

    memset(&specs, 0, sizeof specs);
    memset(&excludes, 0, sizeof excludes);
    memset(&seen, 0, sizeof seen);
    if (user_root[0] != '\0') {
        n = snprintf(cfg_path, sizeof cfg_path, "%s/Config/HYPER.CFG", user_root);
        if (n > 0 && (size_t)n < sizeof cfg_path)
            cfg = host_read_file_text(cfg_path);
    }
    host_parse_hyper_cfg(cfg, &specs, &excludes);
    free(cfg);
    host_hyper_defaults(&specs, &excludes);

    for (i = 0; i < specs.n; i++) {
        HostList batch;
        int j;

        memset(&batch, 0, sizeof batch);
        host_expand_spec(specs.v[i], &batch);
        if (batch.n > 1)
            qsort(batch.v, (size_t)batch.n, sizeof(char *), host_path_cmp);
        for (j = 0; j < batch.n; j++) {
            if (!host_to_ndx(batch.v[j], ndx, sizeof ndx))
                continue;
            if (host_excluded(ndx, batch.v[j], &excludes))
                continue;
            if (host_list_has_ci(&seen, ndx))
                continue;
            host_list_add(&seen, ndx);
        }
        host_list_free(&batch);
    }
    host_list_free(&specs);
    host_list_free(&excludes);

    total = 1;
    for (i = 0; i < seen.n; i++)
        total += strlen(seen.v[i]) + 1;
    if (seen.n == 0)
        total = 2;
    text = (char *)malloc(total);
    if (text == NULL) {
        host_list_free(&seen);
        return NULL;
    }
    if (seen.n == 0) {
        text[0] = '\n';
        text[1] = '\0';
        *out_len = 1;
        host_list_free(&seen);
        return text;
    }
    used = 0;
    for (i = 0; i < seen.n; i++) {
        size_t len = strlen(seen.v[i]);
        memcpy(text + used, seen.v[i], len);
        used += len;
        text[used++] = '\n';
    }
    text[used] = '\0';
    *out_len = (long long)used;
    host_list_free(&seen);
    return text;
}

static int host_is_hyper_specs(const char *path)
{
    const char *base;
    const char *end;
    size_t n;

    if (path == NULL)
        return 0;
    end = path + strlen(path);
    while (end > path && (end[-1] == ' ' || end[-1] == '\t' || end[-1] == '/'))
        end--;
    base = path;
    {
        const char *p;
        for (p = path; p < end; p++) {
            if (*p == '/')
                base = p + 1;
        }
    }
    n = (size_t)(end - base);
    return n == 11 && strncasecmp(base, "HYPER.SPECS", 11) == 0;
}

long long host_open(const char *p, long long n, long long fam)
{
    char path[HOST_PATH];
    char resolved[HOST_PATH];
    int slot;
    FILE *fp;
    const char *mode;
    long long rn;

    if (!host_copy_path(p, n, path, sizeof path))
        return 0;
    slot = host_slot();
    if (slot == 0)
        return 0;
    /* Virtual SPECS list — before resolve/fopen so missing disk file is OK. */
    if (host_is_hyper_specs(path)) {
        long long len = 0;
        char *text = host_hyper_specs_text(&len);
        if (text == NULL)
            return 0;
        host_mem[slot] = text;
        host_mem_len[slot] = len;
        host_mem_pos[slot] = 0;
        return slot;
    }
    rn = host_resolve(path, (long long)strlen(path), resolved, (long long)sizeof resolved);
    if (rn <= 0)
        return 0;
    if (host_is_hyper_specs(resolved)) {
        long long len = 0;
        char *text = host_hyper_specs_text(&len);
        if (text == NULL)
            return 0;
        host_mem[slot] = text;
        host_mem_len[slot] = len;
        host_mem_pos[slot] = 0;
        return slot;
    }
    mode = (fam == 2 || fam == 3) ? "r+b" : "rb";
    fp = fopen(resolved, mode);
    if (fp == NULL)
        return 0;
    host_fp[slot] = fp;
    return slot;
}

long long host_create(const char *p, long long n, long long fam)
{
    char path[HOST_PATH];
    char resolved[HOST_PATH];
    int slot;
    FILE *fp;
    long long rn;

    (void)fam;
    if (!host_copy_path(p, n, path, sizeof path))
        return 0;
    rn = host_resolve(path, (long long)strlen(path), resolved, (long long)sizeof resolved);
    if (rn <= 0)
        return 0;
    host_mkdir_parents(resolved);
    slot = host_slot();
    if (slot == 0)
        return 0;
    fp = fopen(resolved, "w+b");
    if (fp == NULL)
        return 0;
    host_fp[slot] = fp;
    return slot;
}

long long host_close(long long id)
{
    FILE *fp;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL) {
        free(host_mem[id]);
        host_mem[id] = NULL;
        host_mem_len[id] = 0;
        host_mem_pos[id] = 0;
        return 0;
    }
    fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    host_fp[id] = NULL;
    return fclose(fp) == 0 ? 0 : -1;
}

long long host_read(char *buf, long long n, long long id)
{
    FILE *fp;
    size_t got;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL) {
        long long left;
        long long take;
        if (buf == NULL || n < 0)
            return -1;
        if (n == 0 || host_mem_pos[id] >= host_mem_len[id])
            return 0;
        left = host_mem_len[id] - host_mem_pos[id];
        take = n < left ? n : left;
        memcpy(buf, host_mem[id] + host_mem_pos[id], (size_t)take);
        host_mem_pos[id] += take;
        return take;
    }
    fp = host_lookup(id);
    if (fp == NULL || buf == NULL || n < 0)
        return -1;
    if (n == 0)
        return 0;
    got = fread(buf, 1, (size_t)n, fp);
    if (got < (size_t)n && ferror(fp))
        return -1;
    return (long long)got;
}

long long host_write(const char *buf, long long n, long long id)
{
    FILE *fp = host_lookup(id);
    size_t put;

    if (fp == NULL || buf == NULL || n < 0)
        return -1;
    if (n == 0)
        return 0;
    put = fwrite(buf, 1, (size_t)n, fp);
    return put == (size_t)n ? 0 : -1;
}

long long host_size(long long id)
{
    FILE *fp;
    long pos;
    long sz;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL)
        return host_mem_len[id];
    fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    pos = ftell(fp);
    if (pos < 0)
        return -1;
    if (fseek(fp, 0, SEEK_END) != 0)
        return -1;
    sz = ftell(fp);
    fseek(fp, pos, SEEK_SET);
    if (sz < 0)
        return -1;
    return (long long)sz;
}

long long host_repos(long long id, long long lo, long long hi)
{
    FILE *fp;

    if (hi != 0)
        return -1;
    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL) {
        if (lo < 0)
            return -1;
        host_mem_pos[id] = lo > host_mem_len[id] ? host_mem_len[id] : lo;
        return 0;
    }
    fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    if (fseek(fp, (long)lo, SEEK_SET) != 0)
        return -1;
    return 0;
}

long long host_flush(long long id)
{
    FILE *fp;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL)
        return 0;
    fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    return fflush(fp) == 0 ? 0 : -1;
}

long long host_read_line(char *buf, long long n, long long id, long long *flag)
{
    FILE *fp;
    long long i = 0;
    int c;

    if (flag != NULL)
        *flag = 0;
    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL) {
        long long pos = host_mem_pos[id];
        long long len = host_mem_len[id];
        const char *base = host_mem[id];
        if (n < 0 || (buf == NULL && n > 0))
            return -1;
        if (pos >= len)
            return 0;
        if (flag != NULL)
            *flag = -1;
        while (pos < len) {
            char ch = base[pos++];
            if (ch == '\n') {
                host_mem_pos[id] = pos;
                return i;
            }
            if (ch == '\r') {
                if (pos < len && base[pos] == '\n')
                    pos++;
                host_mem_pos[id] = pos;
                return i;
            }
            if (i >= n) {
                host_mem_pos[id] = pos - 1;
                return i;
            }
            if (buf != NULL)
                buf[i] = ch;
            i++;
        }
        host_mem_pos[id] = pos;
        return i;
    }
    fp = host_lookup(id);
    if (fp == NULL || n < 0 || (buf == NULL && n > 0))
        return -1;
    c = fgetc(fp);
    if (c == EOF)
        return ferror(fp) ? -1 : 0;
    if (flag != NULL)
        *flag = -1;
    for (;;) {
        if (c == '\n')
            return i;
        if (c == '\r') {
            int next = fgetc(fp);
            if (next == EOF) {
                if (ferror(fp))
                    return -1;
            } else if (next != '\n') {
                ungetc(next, fp);
            }
            return i;
        }
        if (i >= n) {
            ungetc(c, fp);
            return i;
        }
        buf[i++] = (char)c;
        c = fgetc(fp);
        if (c == EOF)
            return ferror(fp) ? -1 : i;
    }
}

long long host_write_line(const char *buf, long long n, long long id)
{
    char nl = '\n';

    if (host_write(buf, n, id) != 0)
        return -1;
    return host_write(&nl, 1, id);
}

long long host_position(long long id)
{
    FILE *fp;
    long pos;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL)
        return host_mem_pos[id];
    fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    pos = ftell(fp);
    if (pos < 0)
        return -1;
    return (long long)pos;
}

long long host_resize_file(long long id, long long lo, long long hi)
{
    FILE *fp = host_lookup(id);
    int fd;

    if (fp == NULL || hi != 0 || lo < 0)
        return -1;
    if (fflush(fp) != 0)
        return -1;
    fd = fileno(fp);
    if (fd < 0)
        return -1;
    if (ftruncate(fd, (off_t)lo) != 0)
        return -1;
    return 0;
}

long long host_delete(const char *p, long long n)
{
    char path[HOST_PATH];
    char resolved[HOST_PATH];
    long long rn;

    if (!host_copy_path(p, n, path, sizeof path))
        return -1;
    rn = host_resolve(path, (long long)strlen(path), resolved, (long long)sizeof resolved);
    if (rn <= 0)
        return -1;
    return unlink(resolved) == 0 ? 0 : -1;
}

long long host_rename(const char *a, long long an, const char *b, long long bn)
{
    char from[HOST_PATH];
    char to[HOST_PATH];
    char rfrom[HOST_PATH];
    char rto[HOST_PATH];
    long long rn;

    if (!host_copy_path(a, an, from, sizeof from))
        return -1;
    if (!host_copy_path(b, bn, to, sizeof to))
        return -1;
    rn = host_resolve(from, (long long)strlen(from), rfrom, (long long)sizeof rfrom);
    if (rn <= 0)
        return -1;
    rn = host_resolve(to, (long long)strlen(to), rto, (long long)sizeof rto);
    if (rn <= 0)
        return -1;
    return rename(rfrom, rto) == 0 ? 0 : -1;
}

long long host_file_status(const char *p, long long n, long long *attr)
{
    char path[HOST_PATH];
    char resolved[HOST_PATH];
    struct stat st;
    long long rn;

    if (attr != NULL)
        *attr = 0;
    if (!host_copy_path(p, n, path, sizeof path))
        return -1;
    rn = host_resolve(path, (long long)strlen(path), resolved, (long long)sizeof resolved);
    if (rn <= 0)
        return -1;
    if (stat(resolved, &st) != 0)
        return -1;
    if (attr != NULL) {
        if (S_ISDIR(st.st_mode))
            *attr = FILE_ATTR_DIRECTORY;
        else
            *attr = FILE_ATTR_NORMAL;
    }
    return 0;
}

void host_begin_load(const char *p, long long n)
{
    int len = 0;
    int found = 0;
    long long i;

    if (load_n >= HOST_LOADS)
        return;
    if (p == NULL || n < 0)
        n = 0;
    i = n;
    while (i > 0) {
        char c = p[i - 1];
        if (c == '\\' || c == '/') {
            found = 1;
            break;
        }
        i--;
    }
    if (found)
        len = (int)(i - 1);
    if (len < 0)
        len = 0;
    if (len >= HOST_PATH)
        len = HOST_PATH - 1;
    if (len > 0)
        memcpy(load_dir[load_n], p, (size_t)len);
    load_dir[load_n][len] = '\0';
    host_slashes(load_dir[load_n]);
    len = (int)strlen(load_dir[load_n]);
    load_len[load_n] = len;
    load_prev[load_n][0] = '\0';
    if (getcwd(load_prev[load_n], sizeof load_prev[load_n]) == NULL)
        load_prev[load_n][0] = '\0';
    load_n++;
    if (len > 0)
        chdir(load_dir[load_n - 1]);
}

void host_end_load(void)
{
    if (load_n <= 0)
        return;
    load_n--;
    if (load_prev[load_n][0] != '\0')
        chdir(load_prev[load_n]);
}

static int host_eq(const char *a, int an, const char *b, int bn)
{
    int i;
    if (an != bn)
        return 0;
    for (i = 0; i < an; i++) {
        unsigned char ca = (unsigned char)a[i];
        unsigned char cb = (unsigned char)b[i];
        if (ca == '\\')
            ca = '/';
        if (cb == '\\')
            cb = '/';
        if (ca >= 'A' && ca <= 'Z')
            ca = (unsigned char)(ca + 32);
        if (cb >= 'A' && cb <= 'Z')
            cb = (unsigned char)(cb + 32);
        if (ca != cb)
            return 0;
    }
    return 1;
}

long long host_was_included(const char *p, long long n)
{
    int len;
    int i;

    if (p == NULL || n <= 0)
        return 0;
    if (n > 255)
        n = 255;
    len = (int)n;
    for (i = 0; i < reg_n; i++) {
        if (host_eq(reg_path[i], reg_len[i], p, len))
            return 1;
    }
    return 0;
}

void host_register(const char *p, long long n)
{
    if (p == NULL || n <= 0)
        return;
    if (n > 255)
        n = 255;
    memcpy(last_path, p, (size_t)n);
    last_path[n] = '\0';
    last_len = (int)n;
    if (reg_n >= HOST_REGS)
        return;
    if (host_was_included(p, n))
        return;
    memcpy(reg_path[reg_n], p, (size_t)n);
    reg_path[reg_n][n] = '\0';
    reg_len[reg_n] = (int)n;
    reg_n++;
}

void host_last_included(long long *addr, long long *len)
{
    if (addr != NULL)
        *addr = (long long)(uintptr_t)last_path;
    if (len != NULL)
        *len = last_len;
}

void host_dot_included(void)
{
    int i;
    if (reg_n <= 0) {
        host_outs("Included:\n  (none)\n");
        return;
    }
    host_outs("Included:\n");
    for (i = 0; i < reg_n; i++) {
        host_outs("  ");
        host_out(reg_path[i], (size_t)reg_len[i]);
        host_outs("\n");
    }
}

void host_fromlib(void)
{
    fromlib_armed = 1;
}

void host_fromlib_off(void)
{
    fromlib_armed = 0;
}

long long host_fromlib_query(void)
{
    return fromlib_armed ? -1 : 0;
}

long long host_chdir(const char *p, long long n)
{
    char path[HOST_PATH];
    char resolved[HOST_PATH];
    long long rn;

    if (!host_copy_path(p, n, path, sizeof path))
        return -1;
    rn = host_resolve(path, (long long)strlen(path), resolved, (long long)sizeof resolved);
    if (rn <= 0)
        return -1;
    return chdir(resolved) == 0 ? 0 : -1;
}

void host_pwd(void)
{
    char buf[HOST_PATH];

    if (getcwd(buf, sizeof buf) == NULL)
        return;
    host_out(buf, strlen(buf));
    host_outs("\n");
}

long long host_cwd(char *buf, long long max)
{
    char tmp[HOST_PATH];
    size_t n;
    long long copy;

    if (buf == NULL || max <= 0)
        return 0;
    if (getcwd(tmp, sizeof tmp) == NULL)
        return 0;
    n = strlen(tmp);
    copy = (long long)n < max ? (long long)n : max;
    memcpy(buf, tmp, (size_t)copy);
    return copy;
}

static int host_has_wild(const char *s)
{
    for (; *s != '\0'; s++) {
        if (*s == '*' || *s == '?')
            return 1;
    }
    return 0;
}

void host_dir(const char *p, long long n)
{
    char spec[HOST_PATH];
    char dirpath[HOST_PATH];
    char pattern[HOST_PATH];
    DIR *d;
    struct dirent *ent;
    const char *slash;
    size_t len = 0;

    if (p == NULL || n <= 0) {
        if (getcwd(spec, sizeof spec) == NULL)
            return;
        len = strlen(spec);
        if (len + 3 >= sizeof spec)
            return;
        if (len > 0 && spec[len - 1] != '/')
            spec[len++] = '/';
        spec[len++] = '*';
        spec[len] = '\0';
    } else {
        if (!host_copy_path(p, n, spec, sizeof spec))
            return;
        len = strlen(spec);
        if (!host_has_wild(spec)) {
            if (host_is_dir(spec)) {
                if (len > 0 && spec[len - 1] != '/') {
                    if (len + 3 >= sizeof spec)
                        return;
                    spec[len++] = '/';
                }
                if (len + 2 >= sizeof spec)
                    return;
                spec[len++] = '*';
                spec[len] = '\0';
            }
        }
    }

    slash = strrchr(spec, '/');
    if (slash != NULL) {
        size_t dlen = (size_t)(slash - spec);
        if (dlen == 0) {
            dirpath[0] = '/';
            dirpath[1] = '\0';
        } else {
            if (dlen >= sizeof dirpath)
                return;
            memcpy(dirpath, spec, dlen);
            dirpath[dlen] = '\0';
        }
        snprintf(pattern, sizeof pattern, "%s", slash + 1);
    } else {
        if (getcwd(dirpath, sizeof dirpath) == NULL)
            return;
        snprintf(pattern, sizeof pattern, "%s", spec);
    }
    if (pattern[0] == '\0')
        snprintf(pattern, sizeof pattern, "*");

    d = opendir(dirpath);
    if (d == NULL)
        return;
    while ((ent = readdir(d)) != NULL) {
        if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
            continue;
        if (fnmatch(pattern, ent->d_name, 0) != 0)
            continue;
        host_out(ent->d_name, strlen(ent->d_name));
        host_outs("\n");
    }
    closedir(d);
}

/* Stand-alone (SA-FILES) when the file hook cell is zero.
   op: 1 open 2 create 3 close 4 read 5 write 6 rline 7 wline
       8 pos 9 size 10 repos 11 resize 12 delete 13 rename 14 status 15 flush */
long long sa_win_file_op(long long op, long long a, long long b, long long c,
                         long long d, void *ptr, long long *o1, long long *o2,
                         long long *o3)
{
    long long n;
    long long flag;

    if (o1 != NULL)
        *o1 = 0;
    if (o2 != NULL)
        *o2 = 0;
    if (o3 != NULL)
        *o3 = 0;
    switch ((int)op) {
    case 1:
    case 2:
        n = (op == 1) ? host_open(ptr, b, c) : host_create(ptr, b, c);
        if (n == 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        return 0;
    case 3:
        return host_close(a);
    case 4:
        n = host_read(ptr, b, a);
        if (n < 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        return 0;
    case 5:
        return host_write(ptr, b, a);
    case 6:
        flag = 0;
        n = host_read_line(ptr, b, a, &flag);
        if (n < 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        if (o2 != NULL)
            *o2 = flag;
        return 0;
    case 7:
        return host_write_line(ptr, b, a);
    case 8:
        n = host_position(a);
        if (n < 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        return 0;
    case 9:
        n = host_size(a);
        if (n < 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        return 0;
    case 10:
        return host_repos(a, b, c);
    case 11:
        return host_resize_file(a, b, c);
    case 12:
        return host_delete(ptr, b);
    case 13:
        return host_rename(ptr, b, (const char *)(uintptr_t)c, d);
    case 14:
        return host_file_status(ptr, b, o1);
    case 15:
        return host_flush(a);
    default:
        return -1;
    }
}

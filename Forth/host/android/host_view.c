/* Public domain.
   Port of companion.c send_last / send_view for in-process Android.
   Uses the same kernel stamps (_find_word, view_paths, last_cfa). */

#include "host_view.h"

#include <stdint.h>
#include <string.h>

extern uint64_t _find_word(const char *token, uint64_t len);
extern uint64_t last_cfa;
extern uint64_t view_file_n;
extern unsigned char view_paths[];

static char g_edit_path[512];
static long long g_edit_line;
static int g_edit_pending;

void android_edit_clear(void)
{
    g_edit_pending = 0;
    g_edit_path[0] = '\0';
    g_edit_line = 0;
}

int android_edit_take(char *path, size_t path_cap, long long *line)
{
    size_t n;
    if (!g_edit_pending || path == NULL || path_cap == 0)
        return 0;
    n = strlen(g_edit_path);
    if (n + 1 > path_cap)
        return 0;
    memcpy(path, g_edit_path, n + 1);
    if (line)
        *line = g_edit_line;
    g_edit_pending = 0;
    return 1;
}

/* Called from host_android.c host_edit_at. */
void android_edit_post(const char *p, long long n, long long line)
{
    if (p == NULL || n <= 0 || n >= (long long)sizeof(g_edit_path))
        return;
    memcpy(g_edit_path, p, (size_t)n);
    g_edit_path[n] = '\0';
    g_edit_line = line;
    g_edit_pending = 1;
}

static int xt_name(uint64_t xt, char *dst, int cap)
{
    uint64_t flags;
    uint64_t off;
    const unsigned char *nfa;
    int n;
    int i;

    dst[0] = '\0';
    if (xt == 0 || (xt & 7) != 0 || cap < 2)
        return 0;
    flags = *(uint64_t *)(uintptr_t)(xt - 8);
    off = flags & 0xFFFFULL;
    if (off == 0 || off >= 4096)
        return 0;
    nfa = (const unsigned char *)(uintptr_t)(xt - off);
    n = nfa[0] & 0x7F;
    if (n <= 0 || n >= 64 || n >= cap)
        return 0;
    for (i = 0; i < n; i++) {
        unsigned char c = nfa[1 + i];
        if (c < 32 || c > 126)
            return 0;
        dst[i] = (char)c;
    }
    dst[n] = '\0';
    return n;
}

int android_last_name(char *dst, size_t cap)
{
    if (dst == NULL || cap < 2)
        return 0;
    return xt_name(last_cfa, dst, (int)cap) > 0 ? 1 : 0;
}

int android_view_word(const char *name, char *path, size_t path_cap, long long *line_out)
{
    char token[64];
    size_t len;
    uint64_t xt;
    uint64_t flags;
    unsigned line;
    unsigned file;
    const unsigned char *slot;
    int n;

    if (name == NULL || path == NULL || path_cap == 0)
        return -1;
    while (*name == ' ' || *name == '\t')
        name++;
    len = strlen(name);
    while (len > 0 && (name[len - 1] == ' ' || name[len - 1] == '\t'))
        len--;
    if (len == 0 || len >= sizeof token)
        return -1;
    memcpy(token, name, len);
    token[len] = '\0';
    if (strchr(token, ' ') != NULL || strchr(token, '\t') != NULL)
        return -1;
    xt = _find_word(token, (uint64_t)len);
    if (xt == 0 || (xt & 7) != 0)
        return -1;
    flags = *(uint64_t *)(uintptr_t)(xt - 8);
    line = (unsigned)((flags >> 32) & 0xFFFFULL);
    file = (unsigned)((flags >> 48) & 0x1FFFULL);
    if (file == 0 || file > view_file_n || file > 256)
        return -1;
    slot = view_paths + (size_t)(file - 1) * 256;
    n = slot[0];
    if (n <= 0 || n > 255 || (size_t)n + 1 > path_cap)
        return -1;
    memcpy(path, slot + 1, (size_t)n);
    path[n] = '\0';
    if (line_out)
        *line_out = (long long)line;
    return 0;
}

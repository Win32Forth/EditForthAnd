/* Public domain. Host smoke for TIME&DATE and SYSTEM on Linux. */
#include "emit_buf.h"

#include <stdio.h>
#include <string.h>

void host_time_date(long long *out);
long long host_system(const char *cmd, long long n);

static int fail(const char *msg)
{
    fprintf(stderr, "host_smoke: %s\n", msg);
    return 1;
}

int main(void)
{
    long long when[6];
    const char *cmd = "echo hello-editforth";
    const char *text;
    long long rc;

    host_time_date(when);
    if (when[5] < 2024 || when[5] > 2100)
        return fail("year");
    if (when[4] < 1 || when[4] > 12)
        return fail("month");
    if (when[3] < 1 || when[3] > 31)
        return fail("day");
    if (when[2] < 0 || when[2] > 23)
        return fail("hour");
    if (when[1] < 0 || when[1] > 59 || when[0] < 0 || when[0] > 60)
        return fail("min/sec");

    if (host_system("", 0) != -1)
        return fail("empty SYSTEM");
    if (host_system("   \t", 4) != -1)
        return fail("blank SYSTEM");

    emit_buf_reset();
    rc = host_system(cmd, (long long)strlen(cmd));
    text = emit_buf_text();
    if (rc != 0)
        return fail("echo exit");
    if (text == NULL || strstr(text, "hello-editforth") == NULL)
        return fail("echo output");

    printf("host_smoke: PASS time=%lld-%02lld-%02lld system echo\n",
           when[5], when[4], when[3]);
    return 0;
}

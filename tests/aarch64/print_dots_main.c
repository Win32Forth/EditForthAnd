/* Public domain. Run the aarch64 .S walk under qemu-user. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern uint64_t dstack[];
extern void run_print(uint64_t *dsp, uint64_t tos);

static char picture[128];
static size_t used;

void _putchar(long long c)
{
    if (used + 1 < sizeof picture)
        picture[used++] = (char)c;
    picture[used] = '\0';
}

static void append_number(unsigned long long value, int negative)
{
    char tmp[32];
    int n = 0;
    if (value == 0)
        tmp[n++] = '0';
    while (value > 0) {
        tmp[n++] = (char)('0' + (value % 10));
        value /= 10;
    }
    if (negative && used + 1 < sizeof picture)
        picture[used++] = '-';
    while (n > 0 && used + 1 < sizeof picture)
        picture[used++] = tmp[--n];
    picture[used] = '\0';
}

void _print_unsigned(unsigned long long value)
{
    append_number(value, 0);
}

void _print_signed(long long value)
{
    if (value < 0)
        append_number((unsigned long long)(-value), 1);
    else
        append_number((unsigned long long)value, 0);
}

static int expect(const char *want)
{
    if (strcmp(picture, want) == 0)
        return 0;
    fprintf(stderr, "print_dots: got \"%s\" want \"%s\"\n", picture, want);
    return 1;
}

static void show(uint64_t *dsp, uint64_t tos)
{
    used = 0;
    picture[0] = '\0';
    run_print(dsp, tos);
}

int main(void)
{
    uint64_t *sp0 = dstack + (4096 / sizeof(uint64_t));

    show(sp0, 0);
    if (expect("(0):"))
        return 1;

    sp0[-1] = 0;
    show(sp0 - 1, 42);
    if (expect("(1): 42 "))
        return 1;

    sp0[-1] = 0;
    sp0[-2] = 7;
    show(sp0 - 2, 9);
    if (expect("(2): 7 9 "))
        return 1;

    /* push 1, then 2, then 3: sentinel at the high address, oldest next. */
    sp0[-1] = 0;
    sp0[-2] = 1;
    sp0[-3] = 2;
    show(sp0 - 3, 3);
    if (expect("(3): 1 2 3 "))
        return 1;

    printf("print_dots: PASS\n");
    return 0;
}

/* Public domain.
   The .S depth model from the Mac kernel and Forth/kernel/arm64/prims.asm.
   Empty DSP == SP0. Each push stores the previous TOS and leaves a sentinel,
   so depth = (SP0 - DSP) / 8. The picture skips that sentinel. */
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define CELLS 64

static int64_t mem[CELLS];
static int64_t *sp0;
static int64_t *dsp;
static int64_t tos;

static void reset_stack(void)
{
    memset(mem, 0, sizeof mem);
    sp0 = mem + CELLS;
    dsp = sp0;
    tos = 0;
}

static void push_cell(int64_t value)
{
    *--dsp = tos;
    tos = value;
}

static void render(char *out, size_t cap)
{
    size_t n = 0;
    int64_t *base = sp0;
    int64_t depth;
    int64_t index;

    out[0] = '\0';
    if (dsp >= base) {
        snprintf(out, cap, "(0):");
        return;
    }
    depth = (int64_t)(base - dsp);
    n += (size_t)snprintf(out + n, cap - n, "(%lld): ", (long long)depth);
    if (depth == 1) {
        snprintf(out + n, cap - n, "%lld ", (long long)tos);
        return;
    }
    index = depth - 1;
    while (index != 0) {
        --index;
        n += (size_t)snprintf(out + n, cap - n, "%lld ", (long long)dsp[index]);
    }
    snprintf(out + n, cap - n, "%lld ", (long long)tos);
}

static int expect(const char *got, const char *want)
{
    if (strcmp(got, want) == 0)
        return 0;
    fprintf(stderr, "dot_s_model: got \"%s\" want \"%s\"\n", got, want);
    return 1;
}

int main(void)
{
    char picture[128];

    reset_stack();
    render(picture, sizeof picture);
    if (expect(picture, "(0):"))
        return 1;

    push_cell(42);
    render(picture, sizeof picture);
    if (expect(picture, "(1): 42 "))
        return 1;

    reset_stack();
    push_cell(7);
    push_cell(9);
    render(picture, sizeof picture);
    if (expect(picture, "(2): 7 9 "))
        return 1;

    reset_stack();
    push_cell(1);
    push_cell(2);
    push_cell(3);
    render(picture, sizeof picture);
    if (expect(picture, "(3): 1 2 3 "))
        return 1;

    /* The old picture counted the sentinel: one cell printed as depth 2. */
    if (strcmp(picture, "(4): 0 1 2 3 ") == 0)
        return 1;

    printf("dot_s_model: PASS\n");
    return 0;
}

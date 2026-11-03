/* Public domain.
   Same .S walk as Forth/kernel/arm64-android/prims.S _print_dots.
   Direct dstack addressing instead of the Android GOT. */
    .text
    .global run_print
    .global print_dots
    .type run_print, %function
    .type print_dots, %function

run_print:
    stp x20, x22, [sp, #-16]!
    mov x22, x0
    mov x20, x1
    stp x29, x30, [sp, #-16]!
    bl print_dots
    ldp x29, x30, [sp], #16
    ldp x20, x22, [sp], #16
    ret

print_dots:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x25, x26, [sp, #48]
    adrp x25, dstack
    add x25, x25, :lo12:dstack
    add x25, x25, #1, lsl #12
    cmp x22, x25
    b.hs _pd_empty
    sub x26, x25, x22
    lsr x26, x26, #3
    mov x0, #40
    bl _putchar
    mov x0, x26
    bl _print_unsigned
    mov x0, #41
    bl _putchar
    mov x0, #58
    bl _putchar
    mov x0, #32
    bl _putchar
    cmp x26, #1
    b.eq _pd_tos
    sub x25, x26, #1
_pd_mem:
    sub x25, x25, #1
    ldr x0, [x22, x25, lsl #3]
    bl _print_signed
    mov x0, #32
    bl _putchar
    cbnz x25, _pd_mem
_pd_tos:
    mov x0, x20
    bl _print_signed
    mov x0, #32
    bl _putchar
    b _pd_done
_pd_empty:
    mov x0, #40
    bl _putchar
    mov x0, #48
    bl _putchar
    mov x0, #41
    bl _putchar
    mov x0, #58
    bl _putchar
_pd_done:
    ldp x25, x26, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    ret

    .bss
    .balign 8
    .global dstack
dstack:
    .space 4096

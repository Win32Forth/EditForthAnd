/* Generated from Forth/kernel/arm64/prims.asm. Do not edit. */
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .extern next_debug
    .extern debug_break_asap
    .text
    .p2align 2
    .extern _putchar
    .extern _print_signed
    .extern _sa_putchar
    .extern _sa_print_signed
    .extern emit_cstr
    .extern _print_unsigned
    .extern dstack
    .extern return_stack
    .extern throw_handler
    .extern debug_floor
    .extern bye_flag
    .extern _quit_exit
    .extern _interpret_loop
    .extern _local_frame_try_exit
    .global DOCOL
    .global XRESTART
    .global DOEXIT
    .global XLit
    .global XDUP
    .global XDROP
    .global XSWAP
    .global XOVER
    .global XPLUS
    .global XMINUS
    .global XSTAR
    .global XSLASH
    .global XMOD
    .global XDOT
    .global XDOTS
    .global XRSDOT
    .global XCR
    .global XBYE
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XNEXT:
    .ascii "(NEXT)"
    .byte 0
hl_XNEXT:
    .ascii "(NEXT) ITC dispatch"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNEXT:
    .quad nm_XNEXT, hl_XNEXT
    .quad 0
    .quad XNEXT, XNEXT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNEXT
    .text
    .p2align 2
XNEXT:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
XNEXT_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_DOCOL:
    .ascii "(DOCOL)"
    .byte 0
hl_DOCOL:
    .ascii "(DOCOL) colon runtime"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_DOCOL:
    .quad nm_DOCOL, hl_DOCOL
    .quad 0
    .quad DOCOL, DOCOL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_DOCOL
    .text
    .p2align 2
DOCOL:
    str x19, [x23, #-8]!
    add x19, x21, #16
    ldr x0, [x19]
    cbnz x0, DOCOL_END
    b _quit_exit
DOCOL_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_DOEXIT:
    .ascii "EXIT"
    .byte 0
hl_DOEXIT:
    .ascii "EXIT ( -- ) return from colon definition"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_DOEXIT:
    .quad nm_DOEXIT, hl_DOEXIT
    .quad 0
    .quad DOEXIT, DOEXIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_DOEXIT
    .text
    .p2align 2
DOEXIT:
    bl _local_frame_try_exit
    ldr x19, [x23], #8
DOEXIT_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XLit:
    .ascii "LIT"
    .byte 0
hl_XLit:
    .ascii "LIT ( -- n ) internal: literal value"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLit:
    .quad nm_XLit, hl_XLit
    .quad 0
    .quad XLit, XLit_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLit
    .text
    .p2align 2
XLit:
    str x20, [x22, #-8]!
    ldr x20, [x19], #8
XLit_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDUP:
    .ascii "DUP"
    .byte 0
hl_XDUP:
    .ascii "DUP ( n -- n n ) duplicate top"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDUP:
    .quad nm_XDUP, hl_XDUP
    .quad 0
    .quad XDUP, XDUP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDUP
    .text
    .p2align 2
XDUP:
    str x20, [x22, #-8]!
XDUP_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDROP:
    .ascii "DROP"
    .byte 0
hl_XDROP:
    .ascii "DROP ( n -- ) discard top"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDROP:
    .quad nm_XDROP, hl_XDROP
    .quad 0
    .quad XDROP, XDROP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDROP
    .text
    .p2align 2
XDROP:
    ldr x20, [x22], #8
XDROP_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XSWAP:
    .ascii "SWAP"
    .byte 0
hl_XSWAP:
    .ascii "SWAP ( a b -- b a ) swap top two"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSWAP:
    .quad nm_XSWAP, hl_XSWAP
    .quad 0
    .quad XSWAP, XSWAP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSWAP
    .text
    .p2align 2
XSWAP:
    ldr x0, [x22]
    str x20, [x22]
    mov x20, x0
XSWAP_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XOVER:
    .ascii "OVER"
    .byte 0
hl_XOVER:
    .ascii "OVER ( a b -- a b a ) copy second"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XOVER:
    .quad nm_XOVER, hl_XOVER
    .quad 0
    .quad XOVER, XOVER_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XOVER
    .text
    .p2align 2
XOVER:
    str x20, [x22, #-8]!
    ldr x20, [x22, #8]
XOVER_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XPLUS:
    .ascii "+"
    .byte 0
hl_XPLUS:
    .ascii "+ ( n1 n2 -- n ) addition"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPLUS:
    .quad nm_XPLUS, hl_XPLUS
    .quad 0
    .quad XPLUS, XPLUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPLUS
    .text
    .p2align 2
XPLUS:
    ldr x0, [x22], #8
    add x20, x20, x0
XPLUS_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XMINUS:
    .ascii "-"
    .byte 0
hl_XMINUS:
    .ascii "- ( n1 n2 -- n ) subtraction"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMINUS:
    .quad nm_XMINUS, hl_XMINUS
    .quad 0
    .quad XMINUS, XMINUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMINUS
    .text
    .p2align 2
XMINUS:
    ldr x0, [x22], #8
    sub x20, x0, x20
XMINUS_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XSTAR:
    .ascii "*"
    .byte 0
hl_XSTAR:
    .ascii "* ( n1 n2 -- n ) multiplication"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSTAR:
    .quad nm_XSTAR, hl_XSTAR
    .quad 0
    .quad XSTAR, XSTAR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSTAR
    .text
    .p2align 2
XSTAR:
    ldr x0, [x22], #8
    mul x20, x20, x0
XSTAR_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XSLASH:
    .ascii "/"
    .byte 0
hl_XSLASH:
    .ascii "/ ( n1 n2 -- quot ) division (quotient)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSLASH:
    .quad nm_XSLASH, hl_XSLASH
    .quad 0
    .quad XSLASH, XSLASH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSLASH
    .text
    .p2align 2
XSLASH:
    ldr x0, [x22], #8
    sdiv x20, x0, x20
XSLASH_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XMOD:
    .ascii "MOD"
    .byte 0
hl_XMOD:
    .ascii "MOD ( n1 n2 -- rem ) modulo"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMOD:
    .quad nm_XMOD, hl_XMOD
    .quad 0
    .quad XMOD, XMOD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMOD
    .text
    .p2align 2
XMOD:
    ldr x0, [x22], #8
    sdiv x1, x0, x20
    msub x20, x1, x20, x0
XMOD_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XCR:
    .ascii "CR"
    .byte 0
hl_XCR:
    .ascii "CR ( -- ) carriage return / newline"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCR:
    .quad nm_XCR, hl_XCR
    .quad 0
    .quad XCR, XCR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCR
    .text
    .p2align 2
XCR:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x0, #10
    bl _putchar
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XCR_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDOT:
    .ascii "."
    .byte 0
hl_XDOT:
    .ascii ". ( n -- ) print number (with space)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOT:
    .quad nm_XDOT, hl_XDOT
    .quad 0
    .quad XDOT, XDOT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOT
    .text
    .p2align 2
XDOT:
    mov x0, x20
    ldr x20, [x22], #8
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _sa_print_signed
    mov x0, #32
    bl _sa_putchar
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XDOT_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDOTS:
    .ascii ".S"
    .byte 0
hl_XDOTS:
    .ascii ".S ( -- ) print data stack contents"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOTS:
    .quad nm_XDOTS, hl_XDOTS
    .quad 0
    .quad XDOTS, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOTS
    .text
    .p2align 2
XDOTS:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _print_dots
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XRSDOT:
    .ascii "R.S"
    .byte 0
hl_XRSDOT:
    .ascii "R.S ( -- ) print return stack contents"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRSDOT:
    .quad nm_XRSDOT, hl_XRSDOT
    .quad 0
    .quad XRSDOT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRSDOT
    .text
    .p2align 2
XRSDOT:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _print_rstack
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XBYE:
    .ascii "BYE"
    .byte 0
hl_XBYE:
    .ascii "BYE ( -- ) exit Forth to the host"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBYE:
    .quad nm_XBYE, hl_XBYE
    .quad 0
    .quad XBYE, XBYE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBYE
    .text
    .p2align 2
XBYE:
    b _quit_exit
XBYE_END:
XRESTART:
    b _interpret_loop
_print_dots:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x25, x26, [sp, #48]
    adrp x0, :got:msg_open
    ldr x0, [x0, :got_lo12:msg_open]
    bl emit_cstr
    adrp x25, :got:dstack
    ldr x25, [x25, :got_lo12:dstack]
    add x25, x25, #1, lsl #12
    sub x26, x25, x22
    lsr x26, x26, #3
    add x0, x26, #1
    bl _print_signed
    adrp x0, :got:msg_mid
    ldr x0, [x0, :got_lo12:msg_mid]
    bl emit_cstr
    sub x25, x25, #8
_print_dots_loop:
    cmp x25, x22
    b.lo _print_dots_tos
    ldr x0, [x25]
    bl _print_signed
    mov x0, #32
    bl _putchar
    sub x25, x25, #8
    b _print_dots_loop
_print_dots_tos:
    mov x0, x20
    bl _print_signed
    mov x0, #32
    bl _putchar
    ldp x25, x26, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    ret
_print_rstack:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    stp x25, x26, [sp, #48]
    adrp x25, :got:return_stack
    ldr x25, [x25, :got_lo12:return_stack]
    add x25, x25, #1, lsl #12
    adrp x0, :got:debug_floor
    ldr x0, [x0, :got_lo12:debug_floor]
    ldr x0, [x0]
    cbz x0, _pr_floor_keep
    cmp x0, x25
    b.hi _pr_floor_keep
    cmp x0, x23
    b.ls _pr_floor_keep
    mov x25, x0
_pr_floor_keep:
    cmp x23, x25
    b.hs _pr_empty
    sub x26, x25, x23
    lsr x26, x26, #3
    str x26, [sp, #64]
    adrp x0, :got:throw_handler
    ldr x0, [x0, :got_lo12:throw_handler]
    ldr x0, [x0]
    str x0, [sp, #72]
    mov x25, #0
    mov x26, #0
_pr_count:
    ldr x0, [sp, #64]
    cmp x25, x0
    b.hs _pr_counted
    ldr x1, [sp, #72]
    cbz x1, _pr_count_one
    add x2, x23, x25, lsl #3
    cmp x2, x1
    b.ne _pr_count_one
    add x25, x25, #6
    b _pr_count
_pr_count_one:
    add x26, x26, #1
    add x25, x25, #1
    b _pr_count
_pr_counted:
    cbz x26, _pr_empty
    str x26, [sp, #80]
    adrp x0, :got:msg_open
    ldr x0, [x0, :got_lo12:msg_open]
    bl emit_cstr
    ldr x0, [sp, #80]
    bl _print_unsigned
    adrp x0, :got:msg_mid
    ldr x0, [x0, :got_lo12:msg_mid]
    bl emit_cstr
    mov x25, #0
_pr_show:
    ldr x0, [sp, #64]
    cmp x25, x0
    b.hs _pr_done
    ldr x1, [sp, #72]
    cbz x1, _pr_show_one
    add x2, x23, x25, lsl #3
    cmp x2, x1
    b.ne _pr_show_one
    add x25, x25, #6
    b _pr_show
_pr_show_one:
    ldr x0, [x23, x25, lsl #3]
    bl _print_unsigned
    mov x0, #32
    bl _putchar
    add x25, x25, #1
    b _pr_show
_pr_empty:
    adrp x0, :got:msg_open
    ldr x0, [x0, :got_lo12:msg_open]
    bl emit_cstr
    mov x0, #0
    bl _print_unsigned
    adrp x0, :got:msg_mid
    ldr x0, [x0, :got_lo12:msg_mid]
    bl emit_cstr
_pr_done:
    ldp x25, x26, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
    ret
next_debug_gate:
    adrp x16, :got:next_debug
    ldr x16, [x16, :got_lo12:next_debug]
    br x16
    .section .rodata,"a",@progbits
    .p2align 3
msg_open:
    .ascii "( "
    .byte 0
msg_mid:
    .ascii " ) "
    .byte 0

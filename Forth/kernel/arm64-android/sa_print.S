/* Generated from Forth/kernel/arm64/sa_print.asm. Do not edit. */
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .extern next_debug
    .extern debug_break_asap
    .text
    .p2align 2
    .extern emit_fn
    .extern base_var
    .extern sa_win_putchar
    .global _sa_putchar
    .global _sa_print_signed
    .global _sa_print_unsigned
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_SA_PRINT:
    .ascii "(SA-PRINT)"
    .byte 0
hl_SA_PRINT:
    .ascii "(SA-PRINT) ( -- ) stand-alone print runtime block"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_SA_PRINT:
    .quad nm_SA_PRINT, hl_SA_PRINT
    .word 0, 1073741824
    .quad SA_PRINT, SA_PRINT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_SA_PRINT
    .text
    .p2align 2
    .section .bwstr,"aw",@progbits
    .p2align 0
nm__load_base:
    .ascii "(LOAD-BASE)"
    .byte 0
hl__load_base:
    .ascii "(LOAD-BASE) ( -- ) x6 = BASE clamped 2..36"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row__load_base:
    .quad nm__load_base, hl__load_base
    .word 0, 1073741824
    .quad _load_base, _load_base_end
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row__load_base
    .text
    .p2align 2
    .section .bwstr,"aw",@progbits
    .p2align 0
nm__digit_char:
    .ascii "(DIGIT-CHAR)"
    .byte 0
hl__digit_char:
    .ascii "(DIGIT-CHAR) ( -- ) digit 0..35 to ASCII in w8"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row__digit_char:
    .quad nm__digit_char, hl__digit_char
    .word 0, 1073741824
    .quad _digit_char, _digit_char_end
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row__digit_char
    .text
    .p2align 2
    .section .bwstr,"aw",@progbits
    .p2align 0
nm__i64_to_str:
    .ascii "(I64>STR)"
    .byte 0
hl__i64_to_str:
    .ascii "(I64>STR) ( -- ) signed number to ASCII in a buffer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row__i64_to_str:
    .quad nm__i64_to_str, hl__i64_to_str
    .word 0, 1073741824
    .quad _i64_to_str, _i64_to_str_end
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row__i64_to_str
    .text
    .p2align 2
    .section .bwstr,"aw",@progbits
    .p2align 0
nm__u64_to_str:
    .ascii "(U64>STR)"
    .byte 0
hl__u64_to_str:
    .ascii "(U64>STR) ( -- ) unsigned number to ASCII in a buffer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row__u64_to_str:
    .quad nm__u64_to_str, hl__u64_to_str
    .word 0, 1073741824
    .quad _u64_to_str, _u64_to_str_end
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row__u64_to_str
    .text
    .p2align 2
    .section .bwstr,"aw",@progbits
    .p2align 0
nm__print_string_svc:
    .ascii "(PRINT-STRING)"
    .byte 0
hl__print_string_svc:
    .ascii "(PRINT-STRING) ( -- ) print a NUL-terminated string"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row__print_string_svc:
    .quad nm__print_string_svc, hl__print_string_svc
    .word 0, 1073741824
    .quad _print_string_svc, _print_string_svc_end
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row__print_string_svc
    .text
    .p2align 2
    .section .bwstr,"aw",@progbits
    .p2align 0
nm__sa_print_signed:
    .ascii "(.)"
    .byte 0
hl__sa_print_signed:
    .ascii "(.) ( n -- ) print a signed number"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row__sa_print_signed:
    .quad nm__sa_print_signed, hl__sa_print_signed
    .word 0, 1073741824
    .quad _sa_print_signed, _sa_print_signed_end
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row__sa_print_signed
    .text
    .p2align 2
    .section .bwstr,"aw",@progbits
    .p2align 0
nm__sa_print_unsigned:
    .ascii "(U.)"
    .byte 0
hl__sa_print_unsigned:
    .ascii "(U.) ( u -- ) print an unsigned number"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row__sa_print_unsigned:
    .quad nm__sa_print_unsigned, hl__sa_print_unsigned
    .word 0, 1073741824
    .quad _sa_print_unsigned, _sa_print_unsigned_end
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row__sa_print_unsigned
    .text
    .p2align 2
SA_PRINT:
_sa_putchar:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adrp x1, sa_print_emit_hook_ptr
    add x1, x1, :lo12:sa_print_emit_hook_ptr
    ldr x1, [x1]
    cbnz x1, _spc_have
    adrp x1, :got:emit_fn
    ldr x1, [x1, :got_lo12:emit_fn]
_spc_have:
    ldr x1, [x1]
    cbz x1, _spc_win
    blr x1
    b _spc_done
_spc_win:
    adrp x1, sa_win_putchar_ptr
    add x1, x1, :lo12:sa_win_putchar_ptr
    ldr x1, [x1]
    cbz x1, _spc_done
    blr x1
_spc_done:
    ldp x29, x30, [sp], #16
    ret
_sa_write:
    stp x29, x30, [sp, #-32]!
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    adrp x2, sa_print_emit_buf_ptr
    add x2, x2, :lo12:sa_print_emit_buf_ptr
    ldr x2, [x2]
    cbz x2, _swr_bytes
    ldr x2, [x2]
    cbz x2, _swr_bytes
    mov x0, x19
    mov x1, x20
    blr x2
    b _swr_done
_swr_bytes:
    cbz x20, _swr_done
_swr_loop:
    ldrb w0, [x19], #1
    bl _sa_putchar
    sub x20, x20, #1
    cbnz x20, _swr_loop
_swr_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
_load_base:
    adrp x6, sa_print_base_ptr
    add x6, x6, :lo12:sa_print_base_ptr
    ldr x6, [x6]
    cbnz x6, _lb_have
    adrp x6, :got:base_var
    ldr x6, [x6, :got_lo12:base_var]
_lb_have:
    ldr x6, [x6]
    cmp x6, #2
    b.lo _lb_def
    cmp x6, #36
    b.hi _lb_def
    ret
_lb_def:
    mov x6, #10
    ret
_load_base_end:
_digit_char:
    cmp w8, #9
    b.hi _dc_alpha
    add w8, w8, #48
    ret
_dc_alpha:
    add w8, w8, #55
    ret
_digit_char_end:
_i64_to_str:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    mov x2, x1
    add x3, x1, #64
    mov x4, x0
    mov x5, #0
    bl _load_base
    mov x19, x6
    cmp x4, #0
    b.pl _i2s_pos
    mov w6, #'-'
    strb w6, [x2], #1
    neg x4, x4
_i2s_pos:
    cbnz x4, _i2s_div
    mov w6, #'0'
    strb w6, [x2], #1
    strb wzr, [x2]
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_i2s_div:
    udiv x7, x4, x19
    msub x8, x7, x19, x4
    bl _digit_char
    strb w8, [x3, #-1]!
    add x5, x5, #1
    mov x4, x7
    cbnz x4, _i2s_div
_i2s_cpy:
    cbz x5, _i2s_done
    ldrb w8, [x3], #1
    strb w8, [x2], #1
    sub x5, x5, #1
    b _i2s_cpy
_i2s_done:
    strb wzr, [x2]
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_i64_to_str_end:
_u64_to_str:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    mov x2, x1
    add x3, x1, #64
    mov x4, x0
    mov x5, #0
    bl _load_base
    mov x19, x6
    cbnz x4, _u2s_div
    mov w6, #'0'
    strb w6, [x2], #1
    strb wzr, [x2]
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_u2s_div:
    udiv x7, x4, x19
    msub x8, x7, x19, x4
    bl _digit_char
    strb w8, [x3, #-1]!
    add x5, x5, #1
    mov x4, x7
    cbnz x4, _u2s_div
_u2s_cpy:
    cbz x5, _u2s_done
    ldrb w8, [x3], #1
    strb w8, [x2], #1
    sub x5, x5, #1
    b _u2s_cpy
_u2s_done:
    strb wzr, [x2]
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_u64_to_str_end:
_print_string_svc:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    mov x1, x0
    mov x2, #0
_pss_len:
    ldrb w3, [x1, x2]
    cbz w3, _pss_go
    add x2, x2, #1
    b _pss_len
_pss_go:
    mov x0, x1
    mov x1, x2
    bl _sa_write
    ldp x29, x30, [sp], #16
    ret
_print_string_svc_end:
_sa_print_signed:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    mov x1, #1
    lsl x1, x1, #63
    cmp x0, x1
    b.ne _sps_norm
    adrp x0, sa_min_str
    add x0, x0, :lo12:sa_min_str
    bl _print_string_svc
    ldp x29, x30, [sp], #16
    ret
_sps_norm:
    sub sp, sp, #80
    mov x1, sp
    bl _i64_to_str
    mov x0, sp
    bl _print_string_svc
    add sp, sp, #80
    ldp x29, x30, [sp], #16
    ret
_sa_print_signed_end:
_sa_print_unsigned:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #80
    mov x1, sp
    bl _u64_to_str
    mov x0, sp
    bl _print_string_svc
    add sp, sp, #80
    ldp x29, x30, [sp], #16
    ret
_sa_print_unsigned_end:
    .p2align 3
sa_min_str:
    .ascii "-9223372036854775808"
    .byte 0
    .data
    .p2align 3
    .p2align 3
sa_win_putchar_ptr:
    .quad sa_win_putchar
sa_print_base_ptr:
    .quad 0
sa_print_emit_hook_ptr:
    .quad 0
sa_print_emit_buf_ptr:
    .quad 0
sa_print_zero_cell:
    .quad 0
SA_PRINT_END:

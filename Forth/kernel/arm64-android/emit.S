/* Generated from Forth/kernel/arm64/emit.asm. Do not edit. */
    .text
    .p2align 2
    .extern emit_fn
    .extern numbuf
    .extern debug_field_count
    .extern debug_field_len
    .extern debug_armed
    .extern _debug_note_byte
    .global emit_char
    .global _putchar
    .global emit_str
    .global emit_cstr
    .global emit_i64
    .global _print_signed
    .global _print_unsigned
    .global msg_under
    .global msg_full
    .global msg_div0
    .global msg_huh
_putchar:
emit_char:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    str x0, [sp, #16]
    adrp x1, :got:debug_field_count
    ldr x1, [x1, :got_lo12:debug_field_count]
    ldr x1, [x1]
    cbz x1, emit_char_noted
    adrp x2, :got:debug_field_len
    ldr x2, [x2, :got_lo12:debug_field_len]
    ldr x3, [x2]
    add x3, x3, #1
    str x3, [x2]
emit_char_noted:
    adrp x1, :got:debug_armed
    ldr x1, [x1, :got_lo12:debug_armed]
    ldr x1, [x1]
    cbz x1, emit_char_hook
    ldr w0, [sp, #16]
    bl _debug_note_byte
    ldr x0, [sp, #16]
emit_char_hook:
    adrp x16, :got:emit_fn
    ldr x16, [x16, :got_lo12:emit_fn]
    ldr x16, [x16]
    cbz x16, emit_char_skip
    blr x16
emit_char_skip:
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    ret
emit_str:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    mov x19, x0
    mov x20, x1
emit_str_loop:
    cbz x20, emit_str_done
    ldrb w0, [x19], #1
    bl emit_char
    sub x20, x20, #1
    b emit_str_loop
emit_str_done:
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    ret
emit_cstr:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    mov x19, x0
emit_cstr_loop:
    ldrb w0, [x19], #1
    cbz w0, emit_cstr_done
    bl emit_char
    b emit_cstr_loop
emit_cstr_done:
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    ret
_print_signed:
emit_i64:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    mov x19, x0
    tst x19, x19
    b.pl emit_i64_mag
    mov x0, #1
    lsl x0, x0, #63
    cmp x19, x0
    b.ne emit_i64_neg
    adrp x0, :got:msg_min
    ldr x0, [x0, :got_lo12:msg_min]
    bl emit_cstr
    b emit_i64_done
emit_i64_neg:
    mov x0, #'-'
    bl emit_char
    neg x19, x19
emit_i64_mag:
    adrp x20, :got:numbuf
    ldr x20, [x20, :got_lo12:numbuf]
    add x20, x20, #32
    mov x21, #10
emit_i64_digit:
    udiv x2, x19, x21
    msub x3, x2, x21, x19
    add w3, w3, #'0'
    sub x20, x20, #1
    strb w3, [x20]
    mov x19, x2
    cbnz x19, emit_i64_digit
    adrp x1, :got:numbuf
    ldr x1, [x1, :got_lo12:numbuf]
    add x1, x1, #32
    sub x1, x1, x20
    mov x0, x20
    bl emit_str
emit_i64_done:
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
    ret
_print_unsigned:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    mov x19, x0
    adrp x20, :got:numbuf
    ldr x20, [x20, :got_lo12:numbuf]
    add x20, x20, #32
    mov x21, #10
emit_u64_digit:
    udiv x2, x19, x21
    msub x3, x2, x21, x19
    add w3, w3, #'0'
    sub x20, x20, #1
    strb w3, [x20]
    mov x19, x2
    cbnz x19, emit_u64_digit
    adrp x1, :got:numbuf
    ldr x1, [x1, :got_lo12:numbuf]
    add x1, x1, #32
    sub x1, x1, x20
    mov x0, x20
    bl emit_str
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
    ret
    .section .rodata,"a",@progbits
    .p2align 3
msg_under:
    .ascii " stack empty"
    .byte 10
    .byte 0
msg_full:
    .ascii " stack full"
    .byte 10
    .byte 0
msg_div0:
    .ascii " divide by zero"
    .byte 10
    .byte 0
msg_huh:
    .ascii " ?"
    .byte 10
    .byte 0
msg_min:
    .ascii "-9223372036854775808"
    .byte 0

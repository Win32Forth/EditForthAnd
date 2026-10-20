/* Generated from Forth/kernel/arm64/dict.asm. Do not edit. */
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .extern next_debug
    .extern debug_break_asap
    .text
    .p2align 2
    .extern latest_var
    .extern last_cfa
    .extern noname_xt
    .extern here_ptr
    .extern state_var
    .extern source_cur
    .extern source_end
    .extern source_base
    .extern to_in
    .extern current_var
    .extern search_order
    .extern search_order_n
    .extern base_var
    .extern pending_help_addr
    .extern pending_help_len
    .extern _view_line_now
    .extern view_src_id
    .extern exit_cfa
    .extern emit_cstr
    .extern DOCOL
    .global _dict_hash
    .global _header_build
    .global _nfa_from_cfa
    .global _nfa_smudge_cfa
    .global _nfa_reveal_cfa
    .global _find_word
    .global _parse_number
    .global _next_word
    .global _cursor_load
    .global _cursor_commit
    .global _compile_cell
    .global _strlen
    .global _take_pending_help
    .extern _local_compile_reset
    .global XCOLON
    .global XSEMI
_dict_hash:
    mov x2, #5381
    cbz x1, _dict_hash_empty
    mov x3, #0
_dict_hash_1:
    cmp x3, x1
    b.hs _dict_hash_2
    ldrb w4, [x0, x3]
    cmp w4, #'a'
    b.lo _dict_hash_11
    cmp w4, #'z'
    b.hi _dict_hash_11
    sub w4, w4, #32
_dict_hash_11:
    lsl x5, x2, #5
    add x2, x5, x2
    add x2, x2, x4
    add x3, x3, #1
    b _dict_hash_1
_dict_hash_2:
    mov x0, #16
    udiv x1, x2, x0
    msub x0, x1, x0, x2
    ret
_dict_hash_empty:
    mov x0, #0
    ret
_header_build:
    sub sp, sp, #128
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    stp x23, x24, [sp, #80]
    str x5, [sp, #112]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3
    mov x23, x4
    adrp x24, :got:current_var
    ldr x24, [x24, :got_lo12:current_var]
    ldr x24, [x24]
    adrp x9, :got:here_ptr
    ldr x9, [x9, :got_lo12:here_ptr]
    ldr x6, [x9]
    mov x8, x6
    cmp x22, #255
    b.ls _hb_help_ok
    mov x22, #255
_hb_help_ok:
    strb w22, [x6], #1
    mov x2, #0
_hb_help_cp:
    cmp x2, x22
    b.hs _hb_help_pad
    ldrb w3, [x21, x2]
    strb w3, [x6], #1
    add x2, x2, #1
    b _hb_help_cp
_hb_help_pad:
    sub x2, x6, x8
_hb_help_al:
    tst x2, #7
    b.eq _hb_name
    strb wzr, [x6], #1
    add x2, x2, #1
    b _hb_help_al
_hb_name:
    mov x7, x6
    cmp x20, #127
    b.ls _hb_nlen
    mov x20, #127
_hb_nlen:
    and w20, w20, #0x7F
    strb w20, [x6], #1
    mov x2, #0
_hb_name_cp:
    cmp x2, x20
    b.hs _hb_name_pad
    ldrb w3, [x19, x2]
    cmp w3, #'a'
    b.lo _hb_name_st
    cmp w3, #'z'
    b.hi _hb_name_st
    sub w3, w3, #32
_hb_name_st:
    strb w3, [x6], #1
    add x2, x2, #1
    b _hb_name_cp
_hb_name_pad:
    sub x2, x6, x7
_hb_name_al:
    tst x2, #7
    b.eq _hb_link
    strb wzr, [x6], #1
    add x2, x2, #1
    b _hb_name_al
_hb_link:
    mov x0, x19
    mov x1, x20
    bl _dict_hash
    add x10, x24, x0, lsl #3
    ldr x1, [x10]
    str x1, [x6], #8
    str xzr, [x6], #8
    mov x0, x6
    str x23, [x6], #8
    sub x1, x0, x7
    and x1, x1, #0xFFFF
    sub x2, x0, x8
    and x2, x2, #0xFFFF
    lsl x2, x2, #16
    orr x1, x1, x2
    stp x0, x1, [sp, #96]
    bl _view_line_now
    mov x3, x0
    adrp x2, :got:view_src_id
    ldr x2, [x2, :got_lo12:view_src_id]
    ldr x2, [x2]
    ldp x0, x1, [sp, #96]
    and x3, x3, #0xFFFF
    lsl x3, x3, #32
    orr x1, x1, x3
    mov x4, #0x1FFF
    and x2, x2, x4
    lsl x2, x2, #48
    orr x1, x1, x2
    ldr x5, [sp, #112]
    orr x1, x1, x5
    str x1, [x0, #-8]
    str x6, [x9]
    str x0, [x10]
    adrp x2, :got:last_cfa
    ldr x2, [x2, :got_lo12:last_cfa]
    str x0, [x2]
    ldp x23, x24, [sp, #80]
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #128
    ret
_nfa_from_cfa:
    ldr x1, [x0, #-8]
    and x1, x1, #0xFFFF
    sub x0, x0, x1
    ret
_nfa_smudge_cfa:
    ldr x1, [x0, #-8]
    and x1, x1, #0xFFFF
    sub x1, x0, x1
    ldrb w2, [x1]
    orr w2, w2, #0x80
    strb w2, [x1]
    ret
_nfa_reveal_cfa:
    ldr x1, [x0, #-8]
    and x1, x1, #0xFFFF
    sub x1, x0, x1
    ldrb w2, [x1]
    and w2, w2, #0x7F
    strb w2, [x1]
    ret
_find_word:
    mov x6, x0
    mov x7, x1
    mov x12, x30
    bl _dict_hash
    mov x30, x12
    mov x14, x0
    adrp x10, :got:search_order_n
    ldr x10, [x10, :got_lo12:search_order_n]
    ldr x11, [x10]
    mov x13, #0
_find_wids:
    cmp x13, x11
    b.hs _find_miss
    adrp x10, :got:search_order
    ldr x10, [x10, :got_lo12:search_order]
    ldr x10, [x10, x13, lsl #3]
    cbz x10, _find_next_wid
    add x4, x10, x14, lsl #3
    ldr x4, [x4]
_find_loop:
    cbz x4, _find_next_wid
    ldr x5, [x4, #-8]
    and x8, x5, #0xFFFF
    sub x8, x4, x8
    ldrb w9, [x8]
    tbnz w9, #7, _find_link
    and w9, w9, #0x7F
    cmp w9, w7
    b.ne _find_link
    mov x9, x6
    add x10, x8, #1
    mov x15, x7
_find_cmp:
    cbz x15, _find_hit
    ldrb w12, [x9], #1
    ldrb w16, [x10], #1
    cmp w12, #'a'
    b.lo _find_fold
    cmp w12, #'z'
    b.hi _find_fold
    sub w12, w12, #32
_find_fold:
    cmp w12, w16
    b.ne _find_link
    sub x15, x15, #1
    b _find_cmp
_find_hit:
    ldr x1, [x4, #-8]
    mov x0, x4
    ret
_find_link:
    ldr x4, [x4, #-16]
    b _find_loop
_find_next_wid:
    add x13, x13, #1
    b _find_wids
_find_miss:
    mov x0, #0
    mov x1, #0
    ret
_parse_number:
    cbz x1, _pnum_no
    mov x9, x0
    mov x10, x1
    mov x11, #0
    mov x12, #0
    add x3, x9, x10
    ldrb w4, [x3, #-1]
    cmp w4, #46
    b.ne _pnum_base
    mov x12, #1
    sub x10, x10, #1
    cbz x10, _pnum_no
_pnum_base:
    adrp x5, :got:base_var
    ldr x5, [x5, :got_lo12:base_var]
    ldr x5, [x5]
    cmp x5, #2
    b.lo _pnum_b10
    cmp x5, #36
    b.ls _pnum_bok
_pnum_b10:
    mov x5, #10
_pnum_bok:
    ldrb w3, [x9]
    cmp w3, #'-'
    b.ne _pnum_pref
    mov x11, #1
    add x9, x9, #1
    sub x10, x10, #1
    cbz x10, _pnum_no
    ldrb w3, [x9]
_pnum_pref:
    cmp w3, #'#'
    b.ne _pnum_hex
    mov x5, #10
    b _pnum_ate
_pnum_hex:
    cmp w3, #'$'
    b.ne _pnum_bin
    mov x5, #16
    b _pnum_ate
_pnum_bin:
    cmp w3, #'%'
    b.ne _pnum_digs
    mov x5, #2
_pnum_ate:
    add x9, x9, #1
    sub x10, x10, #1
    cbz x10, _pnum_no
    cbnz x11, _pnum_digs
    ldrb w3, [x9]
    cmp w3, #'-'
    b.ne _pnum_digs
    mov x11, #1
    add x9, x9, #1
    sub x10, x10, #1
_pnum_digs:
    cbz x10, _pnum_no
    mov x6, #0
    mov x7, #0
_pnum_loop:
    cbz x10, _pnum_done
    ldrb w3, [x9], #1
    sub x10, x10, #1
    sub w4, w3, #'0'
    cmp w4, #9
    b.ls _pnum_digit
    cmp w3, #'a'
    b.lo _pnum_upper
    cmp w3, #'z'
    b.hi _pnum_no
    sub w4, w3, #'a'
    add w4, w4, #10
    b _pnum_digit
_pnum_upper:
    cmp w3, #'A'
    b.lo _pnum_no
    cmp w3, #'Z'
    b.hi _pnum_no
    sub w4, w3, #'A'
    add w4, w4, #10
_pnum_digit:
    cmp x4, x5
    b.hs _pnum_no
    mul x6, x6, x5
    add x6, x6, x4
    add x7, x7, #1
    b _pnum_loop
_pnum_done:
    cbz x7, _pnum_no
    cbz x11, _pnum_pos
    neg x6, x6
_pnum_pos:
    cbz x12, _pnum_yes
    asr x2, x6, #63
    mov x1, x6
    mov x0, #2
    ret
_pnum_yes:
    mov x1, x6
    mov x0, #1
    ret
_pnum_no:
    mov x0, #0
    ret
_cursor_load:
    adrp x0, :got:source_base
    ldr x0, [x0, :got_lo12:source_base]
    ldr x0, [x0]
    adrp x1, :got:to_in
    ldr x1, [x1, :got_lo12:to_in]
    ldr x1, [x1]
    add x0, x0, x1
    adrp x1, :got:source_cur
    ldr x1, [x1, :got_lo12:source_cur]
    str x0, [x1]
    ret
_cursor_commit:
    stp x0, x1, [sp, #-16]!
    adrp x1, :got:source_cur
    ldr x1, [x1, :got_lo12:source_cur]
    str x0, [x1]
    adrp x1, :got:source_base
    ldr x1, [x1, :got_lo12:source_base]
    ldr x1, [x1]
    sub x0, x0, x1
    adrp x1, :got:to_in
    ldr x1, [x1, :got_lo12:to_in]
    str x0, [x1]
    ldp x0, x1, [sp], #16
    ret
_next_word:
    stp x29, x30, [sp, #-16]!
    bl _cursor_load
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x3, [x3]
_nw_skip:
    cmp x0, x3
    b.hs _nw_none
    ldrb w4, [x0]
    cmp w4, #32
    b.eq _nw_adv
    cmp w4, #9
    b.eq _nw_adv
    cmp w4, #10
    b.eq _nw_adv
    cmp w4, #13
    b.eq _nw_adv
    b _nw_tok
_nw_adv:
    add x0, x0, #1
    b _nw_skip
_nw_tok:
    mov x1, x0
_nw_scan:
    cmp x0, x3
    b.hs _nw_have
    ldrb w4, [x0]
    cmp w4, #32
    b.eq _nw_have
    cmp w4, #9
    b.eq _nw_have
    cmp w4, #10
    b.eq _nw_have
    cmp w4, #13
    b.eq _nw_have
    add x0, x0, #1
    b _nw_scan
_nw_have:
    mov x4, x0
    cmp x0, x3
    b.hs _nw_store
    ldrb w5, [x0]
    cmp w5, #32
    b.eq _nw_eat
    cmp w5, #9
    b.eq _nw_eat
    cmp w5, #10
    b.eq _nw_eat
    cmp w5, #13
    b.eq _nw_eat
    b _nw_store
_nw_eat:
    add x0, x0, #1
_nw_store:
    bl _cursor_commit
    sub x1, x4, x1
    sub x0, x4, x1
    ldp x29, x30, [sp], #16
    ret
_nw_none:
    bl _cursor_commit
    mov x1, #0
    ldp x29, x30, [sp], #16
    ret
_compile_cell:
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    ldr x2, [x1]
    str x0, [x2], #8
    str x2, [x1]
    ret
_strlen:
    mov x1, x0
_strlen_loop:
    ldrb w2, [x0], #1
    cbnz w2, _strlen_loop
    sub x0, x0, x1
    sub x0, x0, #1
    ret
_take_pending_help:
    adrp x0, :got:pending_help_addr
    ldr x0, [x0, :got_lo12:pending_help_addr]
    ldr x2, [x0]
    adrp x1, :got:pending_help_len
    ldr x1, [x1, :got_lo12:pending_help_len]
    ldr x3, [x1]
    str xzr, [x0]
    str xzr, [x1]
    cbnz x2, _tph_ok
    adrp x2, :got:boot_h_empty
    ldr x2, [x2, :got_lo12:boot_h_empty]
    mov x3, #0
_tph_ok:
    ret
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XCOLON:
    .ascii ":"
    .byte 0
hl_XCOLON:
    .ascii "( 'name' -- ) start colon definition"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCOLON:
    .quad nm_XCOLON, hl_XCOLON
    .quad 0
    .quad XCOLON, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCOLON
    .text
    .p2align 2
XCOLON:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    bl _local_compile_reset
    bl _next_word
    cbz x1, _colon_fail
    stp x0, x1, [sp, #48]
    bl _take_pending_help
    ldp x0, x1, [sp, #48]
    adrp x4, :got:DOCOL
    ldr x4, [x4, :got_lo12:DOCOL]
    mov x5, #0
    bl _header_build
    bl _nfa_smudge_cfa
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    ldr x2, [x1]
    str xzr, [x2], #8
    str x2, [x1]
    adrp x1, :got:state_var
    ldr x1, [x1, :got_lo12:state_var]
    mov x2, #1
    str x2, [x1]
    adrp x1, :got:noname_xt
    ldr x1, [x1, :got_lo12:noname_xt]
    str xzr, [x1]
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_colon_fail:
    adrp x0, :got:msg_huh
    ldr x0, [x0, :got_lo12:msg_huh]
    bl emit_cstr
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
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
nm_XSEMI:
    .byte 59
    .byte 0
hl_XSEMI:
    .byte 59
    .ascii "( -- ) end colon definition (immediate)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSEMI:
    .quad nm_XSEMI, hl_XSEMI
    .word 0, 2147483648
    .quad XSEMI, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSEMI
    .text
    .p2align 2
XSEMI:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x0, :got:exit_cfa
    ldr x0, [x0, :got_lo12:exit_cfa]
    ldr x0, [x0]
    bl _compile_cell
    adrp x0, :got:last_cfa
    ldr x0, [x0, :got_lo12:last_cfa]
    ldr x0, [x0]
    bl _nfa_reveal_cfa
    adrp x1, :got:state_var
    ldr x1, [x1, :got_lo12:state_var]
    str xzr, [x1]
    bl _local_compile_reset
    adrp x0, :got:noname_xt
    ldr x0, [x0, :got_lo12:noname_xt]
    ldr x1, [x0]
    cbz x1, _semi_done
    str xzr, [x0]
    str x20, [x22, #-8]!
    mov x20, x1
_semi_done:
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
nm_XNONAME:
    .ascii ":NONAME"
    .byte 0
hl_XNONAME:
    .ascii ":NONAME ( -- xt ) anonymous colon definition. semicolon leaves the xt"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNONAME:
    .quad nm_XNONAME, hl_XNONAME
    .quad 0
    .quad XNONAME, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNONAME
    .text
    .p2align 2
XNONAME:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _local_compile_reset
    bl _take_pending_help
    adrp x0, :got:boot_h_empty
    ldr x0, [x0, :got_lo12:boot_h_empty]
    mov x1, #0
    adrp x4, :got:DOCOL
    ldr x4, [x4, :got_lo12:DOCOL]
    mov x5, #0
    bl _header_build
    bl _nfa_smudge_cfa
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    ldr x2, [x1]
    str xzr, [x2], #8
    str x2, [x1]
    adrp x1, :got:last_cfa
    ldr x1, [x1, :got_lo12:last_cfa]
    ldr x2, [x1]
    adrp x1, :got:noname_xt
    ldr x1, [x1, :got_lo12:noname_xt]
    str x2, [x1]
    adrp x1, :got:state_var
    ldr x1, [x1, :got_lo12:state_var]
    mov x2, #1
    str x2, [x1]
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
next_debug_gate:
    adrp x16, :got:next_debug
    ldr x16, [x16, :got_lo12:next_debug]
    br x16
    .section .rodata,"a",@progbits
    .p2align 3
boot_h_empty:
    .byte 0
msg_huh:
    .ascii " ?"
    .byte 10
    .byte 0

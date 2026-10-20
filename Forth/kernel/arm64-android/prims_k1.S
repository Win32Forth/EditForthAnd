/* Generated from Forth/kernel/arm64/prims_k1.asm. Do not edit. */
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .extern next_debug
    .extern debug_break_asap
    .text
    .p2align 2
    .extern source_base
    .extern source_cur
    .extern source_end
    .extern to_in
    .extern blk_var
    .extern _cursor_load
    .extern _cursor_commit
    .extern _take_line
    .extern line_mode
    .extern throw_handler
    .extern here_ptr
    .extern user_dict_size_cell
    .extern xchar_emit_buf
    .extern state_var
    .extern last_cfa
    .extern base_var
    .extern current_var
    .extern search_order
    .extern search_order_n
    .extern latest_var
    .extern data_stack
    .extern user_dict_area
    .extern word_scratch
    .extern pending_help_addr
    .extern pending_help_len
    .extern cfa_lit
    .extern cfa_branch
    .extern cfa_0branch
    .extern cfa_does
    .extern cfa_slit
    .extern cfa_cstr
    .extern pad_buffer
    .extern wordlist_reg
    .extern wordlist_reg_n
    .extern DOCOL
    .extern _next_word
    .extern _find_word
    .extern _compile_cell
    .extern _header_build
    .extern _nfa_reveal_cfa
    .extern _take_pending_help
    .extern emit_str
    .extern emit_cstr
    .extern _putchar
    .extern _print_wid_name
    .extern _print_signed
    .extern _quit_exit
    .extern _do_quit
    .extern _throw_unwind_to_sp
    .extern eval_resume_sp
    .global DOVAR
    .global DOCON
    .global DODOES
    .global XTHROW
    .global XBranch
    .global X0Branch
    .global XTYPE
    .global msg_allot
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XQDUP:
    .ascii "?DUP"
    .byte 0
hl_XQDUP:
    .ascii "?DUP ( n -- n n | 0 ) dup if non-zero"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XQDUP:
    .quad nm_XQDUP, hl_XQDUP
    .quad 0
    .quad XQDUP, XQDUP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XQDUP
    .text
    .p2align 2
XQDUP:
    cbz x20, XQDUP_END
    str x20, [x22, #-8]!
XQDUP_END:
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
nm_XROT:
    .ascii "ROT"
    .byte 0
hl_XROT:
    .ascii "ROT ( a b c -- b c a ) rotate top three"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XROT:
    .quad nm_XROT, hl_XROT
    .quad 0
    .quad XROT, XROT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XROT
    .text
    .p2align 2
XROT:
    ldr x0, [x22]
    ldr x1, [x22, #8]
    str x0, [x22, #8]
    str x20, [x22]
    mov x20, x1
XROT_END:
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
nm_XNROT:
    .ascii "-ROT"
    .byte 0
hl_XNROT:
    .ascii "-ROT ( a b c -- c a b ) reverse-rotate top three"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNROT:
    .quad nm_XNROT, hl_XNROT
    .quad 0
    .quad XNROT, XNROT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNROT
    .text
    .p2align 2
XNROT:
    ldr x0, [x22]
    ldr x1, [x22, #8]
    str x20, [x22, #8]
    str x1, [x22]
    mov x20, x0
XNROT_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .global XROLL
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XROLL:
    .ascii "ROLL"
    .byte 0
hl_XROLL:
    .ascii "ROLL ( xu ... x0 u -- xu ) move the uth cell to TOS"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XROLL:
    .quad nm_XROLL, hl_XROLL
    .quad 0
    .quad XROLL, XROLL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XROLL
    .text
    .p2align 2
XROLL:
    mov x1, x20
    ldr x20, [x22], #8
    cbz x1, XROLL_END
    sub x2, x1, #1
    lsl x2, x2, #3
    ldr x3, [x22, x2]
    mov x0, x20
    mov x4, x2
_roll_shift:
    cbz x4, _roll_put
    sub x5, x4, #8
    ldr x6, [x22, x5]
    str x6, [x22, x4]
    mov x4, x5
    b _roll_shift
_roll_put:
    str x0, [x22]
    mov x20, x3
XROLL_END:
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
nm_XNIP:
    .ascii "NIP"
    .byte 0
hl_XNIP:
    .ascii "NIP ( x1 x2 -- x2 ) drop the cell under TOS"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNIP:
    .quad nm_XNIP, hl_XNIP
    .quad 0
    .quad XNIP, XNIP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNIP
    .text
    .p2align 2
XNIP:
    ldr x0, [x22], #8
XNIP_END:
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
nm_XTOR:
    .ascii ">R"
    .byte 0
hl_XTOR:
    .ascii ">R ( n -- ) ( R: -- n ) to return stack"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTOR:
    .quad nm_XTOR, hl_XTOR
    .quad 0
    .quad XTOR, XTOR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTOR
    .text
    .p2align 2
XTOR:
    str x20, [x23, #-8]!
    ldr x20, [x22], #8
XTOR_END:
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
nm_XRTO:
    .ascii "R>"
    .byte 0
hl_XRTO:
    .ascii "R> ( -- n ) ( R: n -- ) from return stack"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRTO:
    .quad nm_XRTO, hl_XRTO
    .quad 0
    .quad XRTO, XRTO_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRTO
    .text
    .p2align 2
XRTO:
    str x20, [x22, #-8]!
    ldr x20, [x23], #8
XRTO_END:
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
nm_XRFETCH:
    .ascii "R@"
    .byte 0
hl_XRFETCH:
    .ascii "R@ ( -- n ) ( R: n -- n ) copy top of return stack"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRFETCH:
    .quad nm_XRFETCH, hl_XRFETCH
    .quad 0
    .quad XRFETCH, XRFETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRFETCH
    .text
    .p2align 2
XRFETCH:
    str x20, [x22, #-8]!
    ldr x20, [x23]
XRFETCH_END:
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
nm_XONEPLUS:
    .ascii "1+"
    .byte 0
hl_XONEPLUS:
    .ascii "1+ ( n -- n+1 ) increment"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XONEPLUS:
    .quad nm_XONEPLUS, hl_XONEPLUS
    .quad 0
    .quad XONEPLUS, XONEPLUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XONEPLUS
    .text
    .p2align 2
XONEPLUS:
    add x20, x20, #1
XONEPLUS_END:
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
nm_XAND:
    .ascii "AND"
    .byte 0
hl_XAND:
    .ascii "AND ( n1 n2 -- n ) bitwise and"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAND:
    .quad nm_XAND, hl_XAND
    .quad 0
    .quad XAND, XAND_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAND
    .text
    .p2align 2
XAND:
    ldr x0, [x22], #8
    and x20, x20, x0
XAND_END:
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
nm_XORR:
    .ascii "OR"
    .byte 0
hl_XORR:
    .ascii "OR ( n1 n2 -- n ) bitwise or"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XORR:
    .quad nm_XORR, hl_XORR
    .quad 0
    .quad XORR, XORR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XORR
    .text
    .p2align 2
XORR:
    ldr x0, [x22], #8
    orr x20, x20, x0
XORR_END:
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
nm_XINVERT:
    .ascii "INVERT"
    .byte 0
hl_XINVERT:
    .ascii "INVERT ( n -- ~n ) bitwise invert"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XINVERT:
    .quad nm_XINVERT, hl_XINVERT
    .quad 0
    .quad XINVERT, XINVERT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XINVERT
    .text
    .p2align 2
XINVERT:
    mvn x20, x20
XINVERT_END:
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
nm_XRSHIFT:
    .ascii "RSHIFT"
    .byte 0
hl_XRSHIFT:
    .ascii "RSHIFT ( n bits -- n ) logical right shift"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRSHIFT:
    .quad nm_XRSHIFT, hl_XRSHIFT
    .quad 0
    .quad XRSHIFT, XRSHIFT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRSHIFT
    .text
    .p2align 2
XRSHIFT:
    ldr x0, [x22], #8
    lsr x20, x0, x20
XRSHIFT_END:
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
nm_XEQUAL:
    .ascii "="
    .byte 0
hl_XEQUAL:
    .ascii "= ( n1 n2 -- flag ) equal"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XEQUAL:
    .quad nm_XEQUAL, hl_XEQUAL
    .quad 0
    .quad XEQUAL, XEQUAL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XEQUAL
    .text
    .p2align 2
XEQUAL:
    ldr x0, [x22], #8
    cmp x0, x20
    csetm x20, eq
XEQUAL_END:
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
nm_XLESS:
    .ascii "<"
    .byte 0
hl_XLESS:
    .ascii "< ( n1 n2 -- flag ) less than"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLESS:
    .quad nm_XLESS, hl_XLESS
    .quad 0
    .quad XLESS, XLESS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLESS
    .text
    .p2align 2
XLESS:
    ldr x0, [x22], #8
    cmp x0, x20
    csetm x20, lt
XLESS_END:
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
nm_XGREATER:
    .ascii ">"
    .byte 0
hl_XGREATER:
    .ascii "> ( n1 n2 -- flag ) greater than"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XGREATER:
    .quad nm_XGREATER, hl_XGREATER
    .quad 0
    .quad XGREATER, XGREATER_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XGREATER
    .text
    .p2align 2
XGREATER:
    ldr x0, [x22], #8
    cmp x0, x20
    csetm x20, gt
XGREATER_END:
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
nm_XZEQUAL:
    .ascii "0="
    .byte 0
hl_XZEQUAL:
    .ascii "0= ( n -- flag ) zero?"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XZEQUAL:
    .quad nm_XZEQUAL, hl_XZEQUAL
    .quad 0
    .quad XZEQUAL, XZEQUAL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XZEQUAL
    .text
    .p2align 2
XZEQUAL:
    cmp x20, #0
    csetm x20, eq
XZEQUAL_END:
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
nm_XFETCH:
    .ascii "@"
    .byte 0
hl_XFETCH:
    .ascii "@ ( addr -- n ) fetch cell"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFETCH:
    .quad nm_XFETCH, hl_XFETCH
    .quad 0
    .quad XFETCH, XFETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFETCH
    .text
    .p2align 2
XFETCH:
    ldr x20, [x20]
XFETCH_END:
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
nm_XSTORE:
    .ascii "!"
    .byte 0
hl_XSTORE:
    .ascii "! ( n addr -- ) store cell"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSTORE:
    .quad nm_XSTORE, hl_XSTORE
    .quad 0
    .quad XSTORE, XSTORE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSTORE
    .text
    .p2align 2
XSTORE:
    ldr x0, [x22], #8
    str x0, [x20]
    ldr x20, [x22], #8
XSTORE_END:
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
nm_XCFETCH:
    .ascii "C@"
    .byte 0
hl_XCFETCH:
    .ascii "C@ ( addr -- byte ) fetch byte"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCFETCH:
    .quad nm_XCFETCH, hl_XCFETCH
    .quad 0
    .quad XCFETCH, XCFETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCFETCH
    .text
    .p2align 2
XCFETCH:
    ldrb w20, [x20]
XCFETCH_END:
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
nm_XCSTORE:
    .ascii "C!"
    .byte 0
hl_XCSTORE:
    .ascii "C! ( byte addr -- ) store byte"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCSTORE:
    .quad nm_XCSTORE, hl_XCSTORE
    .quad 0
    .quad XCSTORE, XCSTORE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCSTORE
    .text
    .p2align 2
XCSTORE:
    ldr x0, [x22], #8
    strb w0, [x20]
    ldr x20, [x22], #8
XCSTORE_END:
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
nm_XBL:
    .ascii "BL"
    .byte 0
hl_XBL:
    .ascii "BL ( -- c ) ASCII blank"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBL:
    .quad nm_XBL, hl_XBL
    .quad 0
    .quad XBL, XBL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBL
    .text
    .p2align 2
XBL:
    mov x0, #32
    str x20, [x22, #-8]!
    mov x20, x0
XBL_END:
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
nm_XEMIT:
    .ascii "EMIT"
    .byte 0
hl_XEMIT:
    .ascii "EMIT ( c -- ) emit one character"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XEMIT:
    .quad nm_XEMIT, hl_XEMIT
    .quad 0
    .quad XEMIT, XEMIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XEMIT
    .text
    .p2align 2
XEMIT:
    mov x0, x20
    ldr x20, [x22], #8
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _putchar
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XEMIT_END:
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
nm_XTYPE:
    .ascii "TYPE"
    .byte 0
hl_XTYPE:
    .ascii "TYPE ( addr len -- ) type string"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTYPE:
    .quad nm_XTYPE, hl_XTYPE
    .quad 0
    .quad XTYPE, XTYPE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTYPE
    .text
    .p2align 2
XTYPE:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    cbz x1, XTYPE_END
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x0, x1, [sp, #48]
    ldp x0, x1, [sp, #48]
    bl emit_str
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
XTYPE_END:
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
nm_XXCHAR_EMIT:
    .ascii "XEMIT"
    .byte 0
hl_XXCHAR_EMIT:
    .ascii "XEMIT ( xchar -- ) emit UTF-8 xchar to console"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XXCHAR_EMIT:
    .quad nm_XXCHAR_EMIT, hl_XXCHAR_EMIT
    .quad 0
    .quad XXCHAR_EMIT, XXCHAR_EMIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XXCHAR_EMIT
    .text
    .p2align 2
XXCHAR_EMIT:
    mov x1, x20
    ldr x20, [x22], #8
    movz x2, #0xFFFF
    movk x2, #0x10, lsl #16
    cmp x1, x2
    csel x1, x2, x1, hi
    adrp x0, :got:xchar_emit_buf
    ldr x0, [x0, :got_lo12:xchar_emit_buf]
    mov x3, x0
    cmp x1, #0x7F
    b.ls _xe_1
    cmp x1, #0x7FF
    b.ls _xe_2
    movz x4, #0xFFFF
    cmp x1, x4
    b.ls _xe_3
    lsr x4, x1, #18
    orr w4, w4, #0xF0
    strb w4, [x0], #1
    lsr x4, x1, #12
    and w4, w4, #0x3F
    orr w4, w4, #0x80
    strb w4, [x0], #1
    lsr x4, x1, #6
    and w4, w4, #0x3F
    orr w4, w4, #0x80
    strb w4, [x0], #1
    and w4, w1, #0x3F
    orr w4, w4, #0x80
    strb w4, [x0], #1
    b _xe_9
_xe_3:
    lsr x4, x1, #12
    orr w4, w4, #0xE0
    strb w4, [x0], #1
    lsr x4, x1, #6
    and w4, w4, #0x3F
    orr w4, w4, #0x80
    strb w4, [x0], #1
    and w4, w1, #0x3F
    orr w4, w4, #0x80
    strb w4, [x0], #1
    b _xe_9
_xe_2:
    lsr x4, x1, #6
    orr w4, w4, #0xC0
    strb w4, [x0], #1
    and w4, w1, #0x3F
    orr w4, w4, #0x80
    strb w4, [x0], #1
    b _xe_9
_xe_1:
    strb w1, [x0], #1
_xe_9:
    sub x1, x0, x3
    mov x0, x3
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl emit_str
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XXCHAR_EMIT_END:
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
nm_XDP:
    .ascii "DP"
    .byte 0
hl_XDP:
    .ascii "DP ( -- addr ) dictionary pointer variable"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDP:
    .quad nm_XDP, hl_XDP
    .quad 0
    .quad XDP, XDP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDP
    .text
    .p2align 2
XDP:
    adrp x0, :got:here_ptr
    ldr x0, [x0, :got_lo12:here_ptr]
    str x20, [x22, #-8]!
    mov x20, x0
XDP_END:
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
nm_XHERE:
    .ascii "HERE"
    .byte 0
hl_XHERE:
    .ascii "HERE ( -- addr ) current dictionary pointer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XHERE:
    .quad nm_XHERE, hl_XHERE
    .quad 0
    .quad XHERE, XHERE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XHERE
    .text
    .p2align 2
XHERE:
    adrp x0, :got:here_ptr
    ldr x0, [x0, :got_lo12:here_ptr]
    ldr x0, [x0]
    str x20, [x22, #-8]!
    mov x20, x0
XHERE_END:
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
nm_XALLOT:
    .ascii "ALLOT"
    .byte 0
hl_XALLOT:
    .ascii "ALLOT ( n -- ) allocate n bytes in dictionary"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XALLOT:
    .quad nm_XALLOT, hl_XALLOT
    .quad 0
    .quad XALLOT, XALLOT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XALLOT
    .text
    .p2align 2
XALLOT:
    mov x0, x20
    ldr x20, [x22], #8
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    ldr x2, [x1]
    add x3, x2, x0
    adrp x4, :got:user_dict_area
    ldr x4, [x4, :got_lo12:user_dict_area]
    cmp x3, x4
    b.lo _allot_fail
    adrp x5, :got:user_dict_size_cell
    ldr x5, [x5, :got_lo12:user_dict_size_cell]
    ldr x5, [x5]
    add x5, x4, x5
    cmp x3, x5
    b.hi _allot_fail
    str x3, [x1]
    b XALLOT_END
_allot_fail:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x0, :got:msg_allot
    ldr x0, [x0, :got_lo12:msg_allot]
    bl emit_cstr
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    b _quit_exit
XALLOT_END:
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
nm_XCOMMA:
    .byte 44
    .byte 0
hl_XCOMMA:
    .byte 44
    .ascii "( n -- ) compile a cell"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCOMMA:
    .quad nm_XCOMMA, hl_XCOMMA
    .quad 0
    .quad XCOMMA, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCOMMA
    .text
    .p2align 2
XCOMMA:
    mov x0, x20
    ldr x20, [x22], #8
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _compile_cell
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
nm_XIMMEDIATE:
    .ascii "IMMEDIATE"
    .byte 0
hl_XIMMEDIATE:
    .ascii "IMMEDIATE ( -- ) mark latest word as immediate"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XIMMEDIATE:
    .quad nm_XIMMEDIATE, hl_XIMMEDIATE
    .quad 0
    .quad XIMMEDIATE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XIMMEDIATE
    .text
    .p2align 2
XIMMEDIATE:
    adrp x0, :got:last_cfa
    ldr x0, [x0, :got_lo12:last_cfa]
    ldr x0, [x0]
    cbz x0, _imm_done
    ldr x1, [x0, #-8]
    mov x2, #1
    lsl x2, x2, #63
    orr x1, x1, x2
    str x1, [x0, #-8]
_imm_done:
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
nm_XSETDOC:
    .ascii "SETDOC"
    .byte 0
hl_XSETDOC:
    .ascii "SETDOC ( c-addr u -- ) pending help for next defining word"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSETDOC:
    .quad nm_XSETDOC, hl_XSETDOC
    .quad 0
    .quad XSETDOC, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSETDOC
    .text
    .p2align 2
XSETDOC:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
_setdoc_skip:
    cbz x1, _setdoc_store
    ldrb w2, [x0]
    cmp w2, #32
    b.eq _setdoc_adv
    cmp w2, #9
    b.ne _setdoc_store
_setdoc_adv:
    add x0, x0, #1
    sub x1, x1, #1
    b _setdoc_skip
_setdoc_store:
    adrp x2, :got:pending_help_addr
    ldr x2, [x2, :got_lo12:pending_help_addr]
    str x0, [x2]
    adrp x2, :got:pending_help_len
    ldr x2, [x2, :got_lo12:pending_help_len]
    str x1, [x2]
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
nm_XCREATE:
    .ascii "CREATE"
    .byte 0
hl_XCREATE:
    .ascii "CREATE ( 'name' -- ) create a word that pushes its data field"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCREATE:
    .quad nm_XCREATE, hl_XCREATE
    .quad 0
    .quad XCREATE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCREATE
    .text
    .p2align 2
XCREATE:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    bl _next_word
    cbz x1, _create_fail
    stp x0, x1, [sp, #48]
    bl _take_pending_help
    ldp x0, x1, [sp, #48]
    adrp x4, :got:DOVAR
    ldr x4, [x4, :got_lo12:DOVAR]
    mov x5, #0
    bl _header_build
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    ldr x0, [x1]
    str xzr, [x0], #8
    str x0, [x1]
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
_create_fail:
    adrp x0, :got:msg_huh_k1
    ldr x0, [x0, :got_lo12:msg_huh_k1]
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
nm_XSTATE:
    .ascii "STATE"
    .byte 0
hl_XSTATE:
    .ascii "STATE ( -- addr ) compilation state variable"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSTATE:
    .quad nm_XSTATE, hl_XSTATE
    .quad 0
    .quad XSTATE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSTATE
    .text
    .p2align 2
XSTATE:
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XBASE:
    .ascii "BASE"
    .byte 0
hl_XBASE:
    .ascii "BASE ( -- addr ) current numeric base variable"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBASE:
    .quad nm_XBASE, hl_XBASE
    .quad 0
    .quad XBASE, XBASE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBASE
    .text
    .p2align 2
XBASE:
    adrp x0, :got:base_var
    ldr x0, [x0, :got_lo12:base_var]
    str x20, [x22, #-8]!
    mov x20, x0
XBASE_END:
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
nm_XLAST:
    .ascii "LAST"
    .byte 0
hl_XLAST:
    .ascii "LAST ( -- xt ) CFA of most recently defined word"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLAST:
    .quad nm_XLAST, hl_XLAST
    .quad 0
    .quad XLAST, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLAST
    .text
    .p2align 2
XLAST:
    adrp x0, :got:last_cfa
    ldr x0, [x0, :got_lo12:last_cfa]
    ldr x0, [x0]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XREGWID:
    .ascii "(REGISTER-WID)"
    .byte 0
hl_XREGWID:
    .ascii "(REGISTER-WID) ( wid -- ) register a wordlist"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XREGWID:
    .quad nm_XREGWID, hl_XREGWID
    .quad 0
    .quad XREGWID, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XREGWID
    .text
    .p2align 2
XREGWID:
    mov x0, x20
    ldr x20, [x22], #8
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _wordlist_register
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
_wordlist_register:
    adrp x1, :got:wordlist_reg_n
    ldr x1, [x1, :got_lo12:wordlist_reg_n]
    ldr x2, [x1]
    adrp x3, :got:wordlist_reg
    ldr x3, [x3, :got_lo12:wordlist_reg]
    mov x4, #0
_wreg_scan:
    cmp x4, x2
    b.hs _wreg_add
    ldr x5, [x3, x4, lsl #3]
    cmp x5, x0
    b.eq _wreg_done
    add x4, x4, #1
    b _wreg_scan
_wreg_add:
    cmp x2, #32
    b.hs _wreg_done
    str x0, [x3, x2, lsl #3]
    add x2, x2, #1
    str x2, [x1]
_wreg_done:
    ret
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XGET_ORDER:
    .ascii "GET-ORDER"
    .byte 0
hl_XGET_ORDER:
    .ascii "GET-ORDER ( -- widn ... wid1 n ) copy search order"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XGET_ORDER:
    .quad nm_XGET_ORDER, hl_XGET_ORDER
    .quad 0
    .quad XGET_ORDER, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XGET_ORDER
    .text
    .p2align 2
XGET_ORDER:
    adrp x0, :got:search_order_n
    ldr x0, [x0, :got_lo12:search_order_n]
    ldr x1, [x0]
    adrp x2, :got:search_order
    ldr x2, [x2, :got_lo12:search_order]
    mov x3, x1
_get_ord_loop:
    cbz x3, _get_ord_n
    sub x3, x3, #1
    ldr x4, [x2, x3, lsl #3]
    str x20, [x22, #-8]!
    mov x20, x4
    b _get_ord_loop
_get_ord_n:
    str x20, [x22, #-8]!
    mov x20, x1
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
nm_XSET_ORDER:
    .ascii "SET-ORDER"
    .byte 0
hl_XSET_ORDER:
    .ascii "SET-ORDER ( widn ... wid1 n -- ) replace search order"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSET_ORDER:
    .quad nm_XSET_ORDER, hl_XSET_ORDER
    .quad 0
    .quad XSET_ORDER, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSET_ORDER
    .text
    .p2align 2
XSET_ORDER:
    mov x1, x20
    ldr x20, [x22], #8
    cmn x1, #1
    b.eq XONLY
    cmp x1, #0
    b.lt _set_ord_bad
    cmp x1, #8
    b.hi _set_ord_bad
    adrp x0, :got:search_order_n
    ldr x0, [x0, :got_lo12:search_order_n]
    str x1, [x0]
    adrp x2, :got:search_order
    ldr x2, [x2, :got_lo12:search_order]
    mov x3, #0
_set_ord_loop:
    cmp x3, x1
    b.hs _set_ord_bad
    str x20, [x2, x3, lsl #3]
    ldr x20, [x22], #8
    add x3, x3, #1
    b _set_ord_loop
_set_ord_bad:
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
nm_XPUSH_ORDER:
    .ascii "PUSH-ORDER"
    .byte 0
hl_XPUSH_ORDER:
    .ascii "PUSH-ORDER ( wid -- ) prepend wid to search order"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPUSH_ORDER:
    .quad nm_XPUSH_ORDER, hl_XPUSH_ORDER
    .quad 0
    .quad XPUSH_ORDER, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPUSH_ORDER
    .text
    .p2align 2
XPUSH_ORDER:
    adrp x0, :got:search_order_n
    ldr x0, [x0, :got_lo12:search_order_n]
    ldr x1, [x0]
    cmp x1, #8
    b.hs _push_ord_drop
    adrp x2, :got:search_order
    ldr x2, [x2, :got_lo12:search_order]
    mov x3, x1
_push_ord_shift:
    cbz x3, _push_ord_store
    sub x3, x3, #1
    ldr x4, [x2, x3, lsl #3]
    add x5, x3, #1
    str x4, [x2, x5, lsl #3]
    b _push_ord_shift
_push_ord_store:
    str x20, [x2]
    add x1, x1, #1
    str x1, [x0]
_push_ord_drop:
    ldr x20, [x22], #8
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
nm_XDEFINITIONS:
    .ascii "DEFINITIONS"
    .byte 0
hl_XDEFINITIONS:
    .ascii "DEFINITIONS ( -- ) CURRENT = first in search order"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDEFINITIONS:
    .quad nm_XDEFINITIONS, hl_XDEFINITIONS
    .quad 0
    .quad XDEFINITIONS, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDEFINITIONS
    .text
    .p2align 2
XDEFINITIONS:
    adrp x0, :got:search_order_n
    ldr x0, [x0, :got_lo12:search_order_n]
    ldr x0, [x0]
    cbz x0, _def_done
    adrp x1, :got:search_order
    ldr x1, [x1, :got_lo12:search_order]
    ldr x1, [x1]
    adrp x0, :got:current_var
    ldr x0, [x0, :got_lo12:current_var]
    str x1, [x0]
_def_done:
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
nm_XONLY:
    .ascii "ONLY"
    .byte 0
hl_XONLY:
    .ascii "ONLY ( -- ) search order = FORTH only"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XONLY:
    .quad nm_XONLY, hl_XONLY
    .quad 0
    .quad XONLY, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XONLY
    .text
    .p2align 2
XONLY:
    adrp x0, :got:latest_var
    ldr x0, [x0, :got_lo12:latest_var]
    adrp x1, :got:search_order
    ldr x1, [x1, :got_lo12:search_order]
    str x0, [x1]
    mov x0, #1
    adrp x1, :got:search_order_n
    ldr x1, [x1, :got_lo12:search_order_n]
    str x0, [x1]
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
nm_XFORTH:
    .ascii "FORTH"
    .byte 0
hl_XFORTH:
    .ascii "FORTH ( -- ) set first search-order entry to FORTH"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFORTH:
    .quad nm_XFORTH, hl_XFORTH
    .quad 0
    .quad XFORTH, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFORTH
    .text
    .p2align 2
XFORTH:
    adrp x0, :got:latest_var
    ldr x0, [x0, :got_lo12:latest_var]
    adrp x1, :got:search_order
    ldr x1, [x1, :got_lo12:search_order]
    str x0, [x1]
    adrp x1, :got:search_order_n
    ldr x1, [x1, :got_lo12:search_order_n]
    ldr x2, [x1]
    cbnz x2, _forth_done
    mov x2, #1
    str x2, [x1]
_forth_done:
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
nm_XCURRENT:
    .ascii "CURRENT"
    .byte 0
hl_XCURRENT:
    .ascii "CURRENT ( -- addr ) compilation wordlist variable"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCURRENT:
    .quad nm_XCURRENT, hl_XCURRENT
    .quad 0
    .quad XCURRENT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCURRENT
    .text
    .p2align 2
XCURRENT:
    adrp x0, :got:current_var
    ldr x0, [x0, :got_lo12:current_var]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XGET_CURRENT:
    .ascii "GET-CURRENT"
    .byte 0
hl_XGET_CURRENT:
    .ascii "GET-CURRENT ( -- wid ) wid of the compilation wordlist"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XGET_CURRENT:
    .quad nm_XGET_CURRENT, hl_XGET_CURRENT
    .quad 0
    .quad XGET_CURRENT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XGET_CURRENT
    .text
    .p2align 2
XGET_CURRENT:
    adrp x0, :got:current_var
    ldr x0, [x0, :got_lo12:current_var]
    ldr x0, [x0]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XSET_CURRENT:
    .ascii "SET-CURRENT"
    .byte 0
hl_XSET_CURRENT:
    .ascii "SET-CURRENT ( wid -- ) set the compilation wordlist"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSET_CURRENT:
    .quad nm_XSET_CURRENT, hl_XSET_CURRENT
    .quad 0
    .quad XSET_CURRENT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSET_CURRENT
    .text
    .p2align 2
XSET_CURRENT:
    adrp x0, :got:current_var
    ldr x0, [x0, :got_lo12:current_var]
    str x20, [x0]
    ldr x20, [x22], #8
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
nm_XWORDLIST:
    .ascii "WORDLIST"
    .byte 0
hl_XWORDLIST:
    .ascii "WORDLIST ( -- wid ) create empty word list"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XWORDLIST:
    .quad nm_XWORDLIST, hl_XWORDLIST
    .quad 0
    .quad XWORDLIST, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XWORDLIST
    .text
    .p2align 2
XWORDLIST:
    adrp x0, :got:here_ptr
    ldr x0, [x0, :got_lo12:here_ptr]
    ldr x1, [x0]
    add x1, x1, #7
    bic x1, x1, #7
    add x3, x1, #128
    adrp x4, :got:user_dict_area
    ldr x4, [x4, :got_lo12:user_dict_area]
    cmp x3, x4
    b.lo _allot_fail
    adrp x5, :got:user_dict_size_cell
    ldr x5, [x5, :got_lo12:user_dict_size_cell]
    ldr x5, [x5]
    add x5, x4, x5
    cmp x3, x5
    b.hi _allot_fail
    mov x2, x1
    mov x5, #16
_wl_zero:
    str xzr, [x1], #8
    subs x5, x5, #1
    b.ne _wl_zero
    str x1, [x0]
    mov x0, x2
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _wordlist_register
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XPREVIOUS:
    .ascii "PREVIOUS"
    .byte 0
hl_XPREVIOUS:
    .ascii "PREVIOUS ( -- ) drop first search-order entry"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPREVIOUS:
    .quad nm_XPREVIOUS, hl_XPREVIOUS
    .quad 0
    .quad XPREVIOUS, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPREVIOUS
    .text
    .p2align 2
XPREVIOUS:
    adrp x0, :got:search_order_n
    ldr x0, [x0, :got_lo12:search_order_n]
    ldr x1, [x0]
    cmp x1, #1
    b.ls _prev_done
    adrp x2, :got:search_order
    ldr x2, [x2, :got_lo12:search_order]
    mov x3, #0
_prev_shift:
    add x4, x3, #1
    cmp x4, x1
    b.hs _prev_store
    ldr x5, [x2, x4, lsl #3]
    str x5, [x2, x3, lsl #3]
    add x3, x3, #1
    b _prev_shift
_prev_store:
    sub x1, x1, #1
    str x1, [x0]
_prev_done:
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
nm_XORDER:
    .ascii "ORDER"
    .byte 0
hl_XORDER:
    .ascii "ORDER ( -- ) print search order and CURRENT"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XORDER:
    .quad nm_XORDER, hl_XORDER
    .quad 0
    .quad XORDER, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XORDER
    .text
    .p2align 2
XORDER:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    adrp x0, :got:str_search_order
    ldr x0, [x0, :got_lo12:str_search_order]
    bl emit_cstr
    adrp x0, :got:search_order_n
    ldr x0, [x0, :got_lo12:search_order_n]
    ldr x19, [x0]
    adrp x20, :got:search_order
    ldr x20, [x20, :got_lo12:search_order]
    mov x21, #0
_ord_loop:
    cmp x21, x19
    b.hs _ord_nl
    ldr x0, [x20, x21, lsl #3]
    bl _print_wid_name
    mov x0, #32
    bl _putchar
    add x21, x21, #1
    b _ord_loop
_ord_nl:
    mov x0, #10
    bl _putchar
    adrp x0, :got:str_comp_wl
    ldr x0, [x0, :got_lo12:str_comp_wl]
    bl emit_cstr
    adrp x0, :got:current_var
    ldr x0, [x0, :got_lo12:current_var]
    ldr x0, [x0]
    bl _print_wid_name
    mov x0, #10
    bl _putchar
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
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
nm_XCELL:
    .ascii "CELL"
    .byte 0
hl_XCELL:
    .ascii "CELL ( -- n ) address unit size in bytes"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCELL:
    .quad nm_XCELL, hl_XCELL
    .quad 0
    .quad XCELL, XCELL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCELL
    .text
    .p2align 2
XCELL:
    mov x0, #8
    str x20, [x22, #-8]!
    mov x20, x0
XCELL_END:
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
nm_XCELLS:
    .ascii "CELLS"
    .byte 0
hl_XCELLS:
    .ascii "CELLS ( n -- n ) cells to address units"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCELLS:
    .quad nm_XCELLS, hl_XCELLS
    .quad 0
    .quad XCELLS, XCELLS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCELLS
    .text
    .p2align 2
XCELLS:
    lsl x20, x20, #3
XCELLS_END:
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
nm_XDEPTH:
    .ascii "DEPTH"
    .byte 0
hl_XDEPTH:
    .ascii "DEPTH ( -- +n ) data stack depth in cells"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDEPTH:
    .quad nm_XDEPTH, hl_XDEPTH
    .quad 0
    .quad XDEPTH, XDEPTH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDEPTH
    .text
    .p2align 2
XDEPTH:
    adrp x1, :got:data_stack
    ldr x1, [x1, :got_lo12:data_stack]
    add x0, x1, #1, lsl #12
    cmp x22, x0
    b.hi _depth_fix
    cmp x22, x1
    b.lo _depth_fix
    b _depth_n
_depth_fix:
    mov x22, x0
    mov x20, #0
_depth_n:
    sub x0, x0, x22
    lsr x0, x0, #3
    str x20, [x22, #-8]!
    mov x20, x0
XDEPTH_END:
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
nm_XCLEARSTACK:
    .ascii "CLEARSTACK"
    .byte 0
hl_XCLEARSTACK:
    .ascii "CLEARSTACK ( -- ) empty the data stack"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCLEARSTACK:
    .quad nm_XCLEARSTACK, hl_XCLEARSTACK
    .quad 0
    .quad XCLEARSTACK, XCLEARSTACK_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCLEARSTACK
    .text
    .p2align 2
XCLEARSTACK:
    adrp x22, :got:data_stack
    ldr x22, [x22, :got_lo12:data_stack]
    add x22, x22, #1, lsl #12
    mov x20, #0
XCLEARSTACK_END:
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
nm_XSP0:
    .ascii "SP0"
    .byte 0
hl_XSP0:
    .ascii "SP0 ( -- addr ) empty data-stack pointer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSP0:
    .quad nm_XSP0, hl_XSP0
    .quad 0
    .quad XSP0, XSP0_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSP0
    .text
    .p2align 2
XSP0:
    adrp x1, :got:data_stack
    ldr x1, [x1, :got_lo12:data_stack]
    add x0, x1, #1, lsl #12
    cmp x22, x0
    b.hi _sp0_fix
    cmp x22, x1
    b.lo _sp0_fix
    b _sp0_push
_sp0_fix:
    mov x22, x0
    mov x20, #0
_sp0_push:
    str x20, [x22, #-8]!
    mov x20, x0
XSP0_END:
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
nm_XSPFETCH:
    .ascii "SP@"
    .byte 0
hl_XSPFETCH:
    .ascii "SP@ ( -- addr ) current data-stack pointer under TOS"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSPFETCH:
    .quad nm_XSPFETCH, hl_XSPFETCH
    .quad 0
    .quad XSPFETCH, XSPFETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSPFETCH
    .text
    .p2align 2
XSPFETCH:
    mov x0, x22
    str x20, [x22, #-8]!
    mov x20, x0
XSPFETCH_END:
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
nm_XSPSTORE:
    .ascii "SP!"
    .byte 0
hl_XSPSTORE:
    .ascii "SP! ( addr -- ) set the data-stack pointer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSPSTORE:
    .quad nm_XSPSTORE, hl_XSPSTORE
    .quad 0
    .quad XSPSTORE, XSPSTORE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSPSTORE
    .text
    .p2align 2
XSPSTORE:
    mov x22, x20
    mov x20, #0
XSPSTORE_END:
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
nm_XDICT_THREADS:
    .ascii "DICT-THREADS"
    .byte 0
hl_XDICT_THREADS:
    .ascii "DICT-THREADS ( -- n ) hash threads per wordlist"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDICT_THREADS:
    .quad nm_XDICT_THREADS, hl_XDICT_THREADS
    .quad 0
    .quad XDICT_THREADS, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDICT_THREADS
    .text
    .p2align 2
XDICT_THREADS:
    mov x0, #16
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XBRACKET_TICK:
    .ascii "[']"
    .byte 0
hl_XBRACKET_TICK:
    .ascii "['] ( -- xt ) compile xt of next name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBRACKET_TICK:
    .quad nm_XBRACKET_TICK, hl_XBRACKET_TICK
    .word 0, 2147483648
    .quad XBRACKET_TICK, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBRACKET_TICK
    .text
    .p2align 2
XBRACKET_TICK:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    bl _next_word
    cbz x1, _btick_fail
    stp x0, x1, [sp, #48]
    bl _find_word
    cbz x0, _btick_fail
    str x0, [sp, #64]
    adrp x1, :got:state_var
    ldr x1, [x1, :got_lo12:state_var]
    ldr x1, [x1]
    cbz x1, _btick_interp
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    ldr x0, [sp, #64]
    bl _compile_cell
    b _btick_leave
_btick_interp:
    ldr x0, [sp, #64]
    str x20, [x22, #-8]!
    mov x20, x0
_btick_leave:
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
_btick_fail:
    adrp x0, :got:msg_huh_k1
    ldr x0, [x0, :got_lo12:msg_huh_k1]
    bl emit_cstr
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
    b _quit_exit
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XLIT_ADDR:
    .ascii "LIT-ADDR"
    .byte 0
hl_XLIT_ADDR:
    .ascii "LIT-ADDR ( -- xt ) xt of LIT"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLIT_ADDR:
    .quad nm_XLIT_ADDR, hl_XLIT_ADDR
    .quad 0
    .quad XLIT_ADDR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLIT_ADDR
    .text
    .p2align 2
XLIT_ADDR:
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_X0BRANCH_ADDR:
    .ascii "0BRANCH-ADDR"
    .byte 0
hl_X0BRANCH_ADDR:
    .ascii "0BRANCH-ADDR ( -- xt ) xt of 0BRANCH"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_X0BRANCH_ADDR:
    .quad nm_X0BRANCH_ADDR, hl_X0BRANCH_ADDR
    .quad 0
    .quad X0BRANCH_ADDR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_X0BRANCH_ADDR
    .text
    .p2align 2
X0BRANCH_ADDR:
    adrp x0, :got:cfa_0branch
    ldr x0, [x0, :got_lo12:cfa_0branch]
    ldr x0, [x0]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XBRANCH_ADDR:
    .ascii "BRANCH-ADDR"
    .byte 0
hl_XBRANCH_ADDR:
    .ascii "BRANCH-ADDR ( -- xt ) xt of BRANCH"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBRANCH_ADDR:
    .quad nm_XBRANCH_ADDR, hl_XBRANCH_ADDR
    .quad 0
    .quad XBRANCH_ADDR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBRANCH_ADDR
    .text
    .p2align 2
XBRANCH_ADDR:
    adrp x0, :got:cfa_branch
    ldr x0, [x0, :got_lo12:cfa_branch]
    ldr x0, [x0]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XDOCOL_ADDR:
    .ascii "DOCOL-ADDR"
    .byte 0
hl_XDOCOL_ADDR:
    .ascii "DOCOL-ADDR ( -- addr ) address of DOCOL code"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOCOL_ADDR:
    .quad nm_XDOCOL_ADDR, hl_XDOCOL_ADDR
    .quad 0
    .quad XDOCOL_ADDR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOCOL_ADDR
    .text
    .p2align 2
XDOCOL_ADDR:
    adrp x0, :got:DOCOL
    ldr x0, [x0, :got_lo12:DOCOL]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XDOCON_ADDR:
    .ascii "DOCON-ADDR"
    .byte 0
hl_XDOCON_ADDR:
    .ascii "DOCON-ADDR ( -- addr ) address of DOCON code"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOCON_ADDR:
    .quad nm_XDOCON_ADDR, hl_XDOCON_ADDR
    .quad 0
    .quad XDOCON_ADDR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOCON_ADDR
    .text
    .p2align 2
XDOCON_ADDR:
    adrp x0, :got:DOCON
    ldr x0, [x0, :got_lo12:DOCON]
    str x20, [x22, #-8]!
    mov x20, x0
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
nm_XBranch:
    .ascii "BRANCH"
    .byte 0
hl_XBranch:
    .ascii "BRANCH ( -- ) unconditional branch"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBranch:
    .quad nm_XBranch, hl_XBranch
    .quad 0
    .quad XBranch, XBranch_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBranch
    .text
    .p2align 2
XBranch:
    ldr x0, [x19]
    add x19, x19, x0
XBranch_END:
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
nm_X0Branch:
    .ascii "0BRANCH"
    .byte 0
hl_X0Branch:
    .ascii "0BRANCH ( flag -- ) branch if zero"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_X0Branch:
    .quad nm_X0Branch, hl_X0Branch
    .quad 0
    .quad X0Branch, X0Branch_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_X0Branch
    .text
    .p2align 2
X0Branch:
    adrp x1, :got:data_stack
    ldr x1, [x1, :got_lo12:data_stack]
    add x1, x1, #1, lsl #12
    cbz x20, _0br_true
    cmp x22, x1
    b.hs _0br_empty_skip
    ldr x20, [x22], #8
    b _0br_skip
_0br_empty_skip:
    mov x20, #0
    mov x22, x1
_0br_skip:
    add x19, x19, #8
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_0br_true:
    cmp x22, x1
    b.hs _0br_empty_take
    ldr x20, [x22], #8
    b _0br_take
_0br_empty_take:
    mov x20, #0
    mov x22, x1
_0br_take:
    ldr x0, [x19]
    add x19, x19, x0
X0Branch_END:
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
nm_DOVAR:
    .ascii "(DOVAR)"
    .byte 0
hl_DOVAR:
    .ascii "(DOVAR) CREATE/VARIABLE runtime"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_DOVAR:
    .quad nm_DOVAR, hl_DOVAR
    .quad 0
    .quad DOVAR, DOVAR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_DOVAR
    .text
    .p2align 2
DOVAR:
    str x20, [x22, #-8]!
    add x20, x21, #16
DOVAR_END:
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
nm_DOCON:
    .ascii "(DOCON)"
    .byte 0
hl_DOCON:
    .ascii "(DOCON) CONSTANT runtime"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_DOCON:
    .quad nm_DOCON, hl_DOCON
    .quad 0
    .quad DOCON, DOCON_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_DOCON
    .text
    .p2align 2
DOCON:
    str x20, [x22, #-8]!
    ldr x20, [x21, #16]
DOCON_END:
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
nm_DODOES:
    .ascii "(DODOES)"
    .byte 0
hl_DODOES:
    .ascii "(DODOES) DOES> runtime"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_DODOES:
    .quad nm_DODOES, hl_DODOES
    .quad 0
    .quad DODOES, DODOES_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_DODOES
    .text
    .p2align 2
DODOES:
    str x19, [x23, #-8]!
    ldr x19, [x21, #8]
    add x0, x21, #16
    str x20, [x22, #-8]!
    mov x20, x0
DODOES_END:
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
nm_XDO_RT:
    .ascii "(DO)"
    .byte 0
hl_XDO_RT:
    .ascii "(DO) ( limit start -- ) runtime for DO"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDO_RT:
    .quad nm_XDO_RT, hl_XDO_RT
    .quad 0
    .quad XDO_RT, XDO_RT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDO_RT
    .text
    .p2align 2
XDO_RT:
    ldr x0, [x22], #8
    str x0, [x23, #-8]!
    str x20, [x23, #-8]!
    ldr x20, [x22], #8
XDO_RT_END:
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
nm_XQDO_RT:
    .ascii "(?DO)"
    .byte 0
hl_XQDO_RT:
    .ascii "(?DO) ( limit start -- ) runtime for ?DO"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XQDO_RT:
    .quad nm_XQDO_RT, hl_XQDO_RT
    .quad 0
    .quad XQDO_RT, XQDO_RT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XQDO_RT
    .text
    .p2align 2
XQDO_RT:
    ldr x0, [x22], #8
    cmp x20, x0
    b.eq _qdo_skip
    str x0, [x23, #-8]!
    str x20, [x23, #-8]!
    ldr x20, [x22], #8
    add x19, x19, #8
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_qdo_skip:
    ldr x20, [x22], #8
    ldr x0, [x19]
    add x19, x19, x0
XQDO_RT_END:
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
nm_XLOOP_RT:
    .ascii "(LOOP)"
    .byte 0
hl_XLOOP_RT:
    .ascii "(LOOP) ( -- ) runtime for LOOP"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOOP_RT:
    .quad nm_XLOOP_RT, hl_XLOOP_RT
    .quad 0
    .quad XLOOP_RT, XLOOP_RT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOOP_RT
    .text
    .p2align 2
XLOOP_RT:
    ldr x0, [x23], #8
    ldr x1, [x23], #8
    cmp x0, x1
    b.ge _loop_done
    add x0, x0, #1
    cmp x0, x1
    b.eq _loop_done
    str x1, [x23, #-8]!
    str x0, [x23, #-8]!
    ldr x2, [x19]
    add x19, x19, x2
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_loop_done:
    add x19, x19, #8
XLOOP_RT_END:
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
nm_XPLUSLOOP_RT:
    .ascii "(+LOOP)"
    .byte 0
hl_XPLUSLOOP_RT:
    .ascii "(+LOOP) ( n -- ) runtime for +LOOP"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPLUSLOOP_RT:
    .quad nm_XPLUSLOOP_RT, hl_XPLUSLOOP_RT
    .quad 0
    .quad XPLUSLOOP_RT, XPLUSLOOP_RT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPLUSLOOP_RT
    .text
    .p2align 2
XPLUSLOOP_RT:
    ldr x0, [x23], #8
    ldr x1, [x23], #8
    mov x2, x20
    ldr x20, [x22], #8
    sub x3, x0, x1
    add x4, x3, x2
    eor x5, x3, x4
    eor x6, x3, x2
    ands x5, x5, x6
    b.mi _pl_done
    add x0, x0, x2
    str x1, [x23, #-8]!
    str x0, [x23, #-8]!
    ldr x2, [x19]
    add x19, x19, x2
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_pl_done:
    add x19, x19, #8
XPLUSLOOP_RT_END:
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
nm_XDOES_RT:
    .ascii "(DOES>)"
    .byte 0
hl_XDOES_RT:
    .ascii "(DOES>) ( -- ) patch latest CREATE word and return"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOES_RT:
    .quad nm_XDOES_RT, hl_XDOES_RT
    .quad 0
    .quad XDOES_RT, XDOES_RT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOES_RT
    .text
    .p2align 2
XDOES_RT:
    adrp x0, :got:last_cfa
    ldr x0, [x0, :got_lo12:last_cfa]
    ldr x0, [x0]
    cbz x0, _xdoes_ret
    adrp x1, :got:DODOES
    ldr x1, [x1, :got_lo12:DODOES]
    str x1, [x0]
    str x19, [x0, #8]
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _nfa_reveal_cfa
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
_xdoes_ret:
    ldr x19, [x23], #8
XDOES_RT_END:
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
nm_XDOES:
    .ascii "DOES>"
    .byte 0
hl_XDOES:
    .ascii "DOES> ( -- ) modify last CREATE'd word (immediate)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOES:
    .quad nm_XDOES, hl_XDOES
    .word 0, 2147483648
    .quad XDOES, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOES
    .text
    .p2align 2
XDOES:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x0, :got:cfa_does
    ldr x0, [x0, :got_lo12:cfa_does]
    ldr x0, [x0]
    bl _compile_cell
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
nm_XTHROW:
    .ascii "THROW"
    .byte 0
hl_XTHROW:
    .ascii "THROW ( n -- ) raise exception n (0 is a no-op)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTHROW:
    .quad nm_XTHROW, hl_XTHROW
    .quad 0
    .quad XTHROW, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTHROW
    .text
    .p2align 2
XTHROW:
    cbz x20, _throw_zero
    adrp x7, :got:throw_handler
    ldr x7, [x7, :got_lo12:throw_handler]
    ldr x1, [x7]
    cbz x1, _throw_uncaught
    mov x5, x20
    mov x23, x1
    ldr x19, [x23], #8
    ldr x6, [x23], #8
    mov x4, x22
    ldr x22, [x23], #8
    ldr x8, [x23], #8
    cmp x4, x22
    b.hs _throw_tos_snap
    ldr x8, [x22, #-8]
_throw_tos_snap:
    mov x20, x8
    ldr x0, [x23], #8
    str x0, [x7]
    ldr x0, [x23], #8
    adrp x3, :got:eval_resume_sp
    ldr x3, [x3, :got_lo12:eval_resume_sp]
    str x0, [x3]
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x5, x20, [sp, #48]
    stp x19, x22, [sp, #64]
    mov x0, x6
    bl _throw_unwind_to_sp
    ldp x19, x22, [sp, #64]
    ldp x5, x20, [sp, #48]
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    str xzr, [x0]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    str x20, [x22, #-8]!
    mov x20, x5
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_throw_uncaught:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    str x20, [sp, #48]
    adrp x0, :got:msg_throw
    ldr x0, [x0, :got_lo12:msg_throw]
    bl emit_cstr
    ldr x0, [sp, #48]
    bl _print_signed
    mov x0, #10
    bl _putchar
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    b _do_quit
_throw_zero:
    ldr x20, [x22], #8
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
nm_XPARSE:
    .ascii "PARSE"
    .byte 0
hl_XPARSE:
    .ascii "PARSE ( char -- c-addr u ) parse through delimiter"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPARSE:
    .quad nm_XPARSE, hl_XPARSE
    .quad 0
    .quad XPARSE, XPARSE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPARSE
    .text
    .p2align 2
XPARSE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov w7, w20
    ldr x20, [x22], #8
    bl _cursor_load
    mov x9, x0
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x6, [x3]
    mov x3, x9
_parse_scan:
    cmp x3, x6
    b.hs _parse_eos
    ldrb w4, [x3]
    cbz w4, _parse_eos
    cmp w4, w7
    b.eq _parse_found
    add x3, x3, #1
    b _parse_scan
_parse_found:
    sub x5, x3, x9
    add x3, x3, #1
    b _parse_commit
_parse_eos:
    sub x5, x3, x9
_parse_commit:
    mov x0, x3
    bl _cursor_commit
    str x20, [x22, #-8]!
    mov x20, x9
    str x20, [x22, #-8]!
    mov x20, x5
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XPARSE_END:
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
nm_XWORD:
    .ascii "WORD"
    .byte 0
hl_XWORD:
    .ascii "WORD ( char -- addr ) counted string in transient buffer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XWORD:
    .quad nm_XWORD, hl_XWORD
    .quad 0
    .quad XWORD, XWORD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XWORD
    .text
    .p2align 2
XWORD:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov w7, w20
    bl _cursor_load
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x9, [x3]
_word_skip:
    cmp x0, x9
    b.hs _word_empty
    ldrb w4, [x0]
    cbz w4, _word_empty
    cmp w7, #32
    b.ne _word_skip_exact
    cmp w4, #32
    b.eq _word_adv
    cmp w4, #9
    b.eq _word_adv
    cmp w4, #10
    b.eq _word_adv
    cmp w4, #13
    b.eq _word_adv
    b _word_start
_word_skip_exact:
    cmp w4, w7
    b.ne _word_start
_word_adv:
    add x0, x0, #1
    b _word_skip
_word_start:
    mov x3, x0
_word_scan:
    cmp x0, x9
    b.hs _word_end
    ldrb w4, [x0]
    cbz w4, _word_end
    cmp w7, #32
    b.ne _word_scan_exact
    cmp w4, #32
    b.eq _word_end
    cmp w4, #9
    b.eq _word_end
    cmp w4, #10
    b.eq _word_end
    cmp w4, #13
    b.eq _word_end
    add x0, x0, #1
    b _word_scan
_word_scan_exact:
    cmp w4, w7
    b.eq _word_end
    add x0, x0, #1
    b _word_scan
_word_end:
    sub x5, x0, x3
    cmp x0, x9
    b.hs _word_store
    ldrb w4, [x0]
    cbz w4, _word_store
    add x0, x0, #1
    cmp w7, #32
    b.ne _word_store
    cmp w4, #13
    b.ne _word_store
    cmp x0, x9
    b.hs _word_store
    ldrb w4, [x0]
    cmp w4, #10
    b.ne _word_store
    add x0, x0, #1
_word_store:
    cmp x5, #63
    b.ls _word_len_ok
    mov x5, #63
_word_len_ok:
    bl _cursor_commit
    adrp x6, :got:word_scratch
    ldr x6, [x6, :got_lo12:word_scratch]
    strb w5, [x6]
    mov x1, #0
_word_copy:
    cmp x1, x5
    b.ge _word_done
    ldrb w4, [x3, x1]
    add x8, x6, #1
    strb w4, [x8, x1]
    add x1, x1, #1
    b _word_copy
_word_done:
    mov x20, x6
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
_word_empty:
    bl _cursor_commit
    adrp x6, :got:word_scratch
    ldr x6, [x6, :got_lo12:word_scratch]
    strb wzr, [x6]
    mov x20, x6
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XWORD_END:
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
nm_XDOTPAREN:
    .ascii ".("
    .byte 0
hl_XDOTPAREN:
    .ascii ".( ( -- ) print text until ) (immediate)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOTPAREN:
    .quad nm_XDOTPAREN, hl_XDOTPAREN
    .word 0, 2147483648
    .quad XDOTPAREN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOTPAREN
    .text
    .p2align 2
XDOTPAREN:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov w7, #41
    bl _cursor_load
    mov x9, x0
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x6, [x3]
    mov x3, x9
_dotp_scan:
    cmp x3, x6
    b.hs _dotp_eos
    ldrb w4, [x3]
    cbz w4, _dotp_eos
    cmp w4, w7
    b.eq _dotp_found
    add x3, x3, #1
    b _dotp_scan
_dotp_found:
    sub x5, x3, x9
    add x3, x3, #1
    b _dotp_go
_dotp_eos:
    sub x5, x3, x9
_dotp_go:
    mov x0, x3
    bl _cursor_commit
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    mov x20, x9
    str x20, [x22, #-8]!
    mov x20, x5
    b XTYPE
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XBACKSLASH:
    .byte 92
    .byte 0
hl_XBACKSLASH:
    .byte 92
    .ascii "( -- ) comment to end of line (immediate)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBACKSLASH:
    .quad nm_XBACKSLASH, hl_XBACKSLASH
    .word 0, 2147483648
    .quad XBACKSLASH, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBACKSLASH
    .text
    .p2align 2
XBACKSLASH:
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
    ldr x0, [x0]
    cbnz x0, _bs_block
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _cursor_load
    mov x10, x0
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x9, [x3]
_bs_loop:
    cmp x10, x9
    b.hs _bs_done
    ldrb w4, [x10]
    cbz w4, _bs_done
    cmp w4, #10
    b.eq _bs_done
    cmp w4, #13
    b.eq _bs_done
    add x10, x10, #1
    b _bs_loop
_bs_done:
    mov x0, x10
    bl _cursor_commit
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
_bs_block:
    adrp x0, :got:to_in
    ldr x0, [x0, :got_lo12:to_in]
    ldr x1, [x0]
    adrp x2, :got:source_base
    ldr x2, [x2, :got_lo12:source_base]
    ldr x3, [x2]
    adrp x2, :got:source_end
    ldr x2, [x2, :got_lo12:source_end]
    ldr x2, [x2]
    sub x2, x2, x3
    lsr x5, x1, #6
    add x5, x5, #1
    lsl x5, x5, #6
    cmp x5, x2
    b.ls _bs_blk_ok
    mov x5, x2
_bs_blk_ok:
    str x5, [x0]
    add x3, x3, x5
    adrp x0, :got:source_cur
    ldr x0, [x0, :got_lo12:source_cur]
    str x3, [x0]
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
nm_XPAREN:
    .ascii "("
    .byte 0
hl_XPAREN:
    .ascii "( -- ) comment until ) (immediate)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPAREN:
    .quad nm_XPAREN, hl_XPAREN
    .word 0, 2147483648
    .quad XPAREN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPAREN
    .text
    .p2align 2
XPAREN:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _cursor_load
    mov x10, x0
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x9, [x3]
_par_loop:
    cmp x10, x9
    b.hs _par_eol
    ldrb w4, [x10]
    cbz w4, _par_eol
    cmp w4, #41
    b.eq _par_found
    add x10, x10, #1
    b _par_loop
_par_found:
    add x10, x10, #1
    b _par_store
_par_eol:
    adrp x0, :got:line_mode
    ldr x0, [x0, :got_lo12:line_mode]
    ldr x0, [x0]
    cbz x0, _par_store
    bl _take_line
    cbz x0, _par_eof
    bl _cursor_load
    mov x10, x0
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x9, [x3]
    b _par_loop
_par_eof:
    bl _cursor_load
    mov x10, x0
_par_store:
    mov x0, x10
    bl _cursor_commit
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
nm_XSLIT:
    .ascii "(S"
    .byte 34
    .ascii ")"
    .byte 0
hl_XSLIT:
    .ascii "(S"
    .byte 34
    .ascii ")"
    .ascii "( -- c-addr u ) runtime for a compiled quote string"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSLIT:
    .quad nm_XSLIT, hl_XSLIT
    .quad 0
    .quad XSLIT, XSLIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSLIT
    .text
    .p2align 2
XSLIT:
    ldr x0, [x19], #8
    str x20, [x22, #-8]!
    mov x20, x19
    str x20, [x22, #-8]!
    mov x20, x0
    add x19, x19, x0
    add x19, x19, #7
    bic x19, x19, #7
XSLIT_END:
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
nm_XSQUOTE:
    .ascii "S"
    .byte 34
    .byte 0
hl_XSQUOTE:
    .ascii "S"
    .byte 34
    .ascii "( -- c-addr u ) quote-delimited string (immediate)"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSQUOTE:
    .quad nm_XSQUOTE, hl_XSQUOTE
    .word 0, 2147483648
    .quad XSQUOTE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSQUOTE
    .text
    .p2align 2
XSQUOTE:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    bl _cursor_load
    mov x1, x0
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x6, [x3]
    mov x9, x1
_sq_scan:
    cmp x1, x6
    b.hs _sq_eos
    ldrb w3, [x1]
    cbz w3, _sq_eos
    cmp w3, #34
    b.eq _sq_found
    add x1, x1, #1
    b _sq_scan
_sq_found:
    sub x5, x1, x9
    add x1, x1, #1
    b _sq_commit
_sq_eos:
    sub x5, x1, x9
_sq_commit:
    mov x0, x1
    bl _cursor_commit
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    ldr x0, [x0]
    cbnz x0, _sq_comp
    str x20, [x22, #-8]!
    mov x20, x9
    str x20, [x22, #-8]!
    mov x20, x5
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
_sq_comp:
    stp x9, x5, [sp, #48]
    adrp x0, :got:cfa_slit
    ldr x0, [x0, :got_lo12:cfa_slit]
    ldr x0, [x0]
    bl _compile_cell
    ldr x0, [sp, #56]
    bl _compile_cell
    ldr x5, [sp, #56]
    ldr x9, [sp, #48]
    adrp x0, :got:here_ptr
    ldr x0, [x0, :got_lo12:here_ptr]
    ldr x1, [x0]
    mov x3, #0
_sq_cpy:
    cmp x3, x5
    b.ge _sq_align
    ldrb w4, [x9, x3]
    strb w4, [x1, x3]
    add x3, x3, #1
    b _sq_cpy
_sq_align:
    add x1, x1, x5
    add x1, x1, #7
    bic x1, x1, #7
    str x1, [x0]
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
nm_XCSTR:
    .ascii "(C"
    .byte 34
    .ascii ")"
    .byte 0
hl_XCSTR:
    .ascii "(C"
    .byte 34
    .ascii ")"
    .ascii "( -- c-addr ) runtime for a compiled counted string"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCSTR:
    .quad nm_XCSTR, hl_XCSTR
    .quad 0
    .quad XCSTR, XCSTR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCSTR
    .text
    .p2align 2
XCSTR:
    str x20, [x22, #-8]!
    mov x20, x19
    ldrb w0, [x19]
    add x19, x19, x0
    add x19, x19, #1
    add x19, x19, #7
    bic x19, x19, #7
XCSTR_END:
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
nm_XCQUOTE:
    .ascii "C"
    .byte 34
    .byte 0
hl_XCQUOTE:
    .ascii "C"
    .byte 34
    .ascii "( -- c-addr ) compile a quote-delimited counted string"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCQUOTE:
    .quad nm_XCQUOTE, hl_XCQUOTE
    .word 0, 2147483648
    .quad XCQUOTE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCQUOTE
    .text
    .p2align 2
XCQUOTE:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    bl _cursor_load
    mov x1, x0
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x6, [x3]
    mov x9, x1
_cq_scan:
    cmp x1, x6
    b.hs _cq_eos
    ldrb w3, [x1]
    cbz w3, _cq_eos
    cmp w3, #34
    b.eq _cq_found
    add x1, x1, #1
    b _cq_scan
_cq_found:
    sub x5, x1, x9
    add x1, x1, #1
    b _cq_commit
_cq_eos:
    sub x5, x1, x9
_cq_commit:
    mov x0, x1
    bl _cursor_commit
    cmp x5, #255
    b.ls _cq_lenok
    mov x5, #255
_cq_lenok:
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    ldr x0, [x0]
    cbnz x0, _cq_comp
    adrp x0, :got:pad_buffer
    ldr x0, [x0, :got_lo12:pad_buffer]
    strb w5, [x0]
    mov x3, #0
_cq_ipad:
    cmp x3, x5
    b.ge _cq_idone
    ldrb w4, [x9, x3]
    add x6, x0, #1
    strb w4, [x6, x3]
    add x3, x3, #1
    b _cq_ipad
_cq_idone:
    str x20, [x22, #-8]!
    mov x20, x0
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
_cq_comp:
    stp x9, x5, [sp, #48]
    adrp x0, :got:cfa_cstr
    ldr x0, [x0, :got_lo12:cfa_cstr]
    ldr x0, [x0]
    bl _compile_cell
    ldr x5, [sp, #56]
    ldr x9, [sp, #48]
    adrp x0, :got:here_ptr
    ldr x0, [x0, :got_lo12:here_ptr]
    ldr x1, [x0]
    strb w5, [x1], #1
    mov x3, #0
_cq_cpy:
    cmp x3, x5
    b.ge _cq_align
    ldrb w4, [x9, x3]
    strb w4, [x1, x3]
    add x3, x3, #1
    b _cq_cpy
_cq_align:
    add x1, x1, x5
    add x1, x1, #7
    bic x1, x1, #7
    str x1, [x0]
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
next_debug_gate:
    adrp x16, :got:next_debug
    ldr x16, [x16, :got_lo12:next_debug]
    br x16
    .section .rodata,"a",@progbits
    .p2align 3
msg_allot:
    .ascii "ALLOT: dictionary full (need more USER-DICT space)"
    .byte 10
    .byte 0
msg_throw:
    .ascii " throw "
    .byte 0
msg_huh_k1:
    .ascii " ?"
    .byte 10
    .byte 0
str_search_order:
    .ascii "Search order: "
    .byte 0
str_comp_wl:
    .ascii "Compilation wordlist: "
    .byte 0

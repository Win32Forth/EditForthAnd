/* Generated from Forth/kernel/arm64/prims_k2.asm. Do not edit. */
    .equ ENV_COUNT, 31
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .extern next_debug
    .extern debug_break_asap
    .text
    .p2align 2
    .extern data_stack
    .extern here_ptr
    .extern state_var
    .extern last_cfa
    .extern base_var
    .extern search_order
    .extern search_order_n
    .extern latest_var
    .extern user_dict_area
    .extern user_dict_size_cell
    .extern grow_memory_used
    .extern wordlist_reg
    .extern wordlist_reg_n
    .extern source_base
    .extern source_cur
    .extern source_end
    .extern to_in
    .extern pad_buffer
    .extern redef_warn
    .extern block_file
    .extern block_upd
    .extern block_nr
    .extern block_buf
    .extern scr_var
    .extern cfa_lit
    .extern cfa_exit
    .extern cfa_slit
    .extern cfa_flit
    .extern throw_handler
    .extern catch_ok_cell
    .extern tw_continue_cell
    .extern bootptr_start
    .extern bootptr_end
    .extern key_fn
    .extern _getchar
    .extern debug_busy
    .extern _next_word
    .extern _find_word
    .extern _compile_cell
    .extern _local_lookup
    .extern _local_compile_reset
    .extern _local_add_name
    .extern _local_finalize_compile
    .extern cfa_local_store
    .extern local_declaring
    .extern local_init_count
    .extern local_init_reverse
    .extern _cursor_load
    .extern _cursor_commit
    .extern _putchar
    .extern _print_unsigned
    .extern _sa_putchar
    .extern _sa_print_unsigned
    .extern emit_cstr
    .extern emit_str
    .extern XTYPE
    .extern host_ms
    .extern _file_op_call
    .extern host_read
    .extern host_repos
    .extern host_alloc
    .extern host_free
    .extern host_resolve
    .extern host_begin_load
    .extern host_end_load
    .extern host_register
    .extern host_was_included
    .extern host_accept
    .extern host_resize
    .extern host_sleep
    .extern host_time_date
    .extern host_chdir
    .extern host_edit
    .extern host_edit_at
    .extern host_system
    .extern host_fromlib
    .extern host_fromlib_off
    .extern host_fromlib_query
    .extern facility_op_hook
    .extern host_facility_xy
    .extern host_clip_set
    .extern host_clip_get
    .extern file_echo
    .extern host_library_path
    .extern library_path_buf
    .extern cfa_execute
    .extern cfa_comma
    .extern XROLL
    .extern host_bi_mul
    .extern host_bi_divmod
    .extern host_bi_isqrt
    .extern host_pwd
    .extern host_cwd
    .extern host_dir
    .extern host_last_included
    .extern host_dot_included
    .extern _float_op_call
    .extern host_include_dialog
    .extern host_alloc_exec
    .extern host_free_exec
    .extern host_mprotect
    .extern host_icache_inval
    .extern host_native_ret7
    .extern native_dsp_end
    .extern jit_exec_mode
    .extern current_var
    .extern words_user_base
    .extern blk_var
    .extern forget_cut
    .extern _quit_exit
    .extern _do_quit
    .extern _interpret_loop
    .extern _interpret_empty
    .extern _push_source
    .extern _arm_lines
    .extern _eval_resume_push
    .extern _take_line
    .extern line_mode
    .extern line_limit
    .extern line_next
    .extern source_id
    .extern source_sp
    .extern eval_resume_sp
    .extern resolve_buf
    .extern include_name_pending
    .extern include_name_len
    .extern _view_push_src_id
    .extern _view_set_src_from_pending
    .extern msg_allot
    .extern msg_huh
    .global XCATCH
    .global XCATCH_OK
    .global XTW_CONTINUE
    .global XEXECUTE
    .global _udivmod128
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XTUCK:
    .ascii "TUCK"
    .byte 0
hl_XTUCK:
    .ascii "TUCK ( x1 x2 -- x2 x1 x2 ) copy TOS under the second"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTUCK:
    .quad nm_XTUCK, hl_XTUCK
    .quad 0
    .quad XTUCK, XTUCK_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTUCK
    .text
    .p2align 2
XTUCK:
    ldr x0, [x22]
    str x20, [x22]
    str x0, [x22, #-8]!
XTUCK_END:
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
nm_XPICK:
    .ascii "PICK"
    .byte 0
hl_XPICK:
    .ascii "PICK ( xu ... x0 u -- xu ... x0 xu ) copy the uth cell"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPICK:
    .quad nm_XPICK, hl_XPICK
    .quad 0
    .quad XPICK, XPICK_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPICK
    .text
    .p2align 2
XPICK:
    lsl x0, x20, #3
    ldr x0, [x22, x0]
    mov x20, x0
XPICK_END:
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
nm_X2TOR:
    .ascii "2>R"
    .byte 0
hl_X2TOR:
    .ascii "2>R ( n1 n2 -- ) two to the return stack"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_X2TOR:
    .quad nm_X2TOR, hl_X2TOR
    .quad 0
    .quad X2TOR, X2TOR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_X2TOR
    .text
    .p2align 2
X2TOR:
    ldr x0, [x22], #8
    str x0, [x23, #-8]!
    str x20, [x23, #-8]!
    ldr x20, [x22], #8
X2TOR_END:
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
nm_X2RTO:
    .ascii "2R>"
    .byte 0
hl_X2RTO:
    .ascii "2R> ( -- n1 n2 ) two from the return stack"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_X2RTO:
    .quad nm_X2RTO, hl_X2RTO
    .quad 0
    .quad X2RTO, X2RTO_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_X2RTO
    .text
    .p2align 2
X2RTO:
    str x20, [x22, #-8]!
    ldr x0, [x23], #8
    ldr x1, [x23], #8
    str x1, [x22, #-8]!
    mov x20, x0
X2RTO_END:
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
nm_X2RFETCH:
    .ascii "2R@"
    .byte 0
hl_X2RFETCH:
    .ascii "2R@ ( -- n1 n2 ) copy two from the return stack"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_X2RFETCH:
    .quad nm_X2RFETCH, hl_X2RFETCH
    .quad 0
    .quad X2RFETCH, X2RFETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_X2RFETCH
    .text
    .p2align 2
X2RFETCH:
    str x20, [x22, #-8]!
    ldr x0, [x23]
    ldr x1, [x23, #8]
    str x1, [x22, #-8]!
    mov x20, x0
X2RFETCH_END:
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
nm_XTWOROT:
    .ascii "2ROT"
    .byte 0
hl_XTWOROT:
    .ascii "2ROT ( x1 x2 x3 x4 x5 x6 -- x3 x4 x5 x6 x1 x2 ) rotate three pairs"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTWOROT:
    .quad nm_XTWOROT, hl_XTWOROT
    .quad 0
    .quad XTWOROT, XTWOROT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTWOROT
    .text
    .p2align 2
XTWOROT:
    ldr x5, [x22], #8
    ldr x4, [x22], #8
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    str x3, [x22, #-8]!
    str x4, [x22, #-8]!
    str x5, [x22, #-8]!
    str x20, [x22, #-8]!
    str x1, [x22, #-8]!
    mov x20, x2
XTWOROT_END:
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
nm_XONEMINUS:
    .ascii "1-"
    .byte 0
hl_XONEMINUS:
    .ascii "1- ( n -- n-1 ) decrement"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XONEMINUS:
    .quad nm_XONEMINUS, hl_XONEMINUS
    .quad 0
    .quad XONEMINUS, XONEMINUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XONEMINUS
    .text
    .p2align 2
XONEMINUS:
    sub x20, x20, #1
XONEMINUS_END:
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
nm_XNEGATE:
    .ascii "NEGATE"
    .byte 0
hl_XNEGATE:
    .ascii "NEGATE ( n -- -n ) negate"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNEGATE:
    .quad nm_XNEGATE, hl_XNEGATE
    .quad 0
    .quad XNEGATE, XNEGATE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNEGATE
    .text
    .p2align 2
XNEGATE:
    neg x20, x20
XNEGATE_END:
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
nm_XABS:
    .ascii "ABS"
    .byte 0
hl_XABS:
    .ascii "ABS ( n -- u ) absolute value"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XABS:
    .quad nm_XABS, hl_XABS
    .quad 0
    .quad XABS, XABS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XABS
    .text
    .p2align 2
XABS:
    cmp x20, #0
    csneg x20, x20, x20, ge
XABS_END:
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
nm_XMIN:
    .ascii "MIN"
    .byte 0
hl_XMIN:
    .ascii "MIN ( n1 n2 -- min ) minimum"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMIN:
    .quad nm_XMIN, hl_XMIN
    .quad 0
    .quad XMIN, XMIN_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMIN
    .text
    .p2align 2
XMIN:
    ldr x0, [x22], #8
    cmp x0, x20
    csel x20, x0, x20, lt
XMIN_END:
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
nm_XMAX:
    .ascii "MAX"
    .byte 0
hl_XMAX:
    .ascii "MAX ( n1 n2 -- max ) maximum"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMAX:
    .quad nm_XMAX, hl_XMAX
    .quad 0
    .quad XMAX, XMAX_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMAX
    .text
    .p2align 2
XMAX:
    ldr x0, [x22], #8
    cmp x0, x20
    csel x20, x0, x20, gt
XMAX_END:
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
nm_XXOR:
    .ascii "XOR"
    .byte 0
hl_XXOR:
    .ascii "XOR ( n1 n2 -- n ) bitwise xor"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XXOR:
    .quad nm_XXOR, hl_XXOR
    .quad 0
    .quad XXOR, XXOR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XXOR
    .text
    .p2align 2
XXOR:
    ldr x0, [x22], #8
    eor x20, x20, x0
XXOR_END:
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
nm_XLSHIFT:
    .ascii "LSHIFT"
    .byte 0
hl_XLSHIFT:
    .ascii "LSHIFT ( n bits -- n ) logical left shift"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLSHIFT:
    .quad nm_XLSHIFT, hl_XLSHIFT
    .quad 0
    .quad XLSHIFT, XLSHIFT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLSHIFT
    .text
    .p2align 2
XLSHIFT:
    ldr x0, [x22], #8
    lsl x20, x0, x20
XLSHIFT_END:
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
nm_XNEQUAL:
    .ascii "<>"
    .byte 0
hl_XNEQUAL:
    .ascii "<> ( n1 n2 -- flag ) not equal"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNEQUAL:
    .quad nm_XNEQUAL, hl_XNEQUAL
    .quad 0
    .quad XNEQUAL, XNEQUAL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNEQUAL
    .text
    .p2align 2
XNEQUAL:
    ldr x0, [x22], #8
    cmp x0, x20
    csetm x20, ne
XNEQUAL_END:
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
nm_XULESS:
    .ascii "U<"
    .byte 0
hl_XULESS:
    .ascii "U< ( u1 u2 -- flag ) unsigned less"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XULESS:
    .quad nm_XULESS, hl_XULESS
    .quad 0
    .quad XULESS, XULESS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XULESS
    .text
    .p2align 2
XULESS:
    ldr x0, [x22], #8
    cmp x0, x20
    csetm x20, lo
XULESS_END:
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
nm_XUGREATER:
    .ascii "U>"
    .byte 0
hl_XUGREATER:
    .ascii "U> ( u1 u2 -- flag ) unsigned greater"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XUGREATER:
    .quad nm_XUGREATER, hl_XUGREATER
    .quad 0
    .quad XUGREATER, XUGREATER_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XUGREATER
    .text
    .p2align 2
XUGREATER:
    ldr x0, [x22], #8
    cmp x0, x20
    csetm x20, hi
XUGREATER_END:
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
nm_XZLESS:
    .ascii "0<"
    .byte 0
hl_XZLESS:
    .ascii "0< ( n -- flag ) negative?"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XZLESS:
    .quad nm_XZLESS, hl_XZLESS
    .quad 0
    .quad XZLESS, XZLESS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XZLESS
    .text
    .p2align 2
XZLESS:
    cmp x20, #0
    csetm x20, lt
XZLESS_END:
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
nm_XZNOTEQUAL:
    .ascii "0<>"
    .byte 0
hl_XZNOTEQUAL:
    .ascii "0<> ( x -- flag ) not zero?"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XZNOTEQUAL:
    .quad nm_XZNOTEQUAL, hl_XZNOTEQUAL
    .quad 0
    .quad XZNOTEQUAL, XZNOTEQUAL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XZNOTEQUAL
    .text
    .p2align 2
XZNOTEQUAL:
    cmp x20, #0
    csetm x20, ne
XZNOTEQUAL_END:
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
nm_XZGREATER:
    .ascii "0>"
    .byte 0
hl_XZGREATER:
    .ascii "0> ( n -- flag ) positive?"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XZGREATER:
    .quad nm_XZGREATER, hl_XZGREATER
    .quad 0
    .quad XZGREATER, XZGREATER_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XZGREATER
    .text
    .p2align 2
XZGREATER:
    cmp x20, #0
    csetm x20, gt
XZGREATER_END:
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
nm_XWITHIN:
    .ascii "WITHIN"
    .byte 0
hl_XWITHIN:
    .ascii "WITHIN ( n1 n2 n3 -- flag ) n2 <= n1 < n3 with unsigned wrap"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XWITHIN:
    .quad nm_XWITHIN, hl_XWITHIN
    .quad 0
    .quad XWITHIN, XWITHIN_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XWITHIN
    .text
    .p2align 2
XWITHIN:
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    sub x1, x1, x2
    sub x20, x20, x2
    cmp x1, x20
    csetm x20, lo
XWITHIN_END:
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
nm_XTRUE:
    .ascii "TRUE"
    .byte 0
hl_XTRUE:
    .ascii "TRUE ( -- -1 ) true flag"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTRUE:
    .quad nm_XTRUE, hl_XTRUE
    .quad 0
    .quad XTRUE, XTRUE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTRUE
    .text
    .p2align 2
XTRUE:
    str x20, [x22, #-8]!
    mov x20, #-1
XTRUE_END:
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
nm_XFALSE:
    .ascii "FALSE"
    .byte 0
hl_XFALSE:
    .ascii "FALSE ( -- 0 ) false flag"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFALSE:
    .quad nm_XFALSE, hl_XFALSE
    .quad 0
    .quad XFALSE, XFALSE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFALSE
    .text
    .p2align 2
XFALSE:
    str x20, [x22, #-8]!
    mov x20, #0
XFALSE_END:
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
nm_XPLUSSTORE:
    .ascii "+!"
    .byte 0
hl_XPLUSSTORE:
    .ascii "+! ( n addr -- ) add to memory"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPLUSSTORE:
    .quad nm_XPLUSSTORE, hl_XPLUSSTORE
    .quad 0
    .quad XPLUSSTORE, XPLUSSTORE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPLUSSTORE
    .text
    .p2align 2
XPLUSSTORE:
    ldr x0, [x22], #8
    ldr x1, [x20]
    add x1, x1, x0
    str x1, [x20]
    ldr x20, [x22], #8
XPLUSSTORE_END:
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
nm_XPAD:
    .ascii "PAD"
    .byte 0
hl_XPAD:
    .ascii "PAD ( -- addr ) transient scratch of 1024 bytes"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPAD:
    .quad nm_XPAD, hl_XPAD
    .quad 0
    .quad XPAD, XPAD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPAD
    .text
    .p2align 2
XPAD:
    str x20, [x22, #-8]!
    adrp x0, :got:pad_buffer
    ldr x0, [x0, :got_lo12:pad_buffer]
    mov x20, x0
XPAD_END:
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
nm_XUNUSED:
    .ascii "UNUSED"
    .byte 0
hl_XUNUSED:
    .ascii "UNUSED ( -- u ) bytes from HERE to the dictionary end"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XUNUSED:
    .quad nm_XUNUSED, hl_XUNUSED
    .quad 0
    .quad XUNUSED, XUNUSED_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XUNUSED
    .text
    .p2align 2
XUNUSED:
    adrp x0, :got:here_ptr
    ldr x0, [x0, :got_lo12:here_ptr]
    ldr x1, [x0]
    adrp x0, :got:user_dict_area
    ldr x0, [x0, :got_lo12:user_dict_area]
    adrp x2, :got:user_dict_size_cell
    ldr x2, [x2, :got_lo12:user_dict_size_cell]
    ldr x2, [x2]
    add x0, x0, x2
    subs x0, x0, x1
    b.hs _unused_ok
    mov x0, #0
_unused_ok:
    str x20, [x22, #-8]!
    mov x20, x0
XUNUSED_END:
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
nm_XUSER_DICT:
    .ascii "USER-DICT"
    .byte 0
hl_XUSER_DICT:
    .ascii "USER-DICT ( -- addr ) base of user dictionary"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XUSER_DICT:
    .quad nm_XUSER_DICT, hl_XUSER_DICT
    .quad 0
    .quad XUSER_DICT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XUSER_DICT
    .text
    .p2align 2
XUSER_DICT:
    str x20, [x22, #-8]!
    adrp x0, :got:user_dict_area
    ldr x0, [x0, :got_lo12:user_dict_area]
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
nm_XGROWMEMORYMB:
    .ascii "GROWMEMORYMB"
    .byte 0
hl_XGROWMEMORYMB:
    .ascii "GROWMEMORYMB ( n -- ) grow user dictionary to n MiB once per session with no shrink and a max of 256"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XGROWMEMORYMB:
    .quad nm_XGROWMEMORYMB, hl_XGROWMEMORYMB
    .quad 0
    .quad XGROWMEMORYMB, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XGROWMEMORYMB
    .text
    .p2align 2
XGROWMEMORYMB:
    mov x0, x20
    ldr x20, [x22], #8
    adrp x1, :got:grow_memory_used
    ldr x1, [x1, :got_lo12:grow_memory_used]
    ldr x2, [x1]
    cbnz x2, _gmm_already
    cmp x0, #1
    b.lt _gmm_small
    cmp x0, #256
    b.hi _gmm_big
    lsl x3, x0, #20
    adrp x4, :got:user_dict_size_cell
    ldr x4, [x4, :got_lo12:user_dict_size_cell]
    ldr x5, [x4]
    cmp x3, x5
    b.ls _gmm_shrink
    str x3, [x4]
    mov x2, #1
    str x2, [x1]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_gmm_already:
    adrp x0, :got:str_gmm_already
    ldr x0, [x0, :got_lo12:str_gmm_already]
    b _gmm_fail
_gmm_small:
    adrp x0, :got:str_gmm_small
    ldr x0, [x0, :got_lo12:str_gmm_small]
    b _gmm_fail
_gmm_big:
    adrp x0, :got:str_gmm_big
    ldr x0, [x0, :got_lo12:str_gmm_big]
    b _gmm_fail
_gmm_shrink:
    adrp x0, :got:str_gmm_shrink
    ldr x0, [x0, :got_lo12:str_gmm_shrink]
_gmm_fail:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl emit_cstr
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    b _quit_exit
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XCCOMMA:
    .ascii "C"
    .byte 44
    .byte 0
hl_XCCOMMA:
    .ascii "C"
    .byte 44
    .ascii "( b -- ) compile a byte"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCCOMMA:
    .quad nm_XCCOMMA, hl_XCCOMMA
    .quad 0
    .quad XCCOMMA, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCCOMMA
    .text
    .p2align 2
XCCOMMA:
    mov w0, w20
    ldr x20, [x22], #8
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    ldr x2, [x1]
    add x3, x2, #1
    adrp x4, :got:user_dict_area
    ldr x4, [x4, :got_lo12:user_dict_area]
    cmp x3, x4
    b.lo _ccomma_fail
    adrp x5, :got:user_dict_size_cell
    ldr x5, [x5, :got_lo12:user_dict_size_cell]
    ldr x5, [x5]
    add x5, x4, x5
    cmp x3, x5
    b.hi _ccomma_fail
    strb w0, [x2]
    str x3, [x1]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_ccomma_fail:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x0, :got:msg_allot
    ldr x0, [x0, :got_lo12:msg_allot]
    bl emit_cstr
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    b _quit_exit
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XTWOFETCH:
    .ascii "2@"
    .byte 0
hl_XTWOFETCH:
    .ascii "2@ ( addr -- n1 n2 ) fetch two cells"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTWOFETCH:
    .quad nm_XTWOFETCH, hl_XTWOFETCH
    .quad 0
    .quad XTWOFETCH, XTWOFETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTWOFETCH
    .text
    .p2align 2
XTWOFETCH:
    mov x0, x20
    ldr x1, [x0, #8]
    ldr x20, [x0]
    str x1, [x22, #-8]!
XTWOFETCH_END:
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
nm_XTWOSTORE:
    .ascii "2!"
    .byte 0
hl_XTWOSTORE:
    .ascii "2! ( n1 n2 addr -- ) store two cells"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTWOSTORE:
    .quad nm_XTWOSTORE, hl_XTWOSTORE
    .quad 0
    .quad XTWOSTORE, XTWOSTORE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTWOSTORE
    .text
    .p2align 2
XTWOSTORE:
    mov x0, x20
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    ldr x20, [x22], #8
    str x2, [x0]
    str x1, [x0, #8]
XTWOSTORE_END:
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
nm_XI:
    .ascii "I"
    .byte 0
hl_XI:
    .ascii "I ( -- n ) current DO loop index"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XI:
    .quad nm_XI, hl_XI
    .quad 0
    .quad XI, XI_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XI
    .text
    .p2align 2
XI:
    str x20, [x22, #-8]!
    ldr x20, [x23]
XI_END:
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
nm_XJ:
    .ascii "J"
    .byte 0
hl_XJ:
    .ascii "J ( -- n ) outer DO loop index"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XJ:
    .quad nm_XJ, hl_XJ
    .quad 0
    .quad XJ, XJ_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XJ
    .text
    .p2align 2
XJ:
    str x20, [x22, #-8]!
    ldr x20, [x23, #16]
XJ_END:
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
nm_XUNLOOP:
    .ascii "UNLOOP"
    .byte 0
hl_XUNLOOP:
    .ascii "UNLOOP ( -- ) discard the current DO loop"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XUNLOOP:
    .quad nm_XUNLOOP, hl_XUNLOOP
    .quad 0
    .quad XUNLOOP, XUNLOOP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XUNLOOP
    .text
    .p2align 2
XUNLOOP:
    add x23, x23, #16
XUNLOOP_END:
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
nm_XSLMOD:
    .ascii "/MOD"
    .byte 0
hl_XSLMOD:
    .ascii "/MOD ( n1 n2 -- rem quot ) remainder and quotient"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSLMOD:
    .quad nm_XSLMOD, hl_XSLMOD
    .quad 0
    .quad XSLMOD, XSLMOD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSLMOD
    .text
    .p2align 2
XSLMOD:
    ldr x0, [x22], #8
    sdiv x1, x0, x20
    msub x2, x1, x20, x0
    str x2, [x22, #-8]!
    mov x20, x1
XSLMOD_END:
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
nm_XUMSTAR:
    .ascii "UM*"
    .byte 0
hl_XUMSTAR:
    .ascii "UM* ( u1 u2 -- ud ) unsigned double multiply"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XUMSTAR:
    .quad nm_XUMSTAR, hl_XUMSTAR
    .quad 0
    .quad XUMSTAR, XUMSTAR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XUMSTAR
    .text
    .p2align 2
XUMSTAR:
    mov x1, x20
    ldr x0, [x22], #8
    mul x2, x0, x1
    umulh x20, x0, x1
    str x2, [x22, #-8]!
XUMSTAR_END:
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
nm_XMSTAR:
    .ascii "M*"
    .byte 0
hl_XMSTAR:
    .ascii "M* ( n1 n2 -- d ) signed double multiply"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMSTAR:
    .quad nm_XMSTAR, hl_XMSTAR
    .quad 0
    .quad XMSTAR, XMSTAR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMSTAR
    .text
    .p2align 2
XMSTAR:
    mov x1, x20
    ldr x0, [x22], #8
    mul x2, x0, x1
    smulh x20, x0, x1
    str x2, [x22, #-8]!
XMSTAR_END:
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
nm_XDPLUS:
    .ascii "D+"
    .byte 0
hl_XDPLUS:
    .ascii "D+ ( d1 d2 -- d3 ) double add"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDPLUS:
    .quad nm_XDPLUS, hl_XDPLUS
    .quad 0
    .quad XDPLUS, XDPLUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDPLUS
    .text
    .p2align 2
XDPLUS:
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    adds x1, x1, x3
    adc x20, x2, x20
    str x1, [x22, #-8]!
XDPLUS_END:
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
nm_XDNEGATE:
    .ascii "DNEGATE"
    .byte 0
hl_XDNEGATE:
    .ascii "DNEGATE ( d1 -- d2 ) negate a double"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDNEGATE:
    .quad nm_XDNEGATE, hl_XDNEGATE
    .quad 0
    .quad XDNEGATE, XDNEGATE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDNEGATE
    .text
    .p2align 2
XDNEGATE:
    ldr x1, [x22]
    mov x0, xzr
    subs x1, x0, x1
    sbc x20, x0, x20
    str x1, [x22]
XDNEGATE_END:
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
nm_XDABS:
    .ascii "DABS"
    .byte 0
hl_XDABS:
    .ascii "DABS ( d -- ud ) absolute value of a double"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDABS:
    .quad nm_XDABS, hl_XDABS
    .quad 0
    .quad XDABS, XDABS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDABS
    .text
    .p2align 2
XDABS:
    tbnz x20, #63, _dabs_neg
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_dabs_neg:
    ldr x1, [x22]
    mov x0, xzr
    subs x1, x0, x1
    sbc x20, x0, x20
    str x1, [x22]
XDABS_END:
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
nm_XD0LESS:
    .ascii "D0<"
    .byte 0
hl_XD0LESS:
    .ascii "D0< ( d -- flag ) double negative?"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XD0LESS:
    .quad nm_XD0LESS, hl_XD0LESS
    .quad 0
    .quad XD0LESS, XD0LESS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XD0LESS
    .text
    .p2align 2
XD0LESS:
    cmp x20, #0
    csetm x20, lt
    add x22, x22, #8
XD0LESS_END:
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
nm_XSTOD:
    .ascii "S>D"
    .byte 0
hl_XSTOD:
    .ascii "S>D ( n -- d ) sign extend single to double"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSTOD:
    .quad nm_XSTOD, hl_XSTOD
    .quad 0
    .quad XSTOD, XSTOD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSTOD
    .text
    .p2align 2
XSTOD:
    str x20, [x22, #-8]!
    asr x20, x20, #63
XSTOD_END:
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
nm_XDMINUS:
    .ascii "D-"
    .byte 0
hl_XDMINUS:
    .ascii "D- ( d1 d2 -- d3 ) double subtract"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDMINUS:
    .quad nm_XDMINUS, hl_XDMINUS
    .quad 0
    .quad XDMINUS, XDMINUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDMINUS
    .text
    .p2align 2
XDMINUS:
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    subs x1, x1, x3
    sbc x20, x2, x20
    str x1, [x22, #-8]!
XDMINUS_END:
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
nm_XD2STAR:
    .ascii "D2*"
    .byte 0
hl_XD2STAR:
    .ascii "D2* ( xd1 -- xd2 ) shift double left 1"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XD2STAR:
    .quad nm_XD2STAR, hl_XD2STAR
    .quad 0
    .quad XD2STAR, XD2STAR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XD2STAR
    .text
    .p2align 2
XD2STAR:
    ldr x1, [x22]
    lsl x20, x20, #1
    orr x20, x20, x1, lsr #63
    lsl x1, x1, #1
    str x1, [x22]
XD2STAR_END:
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
nm_XD2SLASH:
    .ascii "D2/"
    .byte 0
hl_XD2SLASH:
    .ascii "D2/ ( xd1 -- xd2 ) arithmetic shift double right 1"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XD2SLASH:
    .quad nm_XD2SLASH, hl_XD2SLASH
    .quad 0
    .quad XD2SLASH, XD2SLASH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XD2SLASH
    .text
    .p2align 2
XD2SLASH:
    ldr x1, [x22]
    extr x1, x20, x1, #1
    asr x20, x20, #1
    str x1, [x22]
XD2SLASH_END:
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
nm_XD0EQUAL:
    .ascii "D0="
    .byte 0
hl_XD0EQUAL:
    .ascii "D0= ( xd -- flag ) double equal zero?"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XD0EQUAL:
    .quad nm_XD0EQUAL, hl_XD0EQUAL
    .quad 0
    .quad XD0EQUAL, XD0EQUAL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XD0EQUAL
    .text
    .p2align 2
XD0EQUAL:
    ldr x1, [x22], #8
    orr x1, x1, x20
    cmp x1, #0
    csetm x20, eq
XD0EQUAL_END:
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
nm_XDEQUAL:
    .ascii "D="
    .byte 0
hl_XDEQUAL:
    .ascii "D= ( xd1 xd2 -- flag ) double equal?"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDEQUAL:
    .quad nm_XDEQUAL, hl_XDEQUAL
    .quad 0
    .quad XDEQUAL, XDEQUAL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDEQUAL
    .text
    .p2align 2
XDEQUAL:
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    cmp x1, x3
    ccmp x2, x20, #0, eq
    csetm x20, eq
XDEQUAL_END:
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
nm_XDLESS:
    .ascii "D<"
    .byte 0
hl_XDLESS:
    .ascii "D< ( d1 d2 -- flag ) signed double less"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDLESS:
    .quad nm_XDLESS, hl_XDLESS
    .quad 0
    .quad XDLESS, XDLESS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDLESS
    .text
    .p2align 2
XDLESS:
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    cmp x2, x20
    b.lt _dless_yes
    b.gt _dless_no
    cmp x1, x3
    csetm x20, lo
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_dless_yes:
    mov x20, #-1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_dless_no:
    mov x20, #0
XDLESS_END:
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
nm_XDULESS:
    .ascii "DU<"
    .byte 0
hl_XDULESS:
    .ascii "DU< ( ud1 ud2 -- flag ) unsigned double less"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDULESS:
    .quad nm_XDULESS, hl_XDULESS
    .quad 0
    .quad XDULESS, XDULESS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDULESS
    .text
    .p2align 2
XDULESS:
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    cmp x2, x20
    b.lo _duless_yes
    b.hi _duless_no
    cmp x1, x3
    csetm x20, lo
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_duless_yes:
    mov x20, #-1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_duless_no:
    mov x20, #0
XDULESS_END:
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
nm_XDMIN:
    .ascii "DMIN"
    .byte 0
hl_XDMIN:
    .ascii "DMIN ( d1 d2 -- d3 ) minimum of two doubles"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDMIN:
    .quad nm_XDMIN, hl_XDMIN
    .quad 0
    .quad XDMIN, XDMIN_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDMIN
    .text
    .p2align 2
XDMIN:
    ldr x3, [x22]
    ldr x2, [x22, #8]
    ldr x1, [x22, #16]
    cmp x2, x20
    b.lt _dmin_d1
    b.gt _dmin_d2
    cmp x1, x3
    b.ls _dmin_d1
_dmin_d2:
    str x3, [x22, #16]
    add x22, x22, #16
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_dmin_d1:
    mov x20, x2
    add x22, x22, #16
XDMIN_END:
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
nm_XDMAX:
    .ascii "DMAX"
    .byte 0
hl_XDMAX:
    .ascii "DMAX ( d1 d2 -- d3 ) maximum of two doubles"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDMAX:
    .quad nm_XDMAX, hl_XDMAX
    .quad 0
    .quad XDMAX, XDMAX_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDMAX
    .text
    .p2align 2
XDMAX:
    ldr x3, [x22]
    ldr x2, [x22, #8]
    ldr x1, [x22, #16]
    cmp x2, x20
    b.gt _dmax_d1
    b.lt _dmax_d2
    cmp x1, x3
    b.hs _dmax_d1
_dmax_d2:
    str x3, [x22, #16]
    add x22, x22, #16
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_dmax_d1:
    mov x20, x2
    add x22, x22, #16
XDMAX_END:
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
nm_XDTOS:
    .ascii "D>S"
    .byte 0
hl_XDTOS:
    .ascii "D>S ( d -- n ) double to single"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDTOS:
    .quad nm_XDTOS, hl_XDTOS
    .quad 0
    .quad XDTOS, XDTOS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDTOS
    .text
    .p2align 2
XDTOS:
    ldr x20, [x22], #8
XDTOS_END:
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
nm_XMPLUS:
    .ascii "M+"
    .byte 0
hl_XMPLUS:
    .ascii "M+ ( d1 n -- d2 ) add single to double"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMPLUS:
    .quad nm_XMPLUS, hl_XMPLUS
    .quad 0
    .quad XMPLUS, XMPLUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMPLUS
    .text
    .p2align 2
XMPLUS:
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    asr x3, x20, #63
    adds x1, x1, x20
    adc x20, x2, x3
    str x1, [x22, #-8]!
XMPLUS_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_udivmod128:
    cbz x2, _udm_bad
    cmp x1, x2
    b.hs _udm_bad
    mov x3, xzr
    mov x4, xzr
    mov x5, #128
_udm_bit:
    sub x5, x5, #1
    cmp x5, #64
    b.hs _udm_hi
    lsr x6, x0, x5
    b _udm_got
_udm_hi:
    sub x7, x5, #64
    lsr x6, x1, x7
_udm_got:
    and x6, x6, #1
    lsr x7, x4, #63
    lsl x4, x4, #1
    orr x4, x4, x6
    lsl x3, x3, #1
    cbnz x7, _udm_sub
    cmp x4, x2
    b.lo _udm_next
_udm_sub:
    sub x4, x4, x2
    orr x3, x3, #1
_udm_next:
    cbnz x5, _udm_bit
    ret
_udm_bad:
    mov x3, #-1
    mov x4, x0
    ret
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XUMMOD:
    .ascii "UM/MOD"
    .byte 0
hl_XUMMOD:
    .ascii "UM/MOD ( ud u -- rem quot ) unsigned divmod"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XUMMOD:
    .quad nm_XUMMOD, hl_XUMMOD
    .quad 0
    .quad XUMMOD, XUMMOD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XUMMOD
    .text
    .p2align 2
XUMMOD:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x2, x20
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    bl _udivmod128
    str x4, [x22, #-8]!
    mov x20, x3
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XUMMOD_END:
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
nm_XSMREM:
    .ascii "SM/REM"
    .byte 0
hl_XSMREM:
    .ascii "SM/REM ( d n -- rem quot ) symmetric divmod"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSMREM:
    .quad nm_XSMREM, hl_XSMREM
    .quad 0
    .quad XSMREM, XSMREM_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSMREM
    .text
    .p2align 2
XSMREM:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x5, x20
    ldr x4, [x22], #8
    ldr x3, [x22], #8
    cmp x4, #0
    cset x6, lt
    cmp x5, #0
    cset x7, lt
    stp x6, x7, [sp, #-16]!
    mov x0, x3
    mov x1, x4
    cbz x6, _sm_absd
    mvn x0, x0
    mvn x1, x1
    adds x0, x0, #1
    adc x1, x1, xzr
_sm_absd:
    mov x2, x5
    cbz x7, _sm_absn
    neg x2, x2
_sm_absn:
    cbz x2, _sm_div0
    bl _udivmod128
    ldp x6, x7, [sp], #16
    cbz x6, _sm_quotsign
    neg x4, x4
_sm_quotsign:
    eor x8, x6, x7
    cbz x8, _sm_push
    neg x3, x3
_sm_push:
    str x4, [x22, #-8]!
    mov x20, x3
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
_sm_div0:
    add sp, sp, #16
    str xzr, [x22, #-8]!
    mov x20, #-1
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XSMREM_END:
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
nm_XFMMOD:
    .ascii "FM/MOD"
    .byte 0
hl_XFMMOD:
    .ascii "FM/MOD ( d n -- rem quot ) floored divmod"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFMMOD:
    .quad nm_XFMMOD, hl_XFMMOD
    .quad 0
    .quad XFMMOD, XFMMOD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFMMOD
    .text
    .p2align 2
XFMMOD:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    mov x5, x20
    ldr x4, [x22], #8
    ldr x3, [x22], #8
    cmp x4, #0
    cset x6, lt
    cmp x5, #0
    cset x7, lt
    stp x6, x7, [sp, #48]
    str x5, [sp, #64]
    mov x0, x3
    mov x1, x4
    cbz x6, _fm_absd
    mvn x0, x0
    mvn x1, x1
    adds x0, x0, #1
    adc x1, x1, xzr
_fm_absd:
    mov x2, x5
    cbz x7, _fm_absn
    neg x2, x2
_fm_absn:
    cbz x2, _fm_div0
    bl _udivmod128
    ldp x6, x7, [sp, #48]
    ldr x5, [sp, #64]
    cbz x6, _fm_remsign
    neg x4, x4
_fm_remsign:
    eor x8, x6, x7
    cbz x8, _fm_floor
    neg x3, x3
_fm_floor:
    cbz x4, _fm_push
    eor x8, x4, x5
    tbz x8, #63, _fm_push
    sub x3, x3, #1
    add x4, x4, x5
_fm_push:
    str x4, [x22, #-8]!
    mov x20, x3
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
_fm_div0:
    str xzr, [x22, #-8]!
    mov x20, #-1
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
XFMMOD_END:
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
nm_XSEARCH:
    .ascii "SEARCH"
    .byte 0
hl_XSEARCH:
    .ascii "SEARCH ( c-addr1 u1 c-addr2 u2 -- c-addr3 u3 flag ) find substring"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSEARCH:
    .quad nm_XSEARCH, hl_XSEARCH
    .quad 0
    .quad XSEARCH, XSEARCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSEARCH
    .text
    .p2align 2
XSEARCH:
    mov x3, x20
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    mov x9, x0
    mov x10, x1
    mov x4, #0
    cbz x3, _search_hit
_search_off:
    subs x5, x1, x4
    b.lo _search_miss
    cmp x5, x3
    b.lo _search_miss
    mov x6, #0
_search_cmp:
    cmp x6, x3
    b.hs _search_hit
    add x7, x0, x4
    ldrb w8, [x7, x6]
    ldrb w11, [x2, x6]
    cmp w8, w11
    b.ne _search_next
    add x6, x6, #1
    b _search_cmp
_search_next:
    add x4, x4, #1
    b _search_off
_search_hit:
    add x0, x0, x4
    sub x1, x1, x4
    str x0, [x22, #-8]!
    str x1, [x22, #-8]!
    mov x20, #-1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_search_miss:
    str x9, [x22, #-8]!
    str x10, [x22, #-8]!
    mov x20, #0
XSEARCH_END:
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
nm_XCONTAINS:
    .ascii "CONTAINS"
    .byte 0
hl_XCONTAINS:
    .ascii "CONTAINS ( hay-a hay-u ned-a ned-u -- flag ) case-insensitive substring"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCONTAINS:
    .quad nm_XCONTAINS, hl_XCONTAINS
    .quad 0
    .quad XCONTAINS, XCONTAINS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCONTAINS
    .text
    .p2align 2
XCONTAINS:
    mov x4, x20
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    cbz x4, _cont_yes
    cmp x2, x4
    b.lo _cont_no
    sub x5, x2, x4
    add x5, x5, #1
    mov x6, #0
_cont_i:
    cmp x6, x5
    b.hs _cont_no
    mov x7, #0
_cont_j:
    cmp x7, x4
    b.hs _cont_yes
    add x8, x1, x6
    add x8, x8, x7
    ldrb w9, [x8]
    ldrb w10, [x3, x7]
    cmp w9, #'a'
    b.lo _cont_hfold
    cmp w9, #'z'
    b.hi _cont_hfold
    sub w9, w9, #32
_cont_hfold:
    cmp w10, #'a'
    b.lo _cont_nfold
    cmp w10, #'z'
    b.hi _cont_nfold
    sub w10, w10, #32
_cont_nfold:
    cmp w9, w10
    b.ne _cont_next_i
    add x7, x7, #1
    b _cont_j
_cont_next_i:
    add x6, x6, #1
    b _cont_i
_cont_yes:
    mov x20, #-1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_cont_no:
    mov x20, #0
XCONTAINS_END:
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
nm_XUDOT:
    .ascii "U."
    .byte 0
hl_XUDOT:
    .ascii "U. ( u -- ) print unsigned with a trailing space"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XUDOT:
    .quad nm_XUDOT, hl_XUDOT
    .quad 0
    .quad XUDOT, XUDOT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XUDOT
    .text
    .p2align 2
XUDOT:
    mov x0, x20
    ldr x20, [x22], #8
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _sa_print_unsigned
    mov x0, #32
    bl _sa_putchar
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XUDOT_END:
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
nm_XSPACES:
    .ascii "SPACES"
    .byte 0
hl_XSPACES:
    .ascii "SPACES ( n -- ) emit n spaces"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSPACES:
    .quad nm_XSPACES, hl_XSPACES
    .quad 0
    .quad XSPACES, XSPACES_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSPACES
    .text
    .p2align 2
XSPACES:
    mov x1, x20
    ldr x20, [x22], #8
    cmp x1, #0
    b.le XSPACES_END
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
_spaces_loop:
    str x1, [sp, #48]
    mov x0, #32
    bl _putchar
    ldr x1, [sp, #48]
    subs x1, x1, #1
    b.ne _spaces_loop
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XSPACES_END:
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
nm_XMSFETCH:
    .ascii "MS@"
    .byte 0
hl_XMSFETCH:
    .ascii "MS@ ( -- u ) milliseconds since the host started"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMSFETCH:
    .quad nm_XMSFETCH, hl_XMSFETCH
    .quad 0
    .quad XMSFETCH, XMSFETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMSFETCH
    .text
    .p2align 2
XMSFETCH:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl host_ms
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    mov x20, x0
XMSFETCH_END:
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
nm_XMS:
    .ascii "MS"
    .byte 0
hl_XMS:
    .ascii "MS ( u -- ) wait that many milliseconds"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMS:
    .quad nm_XMS, hl_XMS
    .quad 0
    .quad XMS, XMS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMS
    .text
    .p2align 2
XMS:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x0, x20
    ldr x20, [x22], #8
    bl host_sleep
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XMS_END:
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
nm_XTIME_DATE:
    .ascii "TIME"
    .byte 38
    .ascii "DATE"
    .byte 0
hl_XTIME_DATE:
    .ascii "TIME"
    .byte 38
    .ascii "DATE"
    .ascii "( -- sec min hour day month year ) local wall time"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTIME_DATE:
    .quad nm_XTIME_DATE, hl_XTIME_DATE
    .quad 0
    .quad XTIME_DATE, XTIME_DATE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTIME_DATE
    .text
    .p2align 2
XTIME_DATE:
    sub sp, sp, #112
    stp x29, x30, [sp, #32]
    add x0, sp, #48
    bl host_time_date
    ldr x0, [sp, #48]
    ldr x1, [sp, #56]
    ldr x2, [sp, #64]
    ldr x3, [sp, #72]
    ldr x4, [sp, #80]
    ldr x5, [sp, #88]
    ldp x29, x30, [sp, #32]
    add sp, sp, #112
    str x20, [x22, #-8]!
    str x0, [x22, #-8]!
    str x1, [x22, #-8]!
    str x2, [x22, #-8]!
    str x3, [x22, #-8]!
    str x4, [x22, #-8]!
    mov x20, x5
XTIME_DATE_END:
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
nm_XKEY:
    .ascii "KEY"
    .byte 0
hl_XKEY:
    .ascii "KEY ( -- c ) next character from the host"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XKEY:
    .quad nm_XKEY, hl_XKEY
    .quad 0
    .quad XKEY, XKEY_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XKEY
    .text
    .p2align 2
XKEY:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x1, :got:key_fn
    ldr x1, [x1, :got_lo12:key_fn]
    ldr x1, [x1]
    cbz x1, _key_none
    blr x1
    b _key_push
_key_none:
    mov x0, #0
_key_push:
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    mov x20, x0
XKEY_END:
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
nm_XEKEY:
    .ascii "EKEY"
    .byte 0
hl_XEKEY:
    .ascii "EKEY ( -- u ) next key event"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XEKEY:
    .quad nm_XEKEY, hl_XEKEY
    .quad 0
    .quad XEKEY, XEKEY_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XEKEY
    .text
    .p2align 2
XEKEY:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _getchar
    adrp x1, :got:debug_busy
    ldr x1, [x1, :got_lo12:debug_busy]
    ldr x1, [x1]
    cbz x1, ekey_push
    mov x28, #0
ekey_push:
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    mov x20, x0
XEKEY_END:
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
nm_XKEYQ:
    .ascii "KEY?"
    .byte 0
hl_XKEYQ:
    .ascii "KEY? ( -- flag ) true if a key is waiting"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XKEYQ:
    .quad nm_XKEYQ, hl_XKEYQ
    .quad 0
    .quad XKEYQ, XKEYQ_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XKEYQ
    .text
    .p2align 2
XKEYQ:
    str x20, [x22, #-8]!
    mov x20, #0
XKEYQ_END:
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
nm_XFIND:
    .ascii "FIND"
    .byte 0
hl_XFIND:
    .ascii "FIND ( c-addr -- c-addr 0 | xt 1 | xt -1 ) find a counted name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFIND:
    .quad nm_XFIND, hl_XFIND
    .quad 0
    .quad XFIND, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFIND
    .text
    .p2align 2
XFIND:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x2, x20
    ldrb w1, [x2]
    add x0, x2, #1
    bl _find_word
    cbz x0, _xfind_not
    tbnz x1, #63, _xfind_imm
    mov x4, #-1
    b _xfind_flag
_xfind_imm:
    mov x4, #1
_xfind_flag:
    mov x20, x0
    str x20, [x22, #-8]!
    mov x20, x4
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
_xfind_not:
    str x20, [x22, #-8]!
    mov x20, #0
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
nm_XTICK:
    .ascii "'"
    .byte 0
hl_XTICK:
    .ascii "' ( name -- xt ) xt of the next name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTICK:
    .quad nm_XTICK, hl_XTICK
    .quad 0
    .quad XTICK, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTICK
    .text
    .p2align 2
XTICK:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    bl _next_word
    cbz x1, _tick_fail
    stp x0, x1, [sp, #48]
    bl _find_word
    cbz x0, _tick_fail
    str x20, [x22, #-8]!
    mov x20, x0
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
_tick_fail:
    ldp x0, x1, [sp, #48]
    cbz x1, _tick_mark
    bl emit_str
_tick_mark:
    adrp x0, :got:msg_huh
    ldr x0, [x0, :got_lo12:msg_huh]
    bl emit_cstr
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    b _quit_exit
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XEXECUTE:
    .ascii "EXECUTE"
    .byte 0
hl_XEXECUTE:
    .ascii "EXECUTE ( xt -- ) run the word at xt"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XEXECUTE:
    .quad nm_XEXECUTE, hl_XEXECUTE
    .quad 0
    .quad XEXECUTE, XEXECUTE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XEXECUTE
    .text
    .p2align 2
XEXECUTE:
    mov x21, x20
    adrp x0, :got:data_stack
    ldr x0, [x0, :got_lo12:data_stack]
    add x0, x0, #1, lsl #12
    cmp x22, x0
    b.hs _exec_empty
    ldr x20, [x22], #8
    b _exec_go
_exec_empty:
    mov x20, #0
_exec_go:
    ldr x1, [x21]
    br x1
XEXECUTE_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XLITERAL:
    .ascii "LITERAL"
    .byte 0
hl_XLITERAL:
    .ascii "LITERAL ( x -- ) compile x as a literal"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLITERAL:
    .quad nm_XLITERAL, hl_XLITERAL
    .word 0, 2147483648
    .quad XLITERAL, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLITERAL
    .text
    .p2align 2
XLITERAL:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    str x20, [sp, #48]
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    ldr x0, [sp, #48]
    bl _compile_cell
    ldr x20, [x22], #8
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
nm_XTOIN:
    .ascii ">IN"
    .byte 0
hl_XTOIN:
    .ascii ">IN ( -- addr ) input offset from the source base"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTOIN:
    .quad nm_XTOIN, hl_XTOIN
    .quad 0
    .quad XTOIN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTOIN
    .text
    .p2align 2
XTOIN:
    str x20, [x22, #-8]!
    adrp x0, :got:to_in
    ldr x0, [x0, :got_lo12:to_in]
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
nm_XPARSE_NAME:
    .ascii "PARSE-NAME"
    .byte 0
hl_XPARSE_NAME:
    .ascii "PARSE-NAME ( -- c-addr u ) next blank-delimited name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPARSE_NAME:
    .quad nm_XPARSE_NAME, hl_XPARSE_NAME
    .quad 0
    .quad XPARSE_NAME, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPARSE_NAME
    .text
    .p2align 2
XPARSE_NAME:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _parse_name_raw
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    mov x20, x2
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
_block_load_nr:
    stp x29, x30, [sp, #-32]!
    str x19, [sp, #16]
    mov x19, x0
    adrp x0, :got:block_nr
    ldr x0, [x0, :got_lo12:block_nr]
    str x19, [x0]
    adrp x0, :got:block_file
    ldr x0, [x0, :got_lo12:block_file]
    ldr x0, [x0]
    cbz x0, _bln_blank
    lsl x1, x19, #10
    mov x2, #0
    bl host_repos
    cbnz x0, _bln_blank
    adrp x0, :got:block_buf
    ldr x0, [x0, :got_lo12:block_buf]
    mov x1, #1024
    adrp x2, :got:block_file
    ldr x2, [x2, :got_lo12:block_file]
    ldr x2, [x2]
    bl host_read
    cmp x0, #0
    b.lt _bln_blank
    cmp x0, #1024
    b.hs _bln_done
    adrp x1, :got:block_buf
    ldr x1, [x1, :got_lo12:block_buf]
    add x1, x1, x0
    mov x2, #1024
    sub x2, x2, x0
    mov w3, #32
_bln_pad:
    cbz x2, _bln_done
    strb w3, [x1], #1
    sub x2, x2, #1
    b _bln_pad
_bln_blank:
    adrp x0, :got:block_buf
    ldr x0, [x0, :got_lo12:block_buf]
    mov x1, #1024
    mov w2, #32
_bln_fill:
    cbz x1, _bln_done
    strb w2, [x0], #1
    sub x1, x1, #1
    b _bln_fill
_bln_done:
    adrp x0, :got:block_upd
    ldr x0, [x0, :got_lo12:block_upd]
    str xzr, [x0]
    ldr x19, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XREFILL:
    .ascii "REFILL"
    .byte 0
hl_XREFILL:
    .ascii "REFILL ( -- flag ) next line when a file is the source"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XREFILL:
    .quad nm_XREFILL, hl_XREFILL
    .quad 0
    .quad XREFILL, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XREFILL
    .text
    .p2align 2
XREFILL:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
    ldr x0, [x0]
    cbnz x0, _refill_block
    adrp x0, :got:line_mode
    ldr x0, [x0, :got_lo12:line_mode]
    ldr x0, [x0]
    cbz x0, _refill_no
    bl _take_line
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    cmp x0, #0
    csetm x20, ne
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_refill_no:
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    mov x20, #0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_refill_block:
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
    ldr x1, [x0]
    add x1, x1, #1
    str x1, [x0]
    mov x0, x1
    bl _block_load_nr
    adrp x0, :got:block_buf
    ldr x0, [x0, :got_lo12:block_buf]
    adrp x2, :got:source_base
    ldr x2, [x2, :got_lo12:source_base]
    str x0, [x2]
    adrp x2, :got:source_cur
    ldr x2, [x2, :got_lo12:source_cur]
    str x0, [x2]
    add x0, x0, #1024
    adrp x2, :got:source_end
    ldr x2, [x2, :got_lo12:source_end]
    str x0, [x2]
    adrp x2, :got:to_in
    ldr x2, [x2, :got_lo12:to_in]
    str xzr, [x2]
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    mov x20, #-1
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
nm_XEXIT_ADDR:
    .ascii "EXIT-ADDR"
    .byte 0
hl_XEXIT_ADDR:
    .ascii "EXIT-ADDR ( -- xt ) xt of EXIT"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XEXIT_ADDR:
    .quad nm_XEXIT_ADDR, hl_XEXIT_ADDR
    .quad 0
    .quad XEXIT_ADDR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XEXIT_ADDR
    .text
    .p2align 2
XEXIT_ADDR:
    adrp x0, :got:cfa_exit
    ldr x0, [x0, :got_lo12:cfa_exit]
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
nm_XSLIT_ADDR:
    .ascii "SLIT-ADDR"
    .byte 0
hl_XSLIT_ADDR:
    .ascii "SLIT-ADDR ( -- xt ) xt of the compiled string runtime"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSLIT_ADDR:
    .quad nm_XSLIT_ADDR, hl_XSLIT_ADDR
    .quad 0
    .quad XSLIT_ADDR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSLIT_ADDR
    .text
    .p2align 2
XSLIT_ADDR:
    adrp x0, :got:cfa_slit
    ldr x0, [x0, :got_lo12:cfa_slit]
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
nm_XDOTQ:
    .ascii "."
    .byte 34
    .byte 0
hl_XDOTQ:
    .ascii "."
    .byte 34
    .ascii "print text until a quote"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOTQ:
    .quad nm_XDOTQ, hl_XDOTQ
    .word 0, 2147483648
    .quad XDOTQ, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOTQ
    .text
    .p2align 2
XDOTQ:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    bl _cursor_load
    mov x9, x0
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x6, [x3]
    mov x1, x9
_dq_scan:
    cmp x1, x6
    b.hs _dq_len
    ldrb w3, [x1]
    cbz w3, _dq_len
    cmp w3, #34
    b.eq _dq_hit
    add x1, x1, #1
    b _dq_scan
_dq_hit:
    sub x5, x1, x9
    add x1, x1, #1
    b _dq_commit
_dq_len:
    sub x5, x1, x9
_dq_commit:
    mov x0, x1
    bl _cursor_commit
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    ldr x0, [x0]
    cbnz x0, _dq_comp
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
    str x20, [x22, #-8]!
    mov x20, x9
    str x20, [x22, #-8]!
    mov x20, x5
    b XTYPE
_dq_comp:
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
_dq_cpy:
    cmp x3, x5
    b.ge _dq_align
    ldrb w4, [x9, x3]
    strb w4, [x1, x3]
    add x3, x3, #1
    b _dq_cpy
_dq_align:
    add x1, x1, x5
    add x1, x1, #7
    bic x1, x1, #7
    str x1, [x0]
    adrp x0, :got:str_type
    ldr x0, [x0, :got_lo12:str_type]
    mov x1, #4
    bl _find_word
    cbz x0, _dq_fail
    bl _compile_cell
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
_dq_fail:
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
    b _quit_exit
_parse_name_raw:
    stp x29, x30, [sp, #-16]!
    bl _cursor_load
    mov x2, x0
    adrp x9, :got:source_end
    ldr x9, [x9, :got_lo12:source_end]
    ldr x9, [x9]
_pn_skip:
    cmp x2, x9
    b.hs _pn_empty
    ldrb w4, [x2]
    cbz w4, _pn_empty
    cmp w4, #32
    b.eq _pn_sk
    cmp w4, #9
    b.eq _pn_sk
    cmp w4, #10
    b.eq _pn_sk
    cmp w4, #13
    b.eq _pn_sk
    b _pn_start
_pn_sk:
    add x2, x2, #1
    b _pn_skip
_pn_start:
    mov x3, x2
_pn_scan:
    cmp x2, x9
    b.hs _pn_end
    ldrb w4, [x2]
    cbz w4, _pn_end
    cmp w4, #32
    b.eq _pn_end
    cmp w4, #9
    b.eq _pn_end
    cmp w4, #10
    b.eq _pn_end
    cmp w4, #13
    b.eq _pn_end
    add x2, x2, #1
    b _pn_scan
_pn_end:
    sub x5, x2, x3
    cmp x2, x9
    b.hs _pn_commit
    ldrb w4, [x2]
    cbz w4, _pn_commit
    add x2, x2, #1
_pn_commit:
    mov x0, x2
    mov x2, x3
    bl _cursor_commit
    ldp x29, x30, [sp], #16
    ret
_pn_empty:
    mov x0, x2
    bl _cursor_commit
    mov x2, x0
    mov x5, #0
    ldp x29, x30, [sp], #16
    ret
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XTO_IMM:
    .ascii "TO"
    .byte 0
hl_XTO_IMM:
    .ascii "TO ( x name -- ) store into a VALUE or DEFER"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTO_IMM:
    .quad nm_XTO_IMM, hl_XTO_IMM
    .word 0, 2147483648
    .quad XTO_IMM, XTO_IMM_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTO_IMM
    .text
    .p2align 2
XTO_IMM:
    sub sp, sp, #128
    stp x29, x30, [sp, #32]
    bl _next_word
    cbz x1, _to_fail
    stp x0, x1, [sp, #48]
    adrp x2, :got:state_var
    ldr x2, [x2, :got_lo12:state_var]
    ldr x2, [x2]
    cbz x2, _to_interp
    ldp x0, x1, [sp, #48]
    bl _local_lookup
    cmp x0, #-1
    b.eq _to_compile_value
    str x0, [sp, #96]
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    ldr x0, [sp, #96]
    bl _compile_cell
    adrp x0, :got:cfa_local_store
    ldr x0, [x0, :got_lo12:cfa_local_store]
    ldr x0, [x0]
    bl _compile_cell
    b _to_leave
_to_compile_value:
    ldp x0, x1, [sp, #48]
    bl _find_word
    cbz x0, _to_fail
    add x0, x0, #16
    str x0, [sp, #64]
    ldr x1, [x0, #-8]
    cbz x1, _to_bang
    ldr x3, [x1]
    str x3, [sp, #72]
    adrp x0, :got:str_twofetch
    ldr x0, [x0, :got_lo12:str_twofetch]
    mov x1, #2
    bl _find_word
    ldr x3, [sp, #72]
    cmp x0, x3
    b.ne _to_bang
    adrp x0, :got:str_twostore
    ldr x0, [x0, :got_lo12:str_twostore]
    mov x1, #2
    b _to_plant
_to_bang:
    adrp x0, :got:str_bang
    ldr x0, [x0, :got_lo12:str_bang]
    mov x1, #1
_to_plant:
    stp x0, x1, [sp, #80]
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    ldr x0, [sp, #64]
    bl _compile_cell
    ldp x0, x1, [sp, #80]
    bl _find_word
    cbz x0, _to_fail
    bl _compile_cell
    b _to_leave
_to_interp:
    ldp x0, x1, [sp, #48]
    bl _find_word
    cbz x0, _to_fail
    add x0, x0, #16
    adrp x3, :got:data_stack
    ldr x3, [x3, :got_lo12:data_stack]
    add x3, x3, #1, lsl #12
    mov x4, x3
    sub x3, x3, x22
    lsr x3, x3, #3
    cmp x3, #2
    b.lo _to_one
    str x20, [x0]
    ldr x1, [x22], #8
    str x1, [x0, #8]
    b _to_pop
_to_one:
    str x20, [x0]
_to_pop:
    cmp x22, x4
    b.hs _to_empty
    ldr x20, [x22], #8
    b _to_leave
_to_empty:
    mov x20, #0
_to_leave:
    ldp x29, x30, [sp, #32]
    add sp, sp, #128
XTO_IMM_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_to_fail:
    ldp x29, x30, [sp, #32]
    add sp, sp, #128
    adrp x0, :got:msg_huh
    ldr x0, [x0, :got_lo12:msg_huh]
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl emit_cstr
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    b _quit_exit
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XCOMPARE:
    .ascii "COMPARE"
    .byte 0
hl_XCOMPARE:
    .ascii "COMPARE ( c-addr1 u1 c-addr2 u2 -- n ) -1 0 or 1"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCOMPARE:
    .quad nm_XCOMPARE, hl_XCOMPARE
    .quad 0
    .quad XCOMPARE, XCOMPARE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCOMPARE
    .text
    .p2align 2
XCOMPARE:
    mov x3, x20
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    cmp x1, x3
    csel x4, x1, x3, lo
    mov x5, #0
_cmp_loop:
    cmp x5, x4
    b.hs _cmp_len
    ldrb w6, [x0, x5]
    ldrb w7, [x2, x5]
    cmp w6, w7
    b.ne _cmp_diff
    add x5, x5, #1
    b _cmp_loop
_cmp_diff:
    mov x20, #1
    b.hi XCOMPARE_END
    mov x20, #-1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_cmp_len:
    cmp x1, x3
    b.eq _cmp_eq
    mov x20, #1
    b.hi XCOMPARE_END
    mov x20, #-1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_cmp_eq:
    mov x20, #0
XCOMPARE_END:
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
nm_XLATEST:
    .ascii "LATEST"
    .byte 0
hl_XLATEST:
    .ascii "LATEST ( -- addr ) FORTH wordlist head array"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLATEST:
    .quad nm_XLATEST, hl_XLATEST
    .quad 0
    .quad XLATEST, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLATEST
    .text
    .p2align 2
XLATEST:
    str x20, [x22, #-8]!
    adrp x0, :got:latest_var
    ldr x0, [x0, :got_lo12:latest_var]
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
nm_XFORTH_WORDLIST:
    .ascii "FORTH-WORDLIST"
    .byte 0
hl_XFORTH_WORDLIST:
    .ascii "FORTH-WORDLIST ( -- wid ) main FORTH word list"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFORTH_WORDLIST:
    .quad nm_XFORTH_WORDLIST, hl_XFORTH_WORDLIST
    .quad 0
    .quad XFORTH_WORDLIST, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFORTH_WORDLIST
    .text
    .p2align 2
XFORTH_WORDLIST:
    str x20, [x22, #-8]!
    adrp x0, :got:latest_var
    ldr x0, [x0, :got_lo12:latest_var]
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
nm_XWORDLISTS:
    .ascii "WORDLISTS"
    .byte 0
hl_XWORDLISTS:
    .ascii "WORDLISTS ( -- addr n ) registered wordlist table"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XWORDLISTS:
    .quad nm_XWORDLISTS, hl_XWORDLISTS
    .quad 0
    .quad XWORDLISTS, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XWORDLISTS
    .text
    .p2align 2
XWORDLISTS:
    str x20, [x22, #-8]!
    adrp x0, :got:wordlist_reg
    ldr x0, [x0, :got_lo12:wordlist_reg]
    str x0, [x22, #-8]!
    adrp x0, :got:wordlist_reg_n
    ldr x0, [x0, :got_lo12:wordlist_reg_n]
    ldr x20, [x0]
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
nm_XALSO:
    .ascii "ALSO"
    .byte 0
hl_XALSO:
    .ascii "ALSO ( -- ) duplicate the first search-order entry"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XALSO:
    .quad nm_XALSO, hl_XALSO
    .quad 0
    .quad XALSO, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XALSO
    .text
    .p2align 2
XALSO:
    adrp x0, :got:search_order_n
    ldr x0, [x0, :got_lo12:search_order_n]
    ldr x1, [x0]
    cbz x1, _also_done
    cmp x1, #8
    b.hs _also_done
    adrp x2, :got:search_order
    ldr x2, [x2, :got_lo12:search_order]
    ldr x3, [x2]
    mov x4, x1
_also_shift:
    cbz x4, _also_put
    sub x4, x4, #1
    ldr x5, [x2, x4, lsl #3]
    add x6, x4, #1
    str x5, [x2, x6, lsl #3]
    b _also_shift
_also_put:
    str x3, [x2]
    add x1, x1, #1
    str x1, [x0]
_also_done:
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
nm_XREDEF_WARNING:
    .ascii "REDEF-WARNING"
    .byte 0
hl_XREDEF_WARNING:
    .ascii "REDEF-WARNING ( -- addr ) nonzero warns on redefine"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XREDEF_WARNING:
    .quad nm_XREDEF_WARNING, hl_XREDEF_WARNING
    .quad 0
    .quad XREDEF_WARNING, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XREDEF_WARNING
    .text
    .p2align 2
XREDEF_WARNING:
    str x20, [x22, #-8]!
    adrp x0, :got:redef_warn
    ldr x0, [x0, :got_lo12:redef_warn]
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
nm_XTRAVERSE_WORDLIST:
    .ascii "TRAVERSE-WORDLIST"
    .byte 0
hl_XTRAVERSE_WORDLIST:
    .ascii "TRAVERSE-WORDLIST ( i*x xt wid -- j*x ) visit each name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTRAVERSE_WORDLIST:
    .quad nm_XTRAVERSE_WORDLIST, hl_XTRAVERSE_WORDLIST
    .quad 0
    .quad XTRAVERSE_WORDLIST, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTRAVERSE_WORDLIST
    .text
    .p2align 2
XTRAVERSE_WORDLIST:
    mov x5, x20
    ldr x6, [x22], #8
    ldr x20, [x22], #8
    str x19, [x23, #-8]!
    str x5, [x23, #-8]!
    mov x7, #0
    str x7, [x23, #-8]!
    str x6, [x23, #-8]!
    ldr x7, [x5]
_tw_loop:
    cbz x7, _tw_advance
    ldr x8, [x7, #-16]
    ldr x0, [x7, #-8]
    and x0, x0, #0xFFFF
    sub x0, x7, x0
    ldrb w0, [x0]
    tst w0, #0x80
    b.ne _tw_skip
    and w0, w0, #0x7F
    cbz w0, _tw_skip
    ldr x6, [x23]
    str x8, [x23, #-8]!
    str x20, [x22, #-8]!
    mov x20, x7
    mov x21, x6
    adrp x19, :got:tw_continue_cell
    ldr x19, [x19, :got_lo12:tw_continue_cell]
    ldr x1, [x21]
    br x1
_tw_skip:
    mov x7, x8
    b _tw_loop
_tw_advance:
    ldr x6, [x23], #8
    ldr x7, [x23], #8
    ldr x5, [x23], #8
    add x7, x7, #1
    cmp x7, #16
    b.hs _tw_done
    str x5, [x23, #-8]!
    str x7, [x23, #-8]!
    str x6, [x23, #-8]!
    add x0, x5, x7, lsl #3
    ldr x7, [x0]
    b _tw_loop
_tw_done:
    ldr x19, [x23], #8
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
XTW_CONTINUE:
    ldr x8, [x23], #8
    ldr x6, [x23]
    cbz x20, _tw_stop
    ldr x20, [x22], #8
    mov x7, x8
    cbz x7, _tw_advance
    b _tw_loop
_tw_stop:
    ldr x20, [x22], #8
    ldr x6, [x23], #8
    ldr x7, [x23], #8
    ldr x5, [x23], #8
    ldr x19, [x23], #8
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
nm_XCATCH:
    .ascii "CATCH"
    .byte 0
hl_XCATCH:
    .ascii "CATCH ( xt -- n ) run xt and push 0 or the throw code"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCATCH:
    .quad nm_XCATCH, hl_XCATCH
    .quad 0
    .quad XCATCH, XCATCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCATCH
    .text
    .p2align 2
XCATCH:
    mov x5, x20
    adrp x0, :got:data_stack
    ldr x0, [x0, :got_lo12:data_stack]
    add x0, x0, #1, lsl #12
    cmp x22, x0
    b.hs _catch_empty
    ldr x20, [x22], #8
    b _catch_save
_catch_empty:
    mov x20, #0
_catch_save:
    adrp x7, :got:throw_handler
    ldr x7, [x7, :got_lo12:throw_handler]
    ldr x2, [x7]
    adrp x3, :got:eval_resume_sp
    ldr x3, [x3, :got_lo12:eval_resume_sp]
    ldr x3, [x3]
    str x3, [x23, #-8]!
    str x2, [x23, #-8]!
    str x20, [x23, #-8]!
    str x22, [x23, #-8]!
    adrp x2, :got:source_sp
    ldr x2, [x2, :got_lo12:source_sp]
    ldr x2, [x2]
    str x2, [x23, #-8]!
    str x19, [x23, #-8]!
    str x23, [x7]
    adrp x19, :got:catch_ok_cell
    ldr x19, [x19, :got_lo12:catch_ok_cell]
    mov x21, x5
    ldr x1, [x21]
    br x1
XCATCH_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XCATCH_OK:
    .ascii "(CATCH-OK)"
    .byte 0
hl_XCATCH_OK:
    .ascii "(CATCH-OK) ( -- 0 ) CATCH success path"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCATCH_OK:
    .quad nm_XCATCH_OK, hl_XCATCH_OK
    .quad 0
    .quad XCATCH_OK, XCATCH_OK_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCATCH_OK
    .text
    .p2align 2
XCATCH_OK:
    adrp x7, :got:throw_handler
    ldr x7, [x7, :got_lo12:throw_handler]
    ldr x1, [x7]
    cbz x1, _cok_push
    mov x23, x1
    ldr x19, [x23], #8
    add x23, x23, #24
    ldr x0, [x23], #8
    str x0, [x7]
    add x23, x23, #8
_cok_push:
    str x20, [x22, #-8]!
    mov x20, #0
XCATCH_OK_END:
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
nm_XXC_STORE_PLUS:
    .ascii "XC!+"
    .byte 0
hl_XXC_STORE_PLUS:
    .ascii "XC!+ ( xchar xc-addr1 -- xc-addr2 ) store one UTF-8 xchar"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XXC_STORE_PLUS:
    .quad nm_XXC_STORE_PLUS, hl_XXC_STORE_PLUS
    .quad 0
    .quad XXC_STORE_PLUS, XXC_STORE_PLUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XXC_STORE_PLUS
    .text
    .p2align 2
XXC_STORE_PLUS:
    mov x0, x20
    ldr x1, [x22], #8
    movz x2, #0xFFFF
    movk x2, #0x10, lsl #16
    cmp x1, x2
    csel x1, x2, x1, hi
    cmp x1, #0x7F
    b.ls _xcsp_1
    cmp x1, #0x7FF
    b.ls _xcsp_2
    movz x2, #0xFFFF
    cmp x1, x2
    b.ls _xcsp_3
    lsr x2, x1, #18
    orr w2, w2, #0xF0
    strb w2, [x0], #1
    lsr x2, x1, #12
    and w2, w2, #0x3F
    orr w2, w2, #0x80
    strb w2, [x0], #1
    lsr x2, x1, #6
    and w2, w2, #0x3F
    orr w2, w2, #0x80
    strb w2, [x0], #1
    and w2, w1, #0x3F
    orr w2, w2, #0x80
    strb w2, [x0], #1
    mov x20, x0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_xcsp_3:
    lsr x2, x1, #12
    orr w2, w2, #0xE0
    strb w2, [x0], #1
    lsr x2, x1, #6
    and w2, w2, #0x3F
    orr w2, w2, #0x80
    strb w2, [x0], #1
    and w2, w1, #0x3F
    orr w2, w2, #0x80
    strb w2, [x0], #1
    mov x20, x0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_xcsp_2:
    lsr x2, x1, #6
    orr w2, w2, #0xC0
    strb w2, [x0], #1
    and w2, w1, #0x3F
    orr w2, w2, #0x80
    strb w2, [x0], #1
    mov x20, x0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_xcsp_1:
    strb w1, [x0], #1
    mov x20, x0
XXC_STORE_PLUS_END:
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
nm_XXC_FETCH_PLUS:
    .ascii "XC@+"
    .byte 0
hl_XXC_FETCH_PLUS:
    .ascii "XC@+ ( xc-addr1 -- xc-addr2 xchar ) fetch one UTF-8 xchar"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XXC_FETCH_PLUS:
    .quad nm_XXC_FETCH_PLUS, hl_XXC_FETCH_PLUS
    .quad 0
    .quad XXC_FETCH_PLUS, XXC_FETCH_PLUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XXC_FETCH_PLUS
    .text
    .p2align 2
XXC_FETCH_PLUS:
    mov x0, x20
    ldrb w1, [x0], #1
    cmp w1, #0x80
    b.lo _xcfp_1
    cmp w1, #0xE0
    b.lo _xcfp_2
    cmp w1, #0xF0
    b.lo _xcfp_3
    and w2, w1, #0x07
    ldrb w3, [x0], #1
    and w3, w3, #0x3F
    lsl w2, w2, #6
    orr w2, w2, w3
    ldrb w3, [x0], #1
    and w3, w3, #0x3F
    lsl w2, w2, #6
    orr w2, w2, w3
    ldrb w3, [x0], #1
    and w3, w3, #0x3F
    lsl w2, w2, #6
    orr w2, w2, w3
    str x0, [x22, #-8]!
    mov x20, x2
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_xcfp_3:
    and w2, w1, #0x0F
    ldrb w3, [x0], #1
    and w3, w3, #0x3F
    lsl w2, w2, #6
    orr w2, w2, w3
    ldrb w3, [x0], #1
    and w3, w3, #0x3F
    lsl w2, w2, #6
    orr w2, w2, w3
    str x0, [x22, #-8]!
    mov x20, x2
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_xcfp_2:
    and w2, w1, #0x1F
    ldrb w3, [x0], #1
    and w3, w3, #0x3F
    lsl w2, w2, #6
    orr w2, w2, w3
    str x0, [x22, #-8]!
    mov x20, x2
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_xcfp_1:
    str x0, [x22, #-8]!
    mov x20, x1
XXC_FETCH_PLUS_END:
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
nm_XBOOT_WORD_TABLE:
    .ascii "BOOT-WORD-TABLE"
    .byte 0
hl_XBOOT_WORD_TABLE:
    .ascii "BOOT-WORD-TABLE ( -- addr ) start of the boot-word pointer table"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBOOT_WORD_TABLE:
    .quad nm_XBOOT_WORD_TABLE, hl_XBOOT_WORD_TABLE
    .quad 0
    .quad XBOOT_WORD_TABLE, XBOOT_WORD_TABLE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBOOT_WORD_TABLE
    .text
    .p2align 2
XBOOT_WORD_TABLE:
    str x20, [x22, #-8]!
    adrp x20, :got:bootptr_start
    ldr x20, [x20, :got_lo12:bootptr_start]
XBOOT_WORD_TABLE_END:
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
nm_XBW_TABLE_LIM:
    .ascii "BOOT-WORD-TABLE-END"
    .byte 0
hl_XBW_TABLE_LIM:
    .ascii "BOOT-WORD-TABLE-END ( -- addr ) end of the boot-word pointer table"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBW_TABLE_LIM:
    .quad nm_XBW_TABLE_LIM, hl_XBW_TABLE_LIM
    .quad 0
    .quad XBW_TABLE_LIM, XBW_TABLE_LIM_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBW_TABLE_LIM
    .text
    .p2align 2
XBW_TABLE_LIM:
    str x20, [x22, #-8]!
    adrp x20, :got:bootptr_end
    ldr x20, [x20, :got_lo12:bootptr_end]
XBW_TABLE_LIM_END:
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
nm_XFLIT:
    .ascii "FLIT"
    .byte 0
hl_XFLIT:
    .ascii "FLIT ( -- ) push the inline float bits"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFLIT:
    .quad nm_XFLIT, hl_XFLIT
    .quad 0
    .quad XFLIT, XFLIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFLIT
    .text
    .p2align 2
XFLIT:
    ldr x1, [x19], #8
    mov x0, #101
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    bl _float_op_call
XFLIT_END:
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
nm_XFLIT_ADDR:
    .ascii "FLIT-ADDR"
    .byte 0
hl_XFLIT_ADDR:
    .ascii "FLIT-ADDR ( -- xt ) xt of FLIT"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFLIT_ADDR:
    .quad nm_XFLIT_ADDR, hl_XFLIT_ADDR
    .quad 0
    .quad XFLIT_ADDR, XFLIT_ADDR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFLIT_ADDR
    .text
    .p2align 2
XFLIT_ADDR:
    adrp x0, :got:cfa_flit
    ldr x0, [x0, :got_lo12:cfa_flit]
    ldr x0, [x0]
    str x20, [x22, #-8]!
    mov x20, x0
XFLIT_ADDR_END:
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
nm_XFLOAT_OP:
    .ascii "(F-OP)"
    .byte 0
hl_XFLOAT_OP:
    .ascii "(F-OP) ( i*x op -- j*x ) float host multiplex"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFLOAT_OP:
    .quad nm_XFLOAT_OP, hl_XFLOAT_OP
    .quad 0
    .quad XFLOAT_OP, XFLOAT_OP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFLOAT_OP
    .text
    .p2align 2
XFLOAT_OP:
    mov x9, x20
    ldr x20, [x22], #8
    mov x1, #0
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    cmp x9, #22
    b.eq _fo_a1
    cmp x9, #23
    b.eq _fo_a1
    cmp x9, #24
    b.eq _fo_a1
    cmp x9, #25
    b.eq _fo_a1
    cmp x9, #26
    b.eq _fo_a1
    cmp x9, #27
    b.eq _fo_a1
    cmp x9, #28
    b.eq _fo_a1
    cmp x9, #37
    b.eq _fo_a1
    cmp x9, #39
    b.eq _fo_a1
    cmp x9, #40
    b.eq _fo_a1
    cmp x9, #41
    b.eq _fo_a1
    cmp x9, #42
    b.eq _fo_a1
    cmp x9, #43
    b.eq _fo_a1
    cmp x9, #44
    b.eq _fo_a1
    cmp x9, #70
    b.eq _fo_a1
    cmp x9, #71
    b.eq _fo_a1
    cmp x9, #72
    b.eq _fo_a1
    cmp x9, #73
    b.eq _fo_a1
    cmp x9, #74
    b.eq _fo_a1
    cmp x9, #75
    b.eq _fo_a1
    cmp x9, #30
    b.eq _fo_d2
    cmp x9, #32
    b.eq _fo_cu
    cmp x9, #38
    b.eq _fo_cu
    b _fo_go
_fo_a1:
    mov x1, x20
    ldr x20, [x22], #8
    b _fo_go
_fo_d2:
    mov x2, x20
    ldr x1, [x22], #8
    ldr x20, [x22], #8
    b _fo_go
_fo_cu:
    mov x2, x20
    ldr x5, [x22], #8
    ldr x20, [x22], #8
_fo_go:
    str x9, [x23, #-8]!
    mov x0, x9
    bl _float_op_call
    ldr x9, [x23], #8
    cmp x9, #31
    b.eq _fo_push2
    cmp x9, #38
    b.eq _fo_push3
    cmp x9, #1
    b.eq _fo_push1
    cmp x9, #15
    b.eq _fo_push1
    cmp x9, #16
    b.eq _fo_push1
    cmp x9, #17
    b.eq _fo_push1
    cmp x9, #18
    b.eq _fo_push1
    cmp x9, #19
    b.eq _fo_push1
    cmp x9, #20
    b.eq _fo_push1
    cmp x9, #21
    b.eq _fo_push1
    cmp x9, #29
    b.eq _fo_push1
    cmp x9, #32
    b.eq _fo_push1
    cmp x9, #36
    b.eq _fo_push1
    cmp x9, #39
    b.eq _fo_push1
    cmp x9, #40
    b.eq _fo_push1
    cmp x9, #41
    b.eq _fo_push1
    cmp x9, #42
    b.eq _fo_push1
    cmp x9, #43
    b.eq _fo_push1
    cmp x9, #44
    b.eq _fo_push1
    cmp x9, #70
    b.eq _fo_push1
    cmp x9, #71
    b.eq _fo_push1
    cmp x9, #72
    b.eq _fo_push1
    cmp x9, #73
    b.eq _fo_push1
    cmp x9, #74
    b.eq _fo_push1
    cmp x9, #75
    b.eq _fo_push1
    cmp x9, #102
    b.eq _fo_push1
    b _fo_none
_fo_push1:
    str x20, [x22, #-8]!
    mov x20, x6
    b _fo_none
_fo_push2:
    str x20, [x22, #-8]!
    str x6, [x22, #-8]!
    mov x20, x7
    b _fo_none
_fo_push3:
    str x20, [x22, #-8]!
    str x6, [x22, #-8]!
    str x7, [x22, #-8]!
    mov x20, x8
_fo_none:
XFLOAT_OP_END:
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
nm_XLOCAL_PAREN:
    .ascii "(LOCAL)"
    .byte 0
hl_XLOCAL_PAREN:
    .ascii "(LOCAL) ( c-addr u -- ) declare a local or end the local list"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_PAREN:
    .quad nm_XLOCAL_PAREN, hl_XLOCAL_PAREN
    .quad 0
    .quad XLOCAL_PAREN, XLOCAL_PAREN_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_PAREN
    .text
    .p2align 2
XLOCAL_PAREN:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    ldr x0, [x0]
    cbz x0, _lp_leave
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    cbz x1, _lp_last
    adrp x2, :got:local_declaring
    ldr x2, [x2, :got_lo12:local_declaring]
    ldr x3, [x2]
    cbnz x3, _lp_add
    stp x0, x1, [sp, #-16]!
    bl _local_compile_reset
    ldp x0, x1, [sp], #16
    adrp x3, :got:local_init_reverse
    ldr x3, [x3, :got_lo12:local_init_reverse]
    str xzr, [x3]
    mov x3, #1
    adrp x2, :got:local_declaring
    ldr x2, [x2, :got_lo12:local_declaring]
    str x3, [x2]
_lp_add:
    bl _local_add_name
    adrp x2, :got:local_init_count
    ldr x2, [x2, :got_lo12:local_init_count]
    ldr x3, [x2]
    add x3, x3, #1
    str x3, [x2]
    b _lp_leave
_lp_last:
    adrp x2, :got:local_declaring
    ldr x2, [x2, :got_lo12:local_declaring]
    ldr x3, [x2]
    cbnz x3, _lp_fin
    bl _local_compile_reset
    adrp x3, :got:local_init_reverse
    ldr x3, [x3, :got_lo12:local_init_reverse]
    str xzr, [x3]
_lp_fin:
    bl _local_finalize_compile
    adrp x2, :got:local_declaring
    ldr x2, [x2, :got_lo12:local_declaring]
    str xzr, [x2]
_lp_leave:
    ldp x29, x30, [sp], #16
XLOCAL_PAREN_END:
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
nm_XTEXTEDIT:
    .ascii "TEXTEDIT"
    .byte 0
hl_XTEXTEDIT:
    .ascii "TEXTEDIT ( -- ) open the next file name in the editor"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTEXTEDIT:
    .quad nm_XTEXTEDIT, hl_XTEXTEDIT
    .quad 0
    .quad XTEXTEDIT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTEXTEDIT
    .text
    .p2align 2
XTEXTEDIT:
    stp x29, x30, [sp, #-16]!
    bl _parse_filespec
    bl host_edit
    ldp x29, x30, [sp], #16
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
nm_XEDIT_AT:
    .ascii "EDIT-AT"
    .byte 0
hl_XEDIT_AT:
    .ascii "EDIT-AT ( c-addr u line -- ) open path at line in the editor"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XEDIT_AT:
    .quad nm_XEDIT_AT, hl_XEDIT_AT
    .quad 0
    .quad XEDIT_AT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XEDIT_AT
    .text
    .p2align 2
XEDIT_AT:
    mov x3, x20
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    adrp x9, :got:data_stack
    ldr x9, [x9, :got_lo12:data_stack]
    add x9, x9, #1, lsl #12
    cmp x22, x9
    b.hs _eat_empty
    ldr x20, [x22], #8
    b _eat_call
_eat_empty:
    mov x20, #0
_eat_call:
    mov x0, x1
    mov x1, x2
    mov x2, x3
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl host_edit_at
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
nm_XSYSTEM:
    .ascii "SYSTEM"
    .byte 0
hl_XSYSTEM:
    .ascii "SYSTEM ( c-addr u -- n ) run a shell command and return the exit code or -1"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSYSTEM:
    .quad nm_XSYSTEM, hl_XSYSTEM
    .quad 0
    .quad XSYSTEM, XSYSTEM_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSYSTEM
    .text
    .p2align 2
XSYSTEM:
    mov x1, x20
    ldr x0, [x22], #8
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl host_system
    str x0, [sp, #48]
    ldp x29, x30, [sp, #32]
    ldr x20, [sp, #48]
    add sp, sp, #64
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
XSYSTEM_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XRO:
    .ascii "R/O"
    .byte 0
hl_XRO:
    .ascii "R/O ( -- fam ) read-only file access method"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRO:
    .quad nm_XRO, hl_XRO
    .quad 0
    .quad XRO, XRO_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRO
    .text
    .p2align 2
XRO:
    str x20, [x22, #-8]!
    mov x20, #1
XRO_END:
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
nm_XRW:
    .ascii "R/W"
    .byte 0
hl_XRW:
    .ascii "R/W ( -- fam ) read-write file access method"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRW:
    .quad nm_XRW, hl_XRW
    .quad 0
    .quad XRW, XRW_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRW
    .text
    .p2align 2
XRW:
    str x20, [x22, #-8]!
    mov x20, #3
XRW_END:
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
nm_XW_O:
    .ascii "W/O"
    .byte 0
hl_XW_O:
    .ascii "W/O ( -- fam ) write-only file access method"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XW_O:
    .quad nm_XW_O, hl_XW_O
    .quad 0
    .quad XW_O, XW_O_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XW_O
    .text
    .p2align 2
XW_O:
    str x20, [x22, #-8]!
    mov x20, #2
XW_O_END:
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
nm_XBIN:
    .ascii "BIN"
    .byte 0
hl_XBIN:
    .ascii "BIN ( fam -- fam ) binary access is the same fam here"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBIN:
    .quad nm_XBIN, hl_XBIN
    .quad 0
    .quad XBIN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBIN
    .text
    .p2align 2
XBIN:
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
nm_XOPEN_FILE:
    .ascii "OPEN-FILE"
    .byte 0
hl_XOPEN_FILE:
    .ascii "OPEN-FILE ( c-addr u fam -- fileid ior ) open an existing file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XOPEN_FILE:
    .quad nm_XOPEN_FILE, hl_XOPEN_FILE
    .quad 0
    .quad XOPEN_FILE, XOPEN_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XOPEN_FILE
    .text
    .p2align 2
XOPEN_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x3, x20
    ldr x2, [x22], #8
    ldr x5, [x22], #8
    mov x0, #1
    mov x1, #0
    mov x4, #0
    bl _file_op_call
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x6, [x22, #-8]!
    mov x20, x0
XOPEN_FILE_END:
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
nm_XCREATE_FILE:
    .ascii "CREATE-FILE"
    .byte 0
hl_XCREATE_FILE:
    .ascii "CREATE-FILE ( c-addr u fam -- fileid ior ) create or truncate a file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCREATE_FILE:
    .quad nm_XCREATE_FILE, hl_XCREATE_FILE
    .quad 0
    .quad XCREATE_FILE, XCREATE_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCREATE_FILE
    .text
    .p2align 2
XCREATE_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x3, x20
    ldr x2, [x22], #8
    ldr x5, [x22], #8
    mov x0, #2
    mov x1, #0
    mov x4, #0
    bl _file_op_call
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x6, [x22, #-8]!
    mov x20, x0
XCREATE_FILE_END:
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
nm_XFILE_SIZE:
    .ascii "FILE-SIZE"
    .byte 0
hl_XFILE_SIZE:
    .ascii "FILE-SIZE ( fileid -- ud ior ) size of an open file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFILE_SIZE:
    .quad nm_XFILE_SIZE, hl_XFILE_SIZE
    .quad 0
    .quad XFILE_SIZE, XFILE_SIZE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFILE_SIZE
    .text
    .p2align 2
XFILE_SIZE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    mov x0, #9
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    bl _file_op_call
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x6, [x22, #-8]!
    str x7, [x22, #-8]!
    mov x20, x0
XFILE_SIZE_END:
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
nm_XCLOSE_FILE:
    .ascii "CLOSE-FILE"
    .byte 0
hl_XCLOSE_FILE:
    .ascii "CLOSE-FILE ( fileid -- ior ) close an open file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCLOSE_FILE:
    .quad nm_XCLOSE_FILE, hl_XCLOSE_FILE
    .quad 0
    .quad XCLOSE_FILE, XCLOSE_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCLOSE_FILE
    .text
    .p2align 2
XCLOSE_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    mov x0, #3
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    bl _file_op_call
    mov x20, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XCLOSE_FILE_END:
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
nm_XALLOCATE:
    .ascii "ALLOCATE"
    .byte 0
hl_XALLOCATE:
    .ascii "ALLOCATE ( u -- a-addr ior ) allocate heap memory"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XALLOCATE:
    .quad nm_XALLOCATE, hl_XALLOCATE
    .quad 0
    .quad XALLOCATE, XALLOCATE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XALLOCATE
    .text
    .p2align 2
XALLOCATE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x0, x20
    bl host_alloc
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    cbz x0, _alloc_fail
    str x0, [x22, #-8]!
    mov x20, #0
    b _alloc_leave
_alloc_fail:
    str xzr, [x22, #-8]!
    mov x20, #-1
_alloc_leave:
XALLOCATE_END:
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
nm_XFREE:
    .ascii "FREE"
    .byte 0
hl_XFREE:
    .ascii "FREE ( a-addr -- ior ) release heap memory"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFREE:
    .quad nm_XFREE, hl_XFREE
    .quad 0
    .quad XFREE, XFREE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFREE
    .text
    .p2align 2
XFREE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x0, x20
    bl host_free
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    mov x20, #0
XFREE_END:
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
nm_XRESIZE:
    .ascii "RESIZE"
    .byte 0
hl_XRESIZE:
    .ascii "RESIZE ( a-addr1 u -- a-addr2 ior ) resize heap memory"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRESIZE:
    .quad nm_XRESIZE, hl_XRESIZE
    .quad 0
    .quad XRESIZE, XRESIZE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRESIZE
    .text
    .p2align 2
XRESIZE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x0, [x22], #8
    str x0, [sp, #48]
    bl host_resize
    ldr x1, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    cbz x0, _resize_fail
    str x0, [x22, #-8]!
    mov x20, #0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_resize_fail:
    str x1, [x22, #-8]!
    mov x20, #-1
XRESIZE_END:
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
nm_XREAD_FILE:
    .ascii "READ-FILE"
    .byte 0
hl_XREAD_FILE:
    .ascii "READ-FILE ( c-addr u1 fileid -- u2 ior ) read from an open file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XREAD_FILE:
    .quad nm_XREAD_FILE, hl_XREAD_FILE
    .quad 0
    .quad XREAD_FILE, XREAD_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XREAD_FILE
    .text
    .p2align 2
XREAD_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x2, [x22], #8
    ldr x5, [x22], #8
    mov x0, #4
    mov x3, #0
    mov x4, #0
    bl _file_op_call
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x6, [x22, #-8]!
    mov x20, x0
XREAD_FILE_END:
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
nm_XWRITE_FILE:
    .ascii "WRITE-FILE"
    .byte 0
hl_XWRITE_FILE:
    .ascii "WRITE-FILE ( c-addr u fileid -- ior ) write to an open file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XWRITE_FILE:
    .quad nm_XWRITE_FILE, hl_XWRITE_FILE
    .quad 0
    .quad XWRITE_FILE, XWRITE_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XWRITE_FILE
    .text
    .p2align 2
XWRITE_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x2, [x22], #8
    ldr x5, [x22], #8
    mov x0, #5
    mov x3, #0
    mov x4, #0
    bl _file_op_call
    mov x20, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XWRITE_FILE_END:
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
nm_XREPOSITION_FILE:
    .ascii "REPOSITION-FILE"
    .byte 0
hl_XREPOSITION_FILE:
    .ascii "REPOSITION-FILE ( ud fileid -- ior ) seek in an open file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XREPOSITION_FILE:
    .quad nm_XREPOSITION_FILE, hl_XREPOSITION_FILE
    .quad 0
    .quad XREPOSITION_FILE, XREPOSITION_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XREPOSITION_FILE
    .text
    .p2align 2
XREPOSITION_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    mov x0, #10
    mov x4, #0
    mov x5, #0
    bl _file_op_call
    mov x20, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XREPOSITION_FILE_END:
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
nm_XFLUSH_FILE:
    .ascii "FLUSH-FILE"
    .byte 0
hl_XFLUSH_FILE:
    .ascii "FLUSH-FILE ( fileid -- ior ) flush an open file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFLUSH_FILE:
    .quad nm_XFLUSH_FILE, hl_XFLUSH_FILE
    .quad 0
    .quad XFLUSH_FILE, XFLUSH_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFLUSH_FILE
    .text
    .p2align 2
XFLUSH_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    mov x0, #15
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    bl _file_op_call
    mov x20, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XFLUSH_FILE_END:
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
nm_XREAD_LINE:
    .ascii "READ-LINE"
    .byte 0
hl_XREAD_LINE:
    .ascii "READ-LINE ( c-addr u1 fileid -- u2 flag ior ) read one line. flag is true when a line was read"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XREAD_LINE:
    .quad nm_XREAD_LINE, hl_XREAD_LINE
    .quad 0
    .quad XREAD_LINE, XREAD_LINE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XREAD_LINE
    .text
    .p2align 2
XREAD_LINE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x2, [x22], #8
    ldr x5, [x22], #8
    mov x0, #6
    mov x3, #0
    mov x4, #0
    bl _file_op_call
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x6, [x22, #-8]!
    str x7, [x22, #-8]!
    mov x20, x0
XREAD_LINE_END:
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
nm_XWRITE_LINE:
    .ascii "WRITE-LINE"
    .byte 0
hl_XWRITE_LINE:
    .ascii "WRITE-LINE ( c-addr u fileid -- ior ) write the bytes and a newline"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XWRITE_LINE:
    .quad nm_XWRITE_LINE, hl_XWRITE_LINE
    .quad 0
    .quad XWRITE_LINE, XWRITE_LINE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XWRITE_LINE
    .text
    .p2align 2
XWRITE_LINE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x2, [x22], #8
    ldr x5, [x22], #8
    mov x0, #7
    mov x3, #0
    mov x4, #0
    bl _file_op_call
    mov x20, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XWRITE_LINE_END:
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
nm_XFILE_POSITION:
    .ascii "FILE-POSITION"
    .byte 0
hl_XFILE_POSITION:
    .ascii "FILE-POSITION ( fileid -- ud ior ) byte offset in an open file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFILE_POSITION:
    .quad nm_XFILE_POSITION, hl_XFILE_POSITION
    .quad 0
    .quad XFILE_POSITION, XFILE_POSITION_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFILE_POSITION
    .text
    .p2align 2
XFILE_POSITION:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    mov x0, #8
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    bl _file_op_call
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x6, [x22, #-8]!
    str x7, [x22, #-8]!
    mov x20, x0
XFILE_POSITION_END:
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
nm_XRESIZE_FILE:
    .ascii "RESIZE-FILE"
    .byte 0
hl_XRESIZE_FILE:
    .ascii "RESIZE-FILE ( ud fileid -- ior ) set the length of an open file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRESIZE_FILE:
    .quad nm_XRESIZE_FILE, hl_XRESIZE_FILE
    .quad 0
    .quad XRESIZE_FILE, XRESIZE_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRESIZE_FILE
    .text
    .p2align 2
XRESIZE_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    mov x0, #11
    mov x4, #0
    mov x5, #0
    bl _file_op_call
    mov x20, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XRESIZE_FILE_END:
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
nm_XDELETE_FILE:
    .ascii "DELETE-FILE"
    .byte 0
hl_XDELETE_FILE:
    .ascii "DELETE-FILE ( c-addr u -- ior ) delete a named file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDELETE_FILE:
    .quad nm_XDELETE_FILE, hl_XDELETE_FILE
    .quad 0
    .quad XDELETE_FILE, XDELETE_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDELETE_FILE
    .text
    .p2align 2
XDELETE_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x2, x20
    ldr x5, [x22], #8
    mov x0, #12
    mov x1, #0
    mov x3, #0
    mov x4, #0
    bl _file_op_call
    mov x20, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XDELETE_FILE_END:
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
nm_XRENAME_FILE:
    .ascii "RENAME-FILE"
    .byte 0
hl_XRENAME_FILE:
    .ascii "RENAME-FILE ( c-addr1 u1 c-addr2 u2 -- ior ) rename a file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRENAME_FILE:
    .quad nm_XRENAME_FILE, hl_XRENAME_FILE
    .quad 0
    .quad XRENAME_FILE, XRENAME_FILE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRENAME_FILE
    .text
    .p2align 2
XRENAME_FILE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x4, x20
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x5, [x22], #8
    mov x0, #13
    mov x1, #0
    bl _file_op_call
    mov x20, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
XRENAME_FILE_END:
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
nm_XFILE_STATUS:
    .ascii "FILE-STATUS"
    .byte 0
hl_XFILE_STATUS:
    .ascii "FILE-STATUS ( c-addr u -- x ior ) attributes of a named file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFILE_STATUS:
    .quad nm_XFILE_STATUS, hl_XFILE_STATUS
    .quad 0
    .quad XFILE_STATUS, XFILE_STATUS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFILE_STATUS
    .text
    .p2align 2
XFILE_STATUS:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x2, x20
    ldr x5, [x22], #8
    mov x0, #14
    mov x1, #0
    mov x3, #0
    mov x4, #0
    bl _file_op_call
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x6, [x22, #-8]!
    mov x20, x0
XFILE_STATUS_END:
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
nm_XLINE_SOURCE:
    .ascii "(LINE-SOURCE)"
    .byte 0
hl_XLINE_SOURCE:
    .ascii "(LINE-SOURCE) ( c-addr u -- ) interpret one line per SOURCE"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLINE_SOURCE:
    .quad nm_XLINE_SOURCE, hl_XLINE_SOURCE
    .quad 0
    .quad XLINE_SOURCE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLINE_SOURCE
    .text
    .p2align 2
XLINE_SOURCE:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    stp x0, x1, [sp, #48]
    bl _push_source
    bl _view_push_src_id
    bl _view_set_src_from_pending
    ldp x0, x1, [sp, #48]
    bl _arm_lines
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
    mov x1, #2
    neg x1, x1
    str x1, [x0]
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
    str xzr, [x0]
    bl _eval_resume_push
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    b _interpret_empty
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XRESOLVE_KEY:
    .ascii "RESOLVE-KEY"
    .byte 0
hl_XRESOLVE_KEY:
    .ascii "RESOLVE-KEY ( c-addr u -- c-addr u ) absolute path for a load name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRESOLVE_KEY:
    .quad nm_XRESOLVE_KEY, hl_XRESOLVE_KEY
    .quad 0
    .quad XRESOLVE_KEY, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRESOLVE_KEY
    .text
    .p2align 2
XRESOLVE_KEY:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x0, [x22], #8
    cbz x1, _resolve_empty
    adrp x2, :got:resolve_buf
    ldr x2, [x2, :got_lo12:resolve_buf]
    mov x3, #256
    bl host_resolve
    mov x1, x0
    cmp x1, #255
    b.ls _rk_cap
    mov x1, #255
_rk_cap:
    adrp x3, :got:include_name_len
    ldr x3, [x3, :got_lo12:include_name_len]
    str x1, [x3]
    cbz x1, _rk_copied
    adrp x2, :got:resolve_buf
    ldr x2, [x2, :got_lo12:resolve_buf]
    adrp x3, :got:include_name_pending
    ldr x3, [x3, :got_lo12:include_name_pending]
    mov x4, #0
_rk_cp:
    cmp x4, x1
    b.hs _rk_copied
    ldrb w5, [x2, x4]
    strb w5, [x3, x4]
    add x4, x4, #1
    b _rk_cp
_rk_copied:
    adrp x2, :got:resolve_buf
    ldr x2, [x2, :got_lo12:resolve_buf]
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x2, [x22, #-8]!
    mov x20, x0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_resolve_empty:
    adrp x1, :got:include_name_len
    ldr x1, [x1, :got_lo12:include_name_len]
    str xzr, [x1]
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x0, [x22, #-8]!
    mov x20, #0
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
nm_XBEGIN_LOAD_CWD:
    .ascii "BEGIN-LOAD-CWD"
    .byte 0
hl_XBEGIN_LOAD_CWD:
    .ascii "BEGIN-LOAD-CWD ( c-addr u -- ) push the directory of this path"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBEGIN_LOAD_CWD:
    .quad nm_XBEGIN_LOAD_CWD, hl_XBEGIN_LOAD_CWD
    .quad 0
    .quad XBEGIN_LOAD_CWD, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBEGIN_LOAD_CWD
    .text
    .p2align 2
XBEGIN_LOAD_CWD:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    bl host_begin_load
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
nm_XEND_LOAD_CWD:
    .ascii "END-LOAD-CWD"
    .byte 0
hl_XEND_LOAD_CWD:
    .ascii "END-LOAD-CWD ( -- ) pop the directory pushed for this load"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XEND_LOAD_CWD:
    .quad nm_XEND_LOAD_CWD, hl_XEND_LOAD_CWD
    .quad 0
    .quad XEND_LOAD_CWD, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XEND_LOAD_CWD
    .text
    .p2align 2
XEND_LOAD_CWD:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl host_end_load
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
nm_XREG_INCLUDED:
    .ascii "REGISTER-INCLUDED-STR"
    .byte 0
hl_XREG_INCLUDED:
    .ascii "REGISTER-INCLUDED-STR ( c-addr u -- ) remember a loaded path"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XREG_INCLUDED:
    .quad nm_XREG_INCLUDED, hl_XREG_INCLUDED
    .quad 0
    .quad XREG_INCLUDED, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XREG_INCLUDED
    .text
    .p2align 2
XREG_INCLUDED:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    bl host_register
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
_parse_filespec:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl _cursor_load
    mov x2, x0
    adrp x9, :got:source_end
    ldr x9, [x9, :got_lo12:source_end]
    ldr x9, [x9]
_pfs_skip:
    cmp x2, x9
    b.hs _pfs_empty
    ldrb w4, [x2]
    cmp w4, #32
    b.eq _pfs_sk
    cmp w4, #9
    b.eq _pfs_sk
    cmp w4, #10
    b.eq _pfs_sk
    cmp w4, #13
    b.eq _pfs_sk
    b _pfs_body
_pfs_sk:
    add x2, x2, #1
    b _pfs_skip
_pfs_body:
    cmp w4, #34
    b.ne _pfs_word
    add x3, x2, #1
_pfs_q:
    add x2, x2, #1
    cmp x2, x9
    b.hs _pfs_qend
    ldrb w4, [x2]
    cmp w4, #34
    b.ne _pfs_q
    sub x5, x2, x3
    add x2, x2, #1
    b _pfs_out
_pfs_qend:
    sub x5, x2, x3
    b _pfs_out
_pfs_word:
    mov x0, x2
    bl _cursor_commit
    bl _parse_name_raw
    mov x0, x2
    mov x1, x5
    b _pfs_ret
_pfs_out:
    mov x0, x2
    mov x2, x3
    bl _cursor_commit
    mov x0, x2
    mov x1, x5
    b _pfs_ret
_pfs_empty:
    mov x0, x2
    bl _cursor_commit
    mov x1, #0
_pfs_ret:
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    ret
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XPARSE_FILESPEC:
    .ascii "PARSE-FILESPEC"
    .byte 0
hl_XPARSE_FILESPEC:
    .ascii "PARSE-FILESPEC ( -- c-addr u ) next file name or quoted path"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPARSE_FILESPEC:
    .quad nm_XPARSE_FILESPEC, hl_XPARSE_FILESPEC
    .quad 0
    .quad XPARSE_FILESPEC, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPARSE_FILESPEC
    .text
    .p2align 2
XPARSE_FILESPEC:
    stp x29, x30, [sp, #-16]!
    bl _parse_filespec
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    str x0, [x22, #-8]!
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
nm_XFROMLIB:
    .ascii "FROMLIB"
    .byte 0
hl_XFROMLIB:
    .ascii "FROMLIB ( -- ) arm the next relative load to use Library"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFROMLIB:
    .quad nm_XFROMLIB, hl_XFROMLIB
    .quad 0
    .quad XFROMLIB, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFROMLIB
    .text
    .p2align 2
XFROMLIB:
    stp x29, x30, [sp, #-16]!
    bl host_fromlib
    ldp x29, x30, [sp], #16
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
nm_XFROM_LIBRARY:
    .ascii "FROM-LIBRARY"
    .byte 0
hl_XFROM_LIBRARY:
    .ascii "FROM-LIBRARY ( -- ) same as FROMLIB"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFROM_LIBRARY:
    .quad nm_XFROM_LIBRARY, hl_XFROM_LIBRARY
    .quad 0
    .quad XFROM_LIBRARY, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFROM_LIBRARY
    .text
    .p2align 2
XFROM_LIBRARY:
    stp x29, x30, [sp, #-16]!
    bl host_fromlib
    ldp x29, x30, [sp], #16
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
nm_XFROMLIB_OFF:
    .ascii "FROMLIB-OFF"
    .byte 0
hl_XFROMLIB_OFF:
    .ascii "FROMLIB-OFF ( -- ) clear an armed FROMLIB"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFROMLIB_OFF:
    .quad nm_XFROMLIB_OFF, hl_XFROMLIB_OFF
    .quad 0
    .quad XFROMLIB_OFF, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFROMLIB_OFF
    .text
    .p2align 2
XFROMLIB_OFF:
    stp x29, x30, [sp, #-16]!
    bl host_fromlib_off
    ldp x29, x30, [sp], #16
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
nm_XFROMLIB_Q:
    .ascii "FROMLIB?"
    .byte 0
hl_XFROMLIB_Q:
    .ascii "FROMLIB? ( -- flag ) true when FROMLIB is armed"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFROMLIB_Q:
    .quad nm_XFROMLIB_Q, hl_XFROMLIB_Q
    .quad 0
    .quad XFROMLIB_Q, XFROMLIB_Q_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFROMLIB_Q
    .text
    .p2align 2
XFROMLIB_Q:
    stp x29, x30, [sp, #-16]!
    bl host_fromlib_query
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XFROMLIB_Q_END:
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
nm_XFILE_ECHO:
    .ascii "FILE-ECHO"
    .byte 0
hl_XFILE_ECHO:
    .ascii "FILE-ECHO ( -- addr ) echo INCLUDE and FLOAD lines with a line number"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFILE_ECHO:
    .quad nm_XFILE_ECHO, hl_XFILE_ECHO
    .quad 0
    .quad XFILE_ECHO, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFILE_ECHO
    .text
    .p2align 2
XFILE_ECHO:
    adrp x0, :got:file_echo
    ldr x0, [x0, :got_lo12:file_echo]
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
nm_XCLS:
    .ascii "CLS"
    .byte 0
hl_XCLS:
    .ascii "CLS ( -- ) clear the host console"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCLS:
    .quad nm_XCLS, hl_XCLS
    .quad 0
    .quad XCLS, XCLS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCLS
    .text
    .p2align 2
XCLS:
    mov x0, #9
    mov x1, #0
    mov x2, #0
    b _facility_op_go
XCLS_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XBIMUL:
    .ascii "BI-MUL"
    .byte 0
hl_XBIMUL:
    .ascii "BI-MUL ( a b r -- ) BIG-INTEGER host multiply"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBIMUL:
    .quad nm_XBIMUL, hl_XBIMUL
    .quad 0
    .quad XBIMUL, XBIMUL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBIMUL
    .text
    .p2align 2
XBIMUL:
    mov x2, x20
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_bi_mul
    ldp x29, x30, [sp], #16
XBIMUL_END:
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
nm_XBIDIVMOD:
    .ascii "BI-DIVMOD"
    .byte 0
hl_XBIDIVMOD:
    .ascii "BI-DIVMOD ( num den quot rem work -- ) BIG-INTEGER host divmod"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBIDIVMOD:
    .quad nm_XBIDIVMOD, hl_XBIDIVMOD
    .quad 0
    .quad XBIDIVMOD, XBIDIVMOD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBIDIVMOD
    .text
    .p2align 2
XBIDIVMOD:
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_bi_divmod
    ldp x29, x30, [sp], #16
XBIDIVMOD_END:
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
nm_XBIISQRT:
    .ascii "BI-ISQRT"
    .byte 0
hl_XBIISQRT:
    .ascii "BI-ISQRT ( a r quot rem work t1 t2 -- ) BIG-INTEGER host isqrt"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBIISQRT:
    .quad nm_XBIISQRT, hl_XBIISQRT
    .quad 0
    .quad XBIISQRT, XBIISQRT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBIISQRT
    .text
    .p2align 2
XBIISQRT:
    ldr x0, [x22], #8
    ldr x0, [x22], #8
    ldr x0, [x22], #8
    ldr x0, [x22], #8
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_bi_isqrt
    ldp x29, x30, [sp], #16
XBIISQRT_END:
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
nm_XCHDIR:
    .ascii "CHDIR"
    .byte 0
hl_XCHDIR:
    .ascii "CHDIR ( -- ) change directory. a bare call waits for a dialog"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCHDIR:
    .quad nm_XCHDIR, hl_XCHDIR
    .quad 0
    .quad XCHDIR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCHDIR
    .text
    .p2align 2
XCHDIR:
    stp x29, x30, [sp, #-16]!
    bl _parse_filespec
    cbz x1, _chdir_done
    bl host_chdir
_chdir_done:
    ldp x29, x30, [sp], #16
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
nm_XPWD:
    .ascii "PWD"
    .byte 0
hl_XPWD:
    .ascii "PWD ( -- ) print the current directory"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPWD:
    .quad nm_XPWD, hl_XPWD
    .quad 0
    .quad XPWD, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPWD
    .text
    .p2align 2
XPWD:
    stp x29, x30, [sp, #-16]!
    bl host_pwd
    ldp x29, x30, [sp], #16
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
nm_XCWD_FETCH:
    .ascii "CWD@"
    .byte 0
hl_XCWD_FETCH:
    .ascii "CWD@ ( c-addr max -- u ) copy the current directory"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCWD_FETCH:
    .quad nm_XCWD_FETCH, hl_XCWD_FETCH
    .quad 0
    .quad XCWD_FETCH, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCWD_FETCH
    .text
    .p2align 2
XCWD_FETCH:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x0, [x22], #8
    bl host_cwd
    mov x20, x0
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
XCWD_FETCH_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDIR:
    .ascii "DIR"
    .byte 0
hl_XDIR:
    .ascii "DIR ( -- ) list files. a bare call lists the current directory"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDIR:
    .quad nm_XDIR, hl_XDIR
    .quad 0
    .quad XDIR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDIR
    .text
    .p2align 2
XDIR:
    stp x29, x30, [sp, #-16]!
    bl _parse_filespec
    bl host_dir
    ldp x29, x30, [sp], #16
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
nm_XLAST_INCLUDED:
    .ascii "LAST-INCLUDED"
    .byte 0
hl_XLAST_INCLUDED:
    .ascii "LAST-INCLUDED ( -- c-addr u ) path of the last included file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLAST_INCLUDED:
    .quad nm_XLAST_INCLUDED, hl_XLAST_INCLUDED
    .quad 0
    .quad XLAST_INCLUDED, XLAST_INCLUDED_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLAST_INCLUDED
    .text
    .p2align 2
XLAST_INCLUDED:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    add x0, sp, #48
    add x1, sp, #56
    bl host_last_included
    ldr x0, [sp, #48]
    ldr x1, [sp, #56]
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    str x20, [x22, #-8]!
    str x0, [x22, #-8]!
    mov x20, x1
XLAST_INCLUDED_END:
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
nm_XDOT_INCLUDED:
    .ascii ".INCLUDED"
    .byte 0
hl_XDOT_INCLUDED:
    .ascii ".INCLUDED ( -- ) list files registered by INCLUDE/REQUIRED"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDOT_INCLUDED:
    .quad nm_XDOT_INCLUDED, hl_XDOT_INCLUDED
    .quad 0
    .quad XDOT_INCLUDED, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDOT_INCLUDED
    .text
    .p2align 2
XDOT_INCLUDED:
    stp x29, x30, [sp, #-16]!
    bl host_dot_included
    ldp x29, x30, [sp], #16
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
nm_XINCLUDE_PAREN:
    .ascii "(INCLUDE)"
    .byte 0
hl_XINCLUDE_PAREN:
    .ascii "(INCLUDE) ( -- ) bare INCLUDE opens a file dialog"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XINCLUDE_PAREN:
    .quad nm_XINCLUDE_PAREN, hl_XINCLUDE_PAREN
    .quad 0
    .quad XINCLUDE_PAREN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XINCLUDE_PAREN
    .text
    .p2align 2
XINCLUDE_PAREN:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    add x0, sp, #48
    bl host_include_dialog
    cbz x0, _inc_none
    str x0, [sp, #56]
    ldr x1, [sp, #48]
    str x1, [sp, #64]
    adrp x0, :got:req_included_name
    ldr x0, [x0, :got_lo12:req_included_name]
    mov x1, #8
    bl _find_word
    cbz x0, _inc_none
    ldr x2, [sp, #64]
    ldr x3, [sp, #56]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    str x20, [x22, #-8]!
    str x2, [x22, #-8]!
    mov x20, x3
    mov x21, x0
    ldr x5, [x21]
    br x5
_inc_none:
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
nm_XREQUIRED:
    .ascii "REQUIRED"
    .byte 0
hl_XREQUIRED:
    .ascii "REQUIRED ( c-addr u -- ) INCLUDED unless this path was loaded"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XREQUIRED:
    .quad nm_XREQUIRED, hl_XREQUIRED
    .quad 0
    .quad XREQUIRED, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XREQUIRED
    .text
    .p2align 2
XREQUIRED:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    mov x1, x20
    ldr x0, [x22], #8
    cbz x1, _req_drop
    adrp x2, :got:resolve_buf
    ldr x2, [x2, :got_lo12:resolve_buf]
    mov x3, #256
    bl host_resolve
    cbz x0, _req_drop
    str x0, [sp, #48]
    adrp x0, :got:resolve_buf
    ldr x0, [x0, :got_lo12:resolve_buf]
    ldr x1, [sp, #48]
    bl host_was_included
    cbnz x0, _req_drop
    adrp x0, :got:req_included_name
    ldr x0, [x0, :got_lo12:req_included_name]
    mov x1, #8
    bl _find_word
    cbz x0, _req_drop
    ldr x1, [sp, #48]
    adrp x2, :got:resolve_buf
    ldr x2, [x2, :got_lo12:resolve_buf]
    str x2, [x22, #-8]!
    mov x20, x1
    mov x21, x0
    ldr x5, [x21]
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    br x5
_req_drop:
    ldr x20, [x22], #8
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
nm_XFORGET:
    .ascii "FORGET"
    .byte 0
hl_XFORGET:
    .ascii "FORGET ( name -- ) remove that word and everything newer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFORGET:
    .quad nm_XFORGET, hl_XFORGET
    .quad 0
    .quad XFORGET, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFORGET
    .text
    .p2align 2
XFORGET:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    bl _next_word
    cbz x1, _forget_empty
    stp x0, x1, [sp, #48]
    bl _find_word
    cbz x0, _forget_undef
    adrp x1, :got:words_user_base
    ldr x1, [x1, :got_lo12:words_user_base]
    ldr x1, [x1]
    cbnz x1, _forget_fence
    adrp x1, :got:user_dict_area
    ldr x1, [x1, :got_lo12:user_dict_area]
_forget_fence:
    cmp x0, x1
    b.lo _forget_prot
    adrp x2, :got:forget_cut
    ldr x2, [x2, :got_lo12:forget_cut]
    str x0, [x2]
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    str x0, [x1]
    adrp x0, :got:latest_var
    ldr x0, [x0, :got_lo12:latest_var]
    ldr x1, [x2]
    bl _prune_wid
    adrp x3, :got:current_var
    ldr x3, [x3, :got_lo12:current_var]
    ldr x0, [x3]
    cbz x0, _forget_search
    adrp x2, :got:forget_cut
    ldr x2, [x2, :got_lo12:forget_cut]
    ldr x1, [x2]
    bl _prune_wid
_forget_search:
    adrp x2, :got:search_order_n
    ldr x2, [x2, :got_lo12:search_order_n]
    ldr x2, [x2]
    adrp x3, :got:search_order
    ldr x3, [x3, :got_lo12:search_order]
    mov x4, #0
_forget_sloop:
    cmp x4, x2
    b.hs _forget_regs
    ldr x0, [x3, x4, lsl #3]
    cbz x0, _forget_snext
    stp x2, x3, [sp, #-16]!
    stp x4, xzr, [sp, #-16]!
    adrp x1, :got:forget_cut
    ldr x1, [x1, :got_lo12:forget_cut]
    ldr x1, [x1]
    bl _prune_wid
    ldp x4, xzr, [sp], #16
    ldp x2, x3, [sp], #16
_forget_snext:
    add x4, x4, #1
    b _forget_sloop
_forget_regs:
    adrp x2, :got:wordlist_reg_n
    ldr x2, [x2, :got_lo12:wordlist_reg_n]
    ldr x2, [x2]
    adrp x3, :got:wordlist_reg
    ldr x3, [x3, :got_lo12:wordlist_reg]
    mov x4, #0
_forget_rloop:
    cmp x4, x2
    b.hs _forget_done
    ldr x0, [x3, x4, lsl #3]
    cbz x0, _forget_rnext
    stp x2, x3, [sp, #-16]!
    stp x4, xzr, [sp, #-16]!
    adrp x1, :got:forget_cut
    ldr x1, [x1, :got_lo12:forget_cut]
    ldr x1, [x1]
    bl _prune_wid
    ldp x4, xzr, [sp], #16
    ldp x2, x3, [sp], #16
_forget_rnext:
    add x4, x4, #1
    b _forget_rloop
_forget_done:
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
_forget_prot:
    adrp x0, :got:str_protected
    ldr x0, [x0, :got_lo12:str_protected]
    bl emit_cstr
    b _forget_done
_forget_empty:
    adrp x0, :got:msg_huh
    ldr x0, [x0, :got_lo12:msg_huh]
    bl emit_cstr
    b _forget_done
_forget_undef:
    ldp x0, x1, [sp, #48]
    bl emit_str
    adrp x0, :got:msg_huh
    ldr x0, [x0, :got_lo12:msg_huh]
    bl emit_cstr
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    b _quit_exit
_prune_wid:
    cbz x0, _prune_ret
    mov x3, x0
    mov x4, x1
    mov x5, #0
_prune_thread:
    cmp x5, #16
    b.hs _prune_ret
    add x0, x3, x5, lsl #3
_prune_head:
    ldr x2, [x0]
    cbz x2, _prune_next
    cmp x2, x4
    b.lo _prune_next
    ldr x2, [x2, #-16]
    str x2, [x0]
    b _prune_head
_prune_next:
    add x5, x5, #1
    b _prune_thread
_prune_ret:
    ret
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XBLOCK_FILE:
    .ascii "BLOCK-FILE"
    .byte 0
hl_XBLOCK_FILE:
    .ascii "BLOCK-FILE ( -- addr ) current block fileid"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBLOCK_FILE:
    .quad nm_XBLOCK_FILE, hl_XBLOCK_FILE
    .quad 0
    .quad XBLOCK_FILE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBLOCK_FILE
    .text
    .p2align 2
XBLOCK_FILE:
    str x20, [x22, #-8]!
    adrp x0, :got:block_file
    ldr x0, [x0, :got_lo12:block_file]
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
nm_XBLOCK_BUF:
    .ascii "(BLOCK-BUF)"
    .byte 0
hl_XBLOCK_BUF:
    .ascii "(BLOCK-BUF) ( -- addr ) 1024-byte block buffer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBLOCK_BUF:
    .quad nm_XBLOCK_BUF, hl_XBLOCK_BUF
    .quad 0
    .quad XBLOCK_BUF, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBLOCK_BUF
    .text
    .p2align 2
XBLOCK_BUF:
    str x20, [x22, #-8]!
    adrp x0, :got:block_buf
    ldr x0, [x0, :got_lo12:block_buf]
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
nm_XBLOCK_UPD:
    .ascii "(BLOCK-UPD)"
    .byte 0
hl_XBLOCK_UPD:
    .ascii "(BLOCK-UPD) ( -- addr ) block-buffer dirty flag"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBLOCK_UPD:
    .quad nm_XBLOCK_UPD, hl_XBLOCK_UPD
    .quad 0
    .quad XBLOCK_UPD, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBLOCK_UPD
    .text
    .p2align 2
XBLOCK_UPD:
    str x20, [x22, #-8]!
    adrp x0, :got:block_upd
    ldr x0, [x0, :got_lo12:block_upd]
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
nm_XBLOCK_NR:
    .ascii "(BLOCK-NR)"
    .byte 0
hl_XBLOCK_NR:
    .ascii "(BLOCK-NR) ( -- addr ) current block number"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBLOCK_NR:
    .quad nm_XBLOCK_NR, hl_XBLOCK_NR
    .quad 0
    .quad XBLOCK_NR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBLOCK_NR
    .text
    .p2align 2
XBLOCK_NR:
    str x20, [x22, #-8]!
    adrp x0, :got:block_nr
    ldr x0, [x0, :got_lo12:block_nr]
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
nm_XBLK:
    .ascii "BLK"
    .byte 0
hl_XBLK:
    .ascii "BLK ( -- addr ) block being loaded or zero"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBLK:
    .quad nm_XBLK, hl_XBLK
    .quad 0
    .quad XBLK, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBLK
    .text
    .p2align 2
XBLK:
    str x20, [x22, #-8]!
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
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
nm_XSCR:
    .ascii "SCR"
    .byte 0
hl_XSCR:
    .ascii "SCR ( -- addr ) last listed block number"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSCR:
    .quad nm_XSCR, hl_XSCR
    .quad 0
    .quad XSCR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSCR
    .text
    .p2align 2
XSCR:
    str x20, [x22, #-8]!
    adrp x0, :got:scr_var
    ldr x0, [x0, :got_lo12:scr_var]
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
nm_XLOAD_ENTER:
    .ascii "(LOAD-ENTER)"
    .byte 0
hl_XLOAD_ENTER:
    .ascii "(LOAD-ENTER) ( u -- u ) save SOURCE and set BLK"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOAD_ENTER:
    .quad nm_XLOAD_ENTER, hl_XLOAD_ENTER
    .quad 0
    .quad XLOAD_ENTER, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOAD_ENTER
    .text
    .p2align 2
XLOAD_ENTER:
    stp x29, x30, [sp, #-16]!
    bl _push_source
    ldp x29, x30, [sp], #16
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
    str x20, [x0]
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
nm_XLOAD_RUN:
    .ascii "(LOAD-RUN)"
    .byte 0
hl_XLOAD_RUN:
    .ascii "(LOAD-RUN) ( c-addr u -- ) interpret a block buffer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOAD_RUN:
    .quad nm_XLOAD_RUN, hl_XLOAD_RUN
    .quad 0
    .quad XLOAD_RUN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOAD_RUN
    .text
    .p2align 2
XLOAD_RUN:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x0, x1, [sp, #48]
    ldp x0, x1, [sp, #48]
    adrp x2, :got:source_base
    ldr x2, [x2, :got_lo12:source_base]
    str x0, [x2]
    adrp x2, :got:source_cur
    ldr x2, [x2, :got_lo12:source_cur]
    str x0, [x2]
    add x0, x0, x1
    adrp x2, :got:source_end
    ldr x2, [x2, :got_lo12:source_end]
    str x0, [x2]
    adrp x2, :got:to_in
    ldr x2, [x2, :got_lo12:to_in]
    str xzr, [x2]
    adrp x2, :got:line_mode
    ldr x2, [x2, :got_lo12:line_mode]
    str xzr, [x2]
    adrp x2, :got:source_id
    ldr x2, [x2, :got_lo12:source_id]
    mov x3, #-1
    str x3, [x2]
    bl _eval_resume_push
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    b _interpret_loop
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XRBRA:
    .ascii "]"
    .byte 0
hl_XRBRA:
    .ascii "] ( -- ) enter compile mode"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRBRA:
    .quad nm_XRBRA, hl_XRBRA
    .quad 0
    .quad XRBRA, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRBRA
    .text
    .p2align 2
XRBRA:
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    mov x1, #1
    str x1, [x0]
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
nm_XLBRA:
    .ascii "["
    .byte 0
hl_XLBRA:
    .ascii "[ ( -- ) enter interpret mode"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLBRA:
    .quad nm_XLBRA, hl_XLBRA
    .word 0, 2147483648
    .quad XLBRA, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLBRA
    .text
    .p2align 2
XLBRA:
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    str xzr, [x0]
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
nm_XEVALUATE:
    .ascii "EVALUATE"
    .byte 0
hl_XEVALUATE:
    .ascii "EVALUATE ( i*x c-addr u -- j*x ) interpret the string as Forth source"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XEVALUATE:
    .quad nm_XEVALUATE, hl_XEVALUATE
    .quad 0
    .quad XEVALUATE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XEVALUATE
    .text
    .p2align 2
XEVALUATE:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x0, x1, [sp, #48]
    bl _push_source
    cbz x0, _ev_fail
    ldp x0, x1, [sp, #48]
    adrp x2, :got:source_base
    ldr x2, [x2, :got_lo12:source_base]
    str x0, [x2]
    adrp x2, :got:source_cur
    ldr x2, [x2, :got_lo12:source_cur]
    str x0, [x2]
    add x0, x0, x1
    adrp x2, :got:source_end
    ldr x2, [x2, :got_lo12:source_end]
    str x0, [x2]
    adrp x2, :got:to_in
    ldr x2, [x2, :got_lo12:to_in]
    str xzr, [x2]
    adrp x2, :got:line_mode
    ldr x2, [x2, :got_lo12:line_mode]
    str xzr, [x2]
    adrp x2, :got:source_id
    ldr x2, [x2, :got_lo12:source_id]
    mov x3, #-1
    str x3, [x2]
    adrp x2, :got:blk_var
    ldr x2, [x2, :got_lo12:blk_var]
    str xzr, [x2]
    bl _eval_resume_push
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    b _interpret_loop
_ev_fail:
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
nm_XQUIT:
    .ascii "QUIT"
    .byte 0
hl_XQUIT:
    .ascii "QUIT ( -- ) empty the return stack and return to the outer interpreter"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XQUIT:
    .quad nm_XQUIT, hl_XQUIT
    .quad 0
    .quad XQUIT, XQUIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XQUIT
    .text
    .p2align 2
XQUIT:
    b _do_quit
XQUIT_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XBACKSLASH_S:
    .byte 92
    .ascii "S"
    .byte 0
hl_XBACKSLASH_S:
    .byte 92
    .ascii "S"
    .ascii "stop the rest of this source"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBACKSLASH_S:
    .quad nm_XBACKSLASH_S, hl_XBACKSLASH_S
    .word 0, 2147483648
    .quad XBACKSLASH_S, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBACKSLASH_S
    .text
    .p2align 2
XBACKSLASH_S:
    adrp x0, :got:line_mode
    ldr x0, [x0, :got_lo12:line_mode]
    ldr x0, [x0]
    cbz x0, _bs_pin
    adrp x0, :got:line_limit
    ldr x0, [x0, :got_lo12:line_limit]
    ldr x1, [x0]
    adrp x0, :got:line_next
    ldr x0, [x0, :got_lo12:line_next]
    str x1, [x0]
_bs_pin:
    adrp x0, :got:source_base
    ldr x0, [x0, :got_lo12:source_base]
    ldr x0, [x0]
    adrp x1, :got:source_end
    ldr x1, [x1, :got_lo12:source_end]
    ldr x1, [x1]
    sub x2, x1, x0
    adrp x0, :got:to_in
    ldr x0, [x0, :got_lo12:to_in]
    str x2, [x0]
    adrp x0, :got:source_cur
    ldr x0, [x0, :got_lo12:source_cur]
    str x1, [x0]
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
nm_XSOURCE_ID:
    .ascii "SOURCE-ID"
    .byte 0
hl_XSOURCE_ID:
    .ascii "SOURCE-ID ( -- id ) 0 console -1 evaluate -2 file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSOURCE_ID:
    .quad nm_XSOURCE_ID, hl_XSOURCE_ID
    .quad 0
    .quad XSOURCE_ID, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSOURCE_ID
    .text
    .p2align 2
XSOURCE_ID:
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
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
nm_XACCEPT:
    .ascii "ACCEPT"
    .byte 0
hl_XACCEPT:
    .ascii "ACCEPT ( c-addr +n1 -- +n2 ) read a line into the buffer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XACCEPT:
    .quad nm_XACCEPT, hl_XACCEPT
    .quad 0
    .quad XACCEPT, XACCEPT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XACCEPT
    .text
    .p2align 2
XACCEPT:
    mov x1, x20
    ldr x0, [x22], #8
    cmp x1, #0
    b.gt _acc_read
    mov x20, #0
    b XACCEPT_END
_acc_read:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    bl host_accept
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    mov x20, x0
XACCEPT_END:
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
nm_XTONUMBER:
    .ascii ">NUMBER"
    .byte 0
hl_XTONUMBER:
    .ascii ">NUMBER ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 ) convert digits in the current base"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTONUMBER:
    .quad nm_XTONUMBER, hl_XTONUMBER
    .quad 0
    .quad XTONUMBER, XTONUMBER_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTONUMBER
    .text
    .p2align 2
XTONUMBER:
    mov x4, x20
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    adrp x5, :got:base_var
    ldr x5, [x5, :got_lo12:base_var]
    ldr x5, [x5]
    cmp x5, #2
    b.lo _tn_base10
    cmp x5, #36
    b.ls _tn_loop
_tn_base10:
    mov x5, #10
_tn_loop:
    cbz x4, _tn_done
    ldrb w6, [x3]
    sub w7, w6, #48
    cmp w7, #9
    b.ls _tn_dig
    cmp w6, #'a'
    b.lo _tn_up
    cmp w6, #'z'
    b.hi _tn_done
    sub w6, w6, #32
_tn_up:
    sub w7, w6, #'A'
    cmp w7, #25
    b.hi _tn_done
    add w7, w7, #10
_tn_dig:
    cmp x7, x5
    b.hs _tn_done
    mul x8, x1, x5
    umulh x9, x1, x5
    mul x10, x2, x5
    add x9, x9, x10
    adds x1, x8, x7
    adc x2, x9, xzr
    add x3, x3, #1
    sub x4, x4, #1
    b _tn_loop
_tn_done:
    str x1, [x22, #-8]!
    str x2, [x22, #-8]!
    str x3, [x22, #-8]!
    mov x20, x4
XTONUMBER_END:
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
nm_XENVIRONMENT_Q:
    .ascii "ENVIRONMENT?"
    .byte 0
hl_XENVIRONMENT_Q:
    .ascii "ENVIRONMENT? ( c-addr u -- false | i*x true ) query an environment string"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XENVIRONMENT_Q:
    .quad nm_XENVIRONMENT_Q, hl_XENVIRONMENT_Q
    .quad 0
    .quad XENVIRONMENT_Q, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XENVIRONMENT_Q
    .text
    .p2align 2
XENVIRONMENT_Q:
    mov x1, x20
    ldr x0, [x22], #8
    mov x4, #0
_env_next:
    cmp x4, #ENV_COUNT
    b.hs _env_no
    adrp x5, :got:env_name_ptrs
    ldr x5, [x5, :got_lo12:env_name_ptrs]
    ldr x5, [x5, x4, lsl #3]
    mov x6, #0
_env_len:
    ldrb w7, [x5, x6]
    cbz w7, _env_len_done
    add x6, x6, #1
    b _env_len
_env_len_done:
    cmp x6, x1
    b.ne _env_cont
    mov x7, #0
_env_cmp:
    cmp x7, x6
    b.eq _env_yes
    ldrb w8, [x5, x7]
    ldrb w9, [x0, x7]
    cmp w8, w9
    b.ne _env_cont
    add x7, x7, #1
    b _env_cmp
_env_cont:
    add x4, x4, #1
    b _env_next
_env_yes:
    adrp x5, :got:env_kinds
    ldr x5, [x5, :got_lo12:env_kinds]
    ldrb w5, [x5, x4]
    adrp x6, :got:env_values
    ldr x6, [x6, :got_lo12:env_values]
    ldr x6, [x6, x4, lsl #3]
    cbz w5, _env_flag
    cmp w5, #2
    b.eq _env_string
    str x6, [x22, #-8]!
    mov x20, #-1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_env_string:
    mov x0, #0
_env_slen:
    ldrb w1, [x6, x0]
    cbz w1, _env_spush
    add x0, x0, #1
    b _env_slen
_env_spush:
    str x6, [x22, #-8]!
    str x0, [x22, #-8]!
    mov x20, #-1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_env_flag:
    mov x20, x6
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_env_no:
    mov x20, #0
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
nm_XSAVE_INPUT:
    .ascii "SAVE-INPUT"
    .byte 0
hl_XSAVE_INPUT:
    .ascii "SAVE-INPUT ( -- xn .. x1 n ) save the current input source"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSAVE_INPUT:
    .quad nm_XSAVE_INPUT, hl_XSAVE_INPUT
    .quad 0
    .quad XSAVE_INPUT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSAVE_INPUT
    .text
    .p2align 2
XSAVE_INPUT:
    str x20, [x22, #-8]!
    adrp x0, :got:source_base
    ldr x0, [x0, :got_lo12:source_base]
    ldr x20, [x0]
    str x20, [x22, #-8]!
    adrp x1, :got:source_end
    ldr x1, [x1, :got_lo12:source_end]
    ldr x1, [x1]
    sub x20, x1, x20
    str x20, [x22, #-8]!
    adrp x0, :got:to_in
    ldr x0, [x0, :got_lo12:to_in]
    ldr x20, [x0]
    str x20, [x22, #-8]!
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
    ldr x20, [x0]
    str x20, [x22, #-8]!
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
    ldr x20, [x0]
    str x20, [x22, #-8]!
    mov x20, #5
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
nm_XRESTORE_INPUT:
    .ascii "RESTORE-INPUT"
    .byte 0
hl_XRESTORE_INPUT:
    .ascii "RESTORE-INPUT ( xn .. x1 n -- flag ) restore input source. 0 means ok"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRESTORE_INPUT:
    .quad nm_XRESTORE_INPUT, hl_XRESTORE_INPUT
    .quad 0
    .quad XRESTORE_INPUT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRESTORE_INPUT
    .text
    .p2align 2
XRESTORE_INPUT:
    cmp x20, #5
    b.eq _ri_n5
    cmp x20, #4
    b.ne _ri_fail
    mov x5, #0
    b _ri_common
_ri_n5:
    ldr x5, [x22], #8
_ri_common:
    ldr x0, [x22], #8
    ldr x1, [x22], #8
    ldr x2, [x22], #8
    ldr x3, [x22], #8
    ldr x20, [x22], #8
    adrp x4, :got:blk_var
    ldr x4, [x4, :got_lo12:blk_var]
    str x5, [x4]
    cbz x5, _ri_apply
    sub sp, sp, #64
    stp x29, x30, [sp, #16]
    stp x0, x1, [sp, #32]
    str x20, [sp, #48]
    mov x0, x5
    bl _block_load_nr
    ldp x0, x1, [sp, #32]
    ldr x20, [sp, #48]
    ldp x29, x30, [sp, #16]
    add sp, sp, #64
    adrp x3, :got:block_buf
    ldr x3, [x3, :got_lo12:block_buf]
    mov x2, #1024
_ri_apply:
    adrp x4, :got:source_base
    ldr x4, [x4, :got_lo12:source_base]
    str x3, [x4]
    adrp x4, :got:source_cur
    ldr x4, [x4, :got_lo12:source_cur]
    add x6, x3, x1
    str x6, [x4]
    add x6, x3, x2
    adrp x4, :got:source_end
    ldr x4, [x4, :got_lo12:source_end]
    str x6, [x4]
    adrp x4, :got:to_in
    ldr x4, [x4, :got_lo12:to_in]
    str x1, [x4]
    adrp x4, :got:source_id
    ldr x4, [x4, :got_lo12:source_id]
    str x0, [x4]
    adrp x4, :got:line_mode
    ldr x4, [x4, :got_lo12:line_mode]
    ldr x4, [x4]
    cbz x4, _ri_ok
    adrp x4, :got:line_limit
    ldr x4, [x4, :got_lo12:line_limit]
    ldr x5, [x4]
    add x3, x3, x2
    cmp x3, x5
    b.hs _ri_next
    ldrb w4, [x3]
    cmp w4, #10
    b.eq _ri_nl
    cmp w4, #13
    b.ne _ri_next
    add x4, x3, #1
    cmp x4, x5
    b.hs _ri_next
    ldrb w6, [x4]
    cmp w6, #10
    b.ne _ri_next
    add x3, x4, #1
    b _ri_next
_ri_nl:
    add x3, x3, #1
_ri_next:
    adrp x4, :got:line_next
    ldr x4, [x4, :got_lo12:line_next]
    str x3, [x4]
_ri_ok:
    str x20, [x22, #-8]!
    mov x20, #0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_ri_fail:
    mov x1, x20
    ldr x20, [x22], #8
_ri_drop:
    cbz x1, _ri_bad
    ldr x20, [x22], #8
    sub x1, x1, #1
    b _ri_drop
_ri_bad:
    str x20, [x22, #-8]!
    mov x20, #-1
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
nm_XNTOR:
    .ascii "N>R"
    .byte 0
hl_XNTOR:
    .ascii "N>R ( xn .. x1 n -- ) ( R: -- xn .. x1 n ) move n items and the count to the return stack"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNTOR:
    .quad nm_XNTOR, hl_XNTOR
    .quad 0
    .quad XNTOR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNTOR
    .text
    .p2align 2
XNTOR:
    mov x5, x20
    mov x1, x5
_ntor_loop:
    cbz x1, _ntor_count
    ldr x2, [x22], #8
    str x2, [x23, #-8]!
    sub x1, x1, #1
    b _ntor_loop
_ntor_count:
    str x5, [x23, #-8]!
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
nm_XNRFROM:
    .ascii "NR>"
    .byte 0
hl_XNRFROM:
    .ascii "NR> ( -- xn .. x1 n ) ( R: xn .. x1 n -- ) restore n items and the count"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNRFROM:
    .quad nm_XNRFROM, hl_XNRFROM
    .quad 0
    .quad XNRFROM, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNRFROM
    .text
    .p2align 2
XNRFROM:
    ldr x5, [x23], #8
    str x20, [x22, #-8]!
    mov x1, x5
_nrfrom_loop:
    cbz x1, _nrfrom_count
    ldr x2, [x23], #8
    str x2, [x22, #-8]!
    sub x1, x1, #1
    b _nrfrom_loop
_nrfrom_count:
    mov x20, x5
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
nm_XCSPICK:
    .ascii "CS-PICK"
    .byte 0
hl_XCSPICK:
    .ascii "CS-PICK ( i*x u -- i*x x_u ) copy the uth control-flow item"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCSPICK:
    .quad nm_XCSPICK, hl_XCSPICK
    .quad 0
    .quad XCSPICK, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCSPICK
    .text
    .p2align 2
XCSPICK:
    b XPICK
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XCSROLL:
    .ascii "CS-ROLL"
    .byte 0
hl_XCSROLL:
    .ascii "CS-ROLL ( xu .. x0 u -- xu-1 .. x0 xu ) rotate the uth control-flow item to the top"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCSROLL:
    .quad nm_XCSROLL, hl_XCSROLL
    .quad 0
    .quad XCSROLL, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCSROLL
    .text
    .p2align 2
XCSROLL:
    b XROLL
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XNAME_INTERPRET:
    .ascii "NAME>INTERPRET"
    .byte 0
hl_XNAME_INTERPRET:
    .ascii "NAME>INTERPRET ( nt -- xt | 0 ) interpretation xt for a name token"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNAME_INTERPRET:
    .quad nm_XNAME_INTERPRET, hl_XNAME_INTERPRET
    .quad 0
    .quad XNAME_INTERPRET, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNAME_INTERPRET
    .text
    .p2align 2
XNAME_INTERPRET:
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
nm_XNAME_COMPILE:
    .ascii "NAME>COMPILE"
    .byte 0
hl_XNAME_COMPILE:
    .ascii "NAME>COMPILE ( nt -- x xt ) compilation semantics pair for a name token"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNAME_COMPILE:
    .quad nm_XNAME_COMPILE, hl_XNAME_COMPILE
    .quad 0
    .quad XNAME_COMPILE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNAME_COMPILE
    .text
    .p2align 2
XNAME_COMPILE:
    mov x5, x20
    ldr x0, [x5, #-8]
    tbnz x0, #63, _nc_imm
    adrp x1, :got:cfa_comma
    ldr x1, [x1, :got_lo12:cfa_comma]
    ldr x1, [x1]
    str x5, [x22, #-8]!
    mov x20, x1
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_nc_imm:
    adrp x1, :got:cfa_execute
    ldr x1, [x1, :got_lo12:cfa_execute]
    ldr x1, [x1]
    str x5, [x22, #-8]!
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
nm_XLIBRARY_PATH:
    .ascii "LIBRARY-PATH"
    .byte 0
hl_XLIBRARY_PATH:
    .ascii "LIBRARY-PATH ( -- c-addr u ) absolute Library directory"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLIBRARY_PATH:
    .quad nm_XLIBRARY_PATH, hl_XLIBRARY_PATH
    .quad 0
    .quad XLIBRARY_PATH, XLIBRARY_PATH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLIBRARY_PATH
    .text
    .p2align 2
XLIBRARY_PATH:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x0, :got:library_path_buf
    ldr x0, [x0, :got_lo12:library_path_buf]
    mov x1, #1024
    bl host_library_path
    mov x1, x0
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    adrp x0, :got:library_path_buf
    ldr x0, [x0, :got_lo12:library_path_buf]
    str x20, [x22, #-8]!
    mov x20, x0
    str x20, [x22, #-8]!
    mov x20, x1
XLIBRARY_PATH_END:
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
nm_XPAGE:
    .ascii "PAGE"
    .byte 0
hl_XPAGE:
    .ascii "PAGE ( -- ) clear facility terminal and home cursor"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XPAGE:
    .quad nm_XPAGE, hl_XPAGE
    .quad 0
    .quad XPAGE, XPAGE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XPAGE
    .text
    .p2align 2
XPAGE:
    mov x0, #1
    mov x1, #0
    mov x2, #0
    b _facility_op_go
XPAGE_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XAT_XY:
    .ascii "AT-XY"
    .byte 0
hl_XAT_XY:
    .ascii "AT-XY ( u1 u2 -- ) facility cursor to column u1 row u2"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAT_XY:
    .quad nm_XAT_XY, hl_XAT_XY
    .quad 0
    .quad XAT_XY, XAT_XY_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAT_XY
    .text
    .p2align 2
XAT_XY:
    mov x2, x20
    ldr x1, [x22], #8
    ldr x20, [x22], #8
    mov x0, #2
    b _facility_op_go
XAT_XY_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XAT_XY_Q:
    .ascii "AT-XY?"
    .byte 0
hl_XAT_XY_Q:
    .ascii "AT-XY? ( -- col row ) facility cursor position"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAT_XY_Q:
    .quad nm_XAT_XY_Q, hl_XAT_XY_Q
    .quad 0
    .quad XAT_XY_Q, XAT_XY_Q_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAT_XY_Q
    .text
    .p2align 2
XAT_XY_Q:
    sub sp, sp, #32
    stp x29, x30, [sp, #16]
    mov x0, sp
    add x1, sp, #8
    str xzr, [sp]
    str xzr, [sp, #8]
    bl host_facility_xy
    ldr x1, [sp]
    ldr x2, [sp, #8]
    ldp x29, x30, [sp, #16]
    add sp, sp, #32
    str x20, [x22, #-8]!
    mov x20, x1
    str x20, [x22, #-8]!
    mov x20, x2
XAT_XY_Q_END:
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
nm_XCLIP_STORE:
    .ascii "CLIP!"
    .byte 0
hl_XCLIP_STORE:
    .ascii "CLIP! ( c-addr u -- ) set host clipboard"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCLIP_STORE:
    .quad nm_XCLIP_STORE, hl_XCLIP_STORE
    .quad 0
    .quad XCLIP_STORE, XCLIP_STORE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCLIP_STORE
    .text
    .p2align 2
XCLIP_STORE:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_clip_set
    ldp x29, x30, [sp], #16
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
XCLIP_STORE_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XCLIP_FETCH:
    .ascii "CLIP@"
    .byte 0
hl_XCLIP_FETCH:
    .ascii "CLIP@ ( c-addr max -- u ) fetch host clipboard"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCLIP_FETCH:
    .quad nm_XCLIP_FETCH, hl_XCLIP_FETCH
    .quad 0
    .quad XCLIP_FETCH, XCLIP_FETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCLIP_FETCH
    .text
    .p2align 2
XCLIP_FETCH:
    mov x1, x20
    ldr x0, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_clip_get
    ldp x29, x30, [sp], #16
    mov x20, x0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
XCLIP_FETCH_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XTERM_REFRESH:
    .ascii "TERMINAL-REFRESH"
    .byte 0
hl_XTERM_REFRESH:
    .ascii "TERMINAL-REFRESH ( -- ) paint facility terminal to host console"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTERM_REFRESH:
    .quad nm_XTERM_REFRESH, hl_XTERM_REFRESH
    .quad 0
    .quad XTERM_REFRESH, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTERM_REFRESH
    .text
    .p2align 2
XTERM_REFRESH:
    mov x0, #3
    mov x1, #0
    mov x2, #0
    b _facility_op_go
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XFACILITY_OFF:
    .ascii "FACILITY-OFF"
    .byte 0
hl_XFACILITY_OFF:
    .ascii "FACILITY-OFF ( -- ) leave facility terminal mode"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFACILITY_OFF:
    .quad nm_XFACILITY_OFF, hl_XFACILITY_OFF
    .quad 0
    .quad XFACILITY_OFF, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFACILITY_OFF
    .text
    .p2align 2
XFACILITY_OFF:
    mov x0, #4
    mov x1, #0
    mov x2, #0
    b _facility_op_go
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XFACILITY_SIZE:
    .ascii "(FACILITY-SIZE)"
    .byte 0
hl_XFACILITY_SIZE:
    .ascii "(FACILITY-SIZE) ( cols rows -- ) resize facility terminal grid"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFACILITY_SIZE:
    .quad nm_XFACILITY_SIZE, hl_XFACILITY_SIZE
    .quad 0
    .quad XFACILITY_SIZE, XFACILITY_SIZE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFACILITY_SIZE
    .text
    .p2align 2
XFACILITY_SIZE:
    mov x2, x20
    ldr x1, [x22], #8
    ldr x20, [x22], #8
    mov x0, #5
    b _facility_op_go
XFACILITY_SIZE_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XFACILITY_REV:
    .ascii "FACILITY-REV"
    .byte 0
hl_XFACILITY_REV:
    .ascii "FACILITY-REV ( f -- ) reverse-video on or off for facility EMIT"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFACILITY_REV:
    .quad nm_XFACILITY_REV, hl_XFACILITY_REV
    .quad 0
    .quad XFACILITY_REV, XFACILITY_REV_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFACILITY_REV
    .text
    .p2align 2
XFACILITY_REV:
    mov x1, x20
    ldr x20, [x22], #8
    mov x0, #6
    mov x2, #0
    b _facility_op_go
XFACILITY_REV_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XFACILITY_OP_GO:
    .ascii "(XFACILITY-OP-GO)"
    .byte 0
hl_XFACILITY_OP_GO:
    .ascii "(XFACILITY-OP-GO) ( -- ) facility host hook x0=op x1 x2=args"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFACILITY_OP_GO:
    .quad nm_XFACILITY_OP_GO, hl_XFACILITY_OP_GO
    .quad 0
    .quad XFACILITY_OP_GO, XFACILITY_OP_GO_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFACILITY_OP_GO
    .text
    .p2align 2
XFACILITY_OP_GO:
_facility_op_go:
    adrp x9, :got:facility_op_hook
    ldr x9, [x9, :got_lo12:facility_op_hook]
    ldr x9, [x9]
    cbz x9, fac_op_done
    stp x29, x30, [sp, #-16]!
    blr x9
    ldp x29, x30, [sp], #16
fac_op_done:
XFACILITY_OP_GO_END:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_call_native_regs:
    stp x29, x30, [sp, #-128]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x28, x18, [sp, #64]
    stp x0, x1, [sp, #80]
    str x2, [sp, #96]
    mov x0, x2
    mov x1, #64
    bl host_icache_inval
    ldp x0, x1, [sp, #80]
    ldr x2, [sp, #96]
    mov x19, x1
    blr x2
    ldp x28, x18, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XMPROTECT:
    .ascii "MPROTECT"
    .byte 0
hl_XMPROTECT:
    .ascii "MPROTECT ( addr u prot -- ior ) protect pages prot 1=R 2=W 4=X"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XMPROTECT:
    .quad nm_XMPROTECT, hl_XMPROTECT
    .quad 0
    .quad XMPROTECT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XMPROTECT
    .text
    .p2align 2
XMPROTECT:
    mov x2, x20
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_mprotect
    ldp x29, x30, [sp], #16
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
nm_XICACHE_INVAL:
    .ascii "ICACHE-INVAL"
    .byte 0
hl_XICACHE_INVAL:
    .ascii "ICACHE-INVAL ( addr u -- ) flush the instruction cache for a range"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XICACHE_INVAL:
    .quad nm_XICACHE_INVAL, hl_XICACHE_INVAL
    .quad 0
    .quad XICACHE_INVAL, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XICACHE_INVAL
    .text
    .p2align 2
XICACHE_INVAL:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_icache_inval
    ldp x29, x30, [sp], #16
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
nm_XCALL_NATIVE:
    .ascii "CALL-NATIVE"
    .byte 0
hl_XCALL_NATIVE:
    .ascii "CALL-NATIVE ( x0 dsp code -- x0' ) call native code and save the VM"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCALL_NATIVE:
    .quad nm_XCALL_NATIVE, hl_XCALL_NATIVE
    .quad 0
    .quad XCALL_NATIVE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCALL_NATIVE
    .text
    .p2align 2
XCALL_NATIVE:
    mov x2, x20
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl _call_native_regs
    ldp x29, x30, [sp], #16
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
nm_XCALL_NATIVE_LEAF:
    .ascii "CALL-NATIVE-LEAF"
    .byte 0
hl_XCALL_NATIVE_LEAF:
    .ascii "CALL-NATIVE-LEAF ( code -- x0' ) call code with x0=0 and a BSS DSP"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XCALL_NATIVE_LEAF:
    .quad nm_XCALL_NATIVE_LEAF, hl_XCALL_NATIVE_LEAF
    .quad 0
    .quad XCALL_NATIVE_LEAF, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XCALL_NATIVE_LEAF
    .text
    .p2align 2
XCALL_NATIVE_LEAF:
    mov x2, x20
    adrp x1, :got:native_dsp_end
    ldr x1, [x1, :got_lo12:native_dsp_end]
    sub x1, x1, #64
    mov x0, #0
    stp x29, x30, [sp, #-16]!
    bl _call_native_regs
    ldp x29, x30, [sp], #16
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
nm_XALLOCATE_EXEC:
    .ascii "ALLOCATE-EXEC"
    .byte 0
hl_XALLOCATE_EXEC:
    .ascii "ALLOCATE-EXEC ( u -- a-addr ior ) RW buffer for later R+X"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XALLOCATE_EXEC:
    .quad nm_XALLOCATE_EXEC, hl_XALLOCATE_EXEC
    .quad 0
    .quad XALLOCATE_EXEC, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XALLOCATE_EXEC
    .text
    .p2align 2
XALLOCATE_EXEC:
    mov x0, x20
    cbnz x0, _ax_size
    mov x0, #0x1000
_ax_size:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    add x1, sp, #48
    str xzr, [sp, #48]
    bl host_alloc_exec
    ldr x1, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    str x1, [x22, #-8]!
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
nm_XFREE_EXEC:
    .ascii "FREE-EXEC"
    .byte 0
hl_XFREE_EXEC:
    .ascii "FREE-EXEC ( a-addr u -- ior ) release an ALLOCATE-EXEC buffer"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFREE_EXEC:
    .quad nm_XFREE_EXEC, hl_XFREE_EXEC
    .quad 0
    .quad XFREE_EXEC, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFREE_EXEC
    .text
    .p2align 2
XFREE_EXEC:
    mov x1, x20
    ldr x0, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_free_exec
    ldp x29, x30, [sp], #16
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
nm_XJIT_WPROTECT:
    .ascii "JIT-WPROTECT"
    .byte 0
hl_XJIT_WPROTECT:
    .ascii "JIT-WPROTECT ( f -- ) record write or execute mode for this thread"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XJIT_WPROTECT:
    .quad nm_XJIT_WPROTECT, hl_XJIT_WPROTECT
    .quad 0
    .quad XJIT_WPROTECT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XJIT_WPROTECT
    .text
    .p2align 2
XJIT_WPROTECT:
    cmp x20, #0
    cset x1, ne
    adrp x0, :got:jit_exec_mode
    ldr x0, [x0, :got_lo12:jit_exec_mode]
    str x1, [x0]
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
nm_XNATIVE_SMOKE:
    .ascii "NATIVE-SMOKE"
    .byte 0
hl_XNATIVE_SMOKE:
    .ascii "NATIVE-SMOKE ( -- ior ) test RW map then RX call"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XNATIVE_SMOKE:
    .quad nm_XNATIVE_SMOKE, hl_XNATIVE_SMOKE
    .quad 0
    .quad XNATIVE_SMOKE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XNATIVE_SMOKE
    .text
    .p2align 2
XNATIVE_SMOKE:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    mov x0, #0x1000
    add x1, sp, #48
    str xzr, [sp, #48]
    bl host_alloc_exec
    cbnz x0, _ns_bad
    ldr x0, [sp, #48]
    str x0, [sp, #56]
    bl host_native_ret7
    ldr x0, [sp, #56]
    mov x1, #0x1000
    mov x2, #5
    bl host_mprotect
    cbnz x0, _ns_free
    ldr x0, [sp, #56]
    mov x1, #0x1000
    bl host_icache_inval
    mov x0, #0
    adrp x1, :got:native_dsp_end
    ldr x1, [x1, :got_lo12:native_dsp_end]
    sub x1, x1, #64
    ldr x2, [sp, #56]
    bl _call_native_regs
    str x0, [sp, #64]
    ldr x0, [sp, #56]
    mov x1, #0x1000
    bl host_free_exec
    cbnz x0, _ns_bad
    ldr x0, [sp, #64]
    cmp x0, #7
    b.ne _ns_bad
    mov x0, #0
    b _ns_out
_ns_free:
    ldr x0, [sp, #56]
    mov x1, #0x1000
    bl host_free_exec
_ns_bad:
    mov x0, #-1
_ns_out:
    ldp x29, x30, [sp, #32]
    add sp, sp, #96
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
next_debug_gate:
    adrp x16, :got:next_debug
    ldr x16, [x16, :got_lo12:next_debug]
    br x16
    .section .rodata,"a",@progbits
    .p2align 3
req_included_name:
    .ascii "INCLUDED"
str_protected:
    .ascii "protected (system word)"
    .byte 10
    .byte 0
str_gmm_already:
    .ascii "? GROWMEMORYMB already used (once per session)"
    .byte 10
    .byte 0
str_gmm_small:
    .ascii "? GROWMEMORYMB needs at least 1 MB"
    .byte 10
    .byte 0
str_gmm_big:
    .ascii "? GROWMEMORYMB exceeds maximum (256 MB)"
    .byte 10
    .byte 0
str_gmm_shrink:
    .ascii "? GROWMEMORYMB cannot shrink memory"
    .byte 10
    .byte 0
str_bang:
    .ascii "!"
    .byte 0
str_twostore:
    .ascii "2!"
    .byte 0
str_twofetch:
    .ascii "2@"
    .byte 0
str_type:
    .ascii "TYPE"
    .byte 0
    .data
    .p2align 3
    .p2align 3
env_name_ptrs:
    .quad env_n_counted
    .quad env_n_aub
    .quad env_n_core
    .quad env_n_core_ext
    .quad env_n_floored
    .quad env_n_maxchar
    .quad env_n_maxn
    .quad env_n_maxu
    .quad env_n_rstack
    .quad env_n_stack
    .quad env_n_floating
    .quad env_n_float_ext
    .quad env_n_floating_stack
    .quad env_n_max_float
    .quad env_n_string
    .quad env_n_facility
    .quad env_n_facility_ext
    .quad env_n_locals
    .quad env_n_nlocals
    .quad env_n_xchar
    .quad env_n_xchar_enc
    .quad env_n_max_xchar
    .quad env_n_xchar_maxmem
    .quad env_n_double
    .quad env_n_exception
    .quad env_n_mem
    .quad env_n_search
    .quad env_n_wordlists
    .quad env_n_block
    .quad env_n_file
    .quad env_n_file_ext
env_values:
    .quad 255
    .quad 8
    .quad -1
    .quad -1
    .quad 0
    .quad 255
    .quad 9223372036854775807
    .quad -1
    .quad 512
    .quad 512
    .quad -1
    .quad -1
    .quad 16
    .quad 9218868437227405311
    .quad -1
    .quad 0
    .quad 0
    .quad -1
    .quad 32
    .quad 0
    .quad env_s_utf8
    .quad 1114111
    .quad 4
    .quad -1
    .quad -1
    .quad -1
    .quad -1
    .quad 8
    .quad -1
    .quad -1
    .quad -1
env_kinds:
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 2
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
env_n_counted:
    .ascii "/COUNTED-STRING"
    .byte 0
env_n_aub:
    .ascii "ADDRESS-UNIT-BITS"
    .byte 0
env_n_core:
    .ascii "CORE"
    .byte 0
env_n_core_ext:
    .ascii "CORE-EXT"
    .byte 0
env_n_floored:
    .ascii "FLOORED"
    .byte 0
env_n_maxchar:
    .ascii "MAX-CHAR"
    .byte 0
env_n_maxn:
    .ascii "MAX-N"
    .byte 0
env_n_maxu:
    .ascii "MAX-U"
    .byte 0
env_n_rstack:
    .ascii "RETURN-STACK-CELLS"
    .byte 0
env_n_stack:
    .ascii "STACK-CELLS"
    .byte 0
env_n_floating:
    .ascii "FLOATING"
    .byte 0
env_n_float_ext:
    .ascii "FLOAT-EXT"
    .byte 0
env_n_floating_stack:
    .ascii "FLOATING-STACK"
    .byte 0
env_n_max_float:
    .ascii "MAX-FLOAT"
    .byte 0
env_n_string:
    .ascii "STRING"
    .byte 0
env_n_facility:
    .ascii "FACILITY"
    .byte 0
env_n_facility_ext:
    .ascii "FACILITY-EXT"
    .byte 0
env_n_locals:
    .ascii "LOCALS"
    .byte 0
env_n_nlocals:
    .ascii "#LOCALS"
    .byte 0
env_n_xchar:
    .ascii "EXTENDED-CHARACTER"
    .byte 0
env_n_xchar_enc:
    .ascii "XCHAR-ENCODING"
    .byte 0
env_n_max_xchar:
    .ascii "MAX-XCHAR"
    .byte 0
env_n_xchar_maxmem:
    .ascii "XCHAR-MAXMEM"
    .byte 0
env_n_double:
    .ascii "DOUBLE"
    .byte 0
env_n_exception:
    .ascii "EXCEPTION"
    .byte 0
env_n_mem:
    .ascii "MEMORY-ALLOCATION"
    .byte 0
env_n_search:
    .ascii "SEARCH-ORDER"
    .byte 0
env_n_wordlists:
    .ascii "WORDLISTS"
    .byte 0
env_n_block:
    .ascii "BLOCK"
    .byte 0
env_n_file:
    .ascii "FILE"
    .byte 0
env_n_file_ext:
    .ascii "FILE-EXT"
    .byte 0
env_s_utf8:
    .ascii "UTF-8"
    .byte 0

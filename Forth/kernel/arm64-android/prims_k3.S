/* Generated from Forth/kernel/arm64/prims_k3.asm. Do not edit. */
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .equ LOCAL_FRAME_MAX, 16
    .equ LOCAL_MAX, 32
    .equ LOCAL_NAME_STR, 32
    .equ WORDS_MAX, 1024
    .extern next_debug
    .extern debug_break_asap
    .text
    .p2align 2
    .extern state_var
    .extern source_base
    .extern source_end
    .extern data_stack
    .extern cfa_lit
    .extern cfa_local_init
    .extern cfa_local_at
    .extern cfa_local_store
    .extern cfa_loop
    .extern cfa_plusloop
    .extern local_name_count
    .extern local_init_count
    .extern local_init_reverse
    .extern local_declaring
    .extern local_brace_phase
    .extern local_names
    .extern local_frame_depth
    .extern local_frames
    .extern local_frame_rsp
    .extern local_frame_n
    .extern _next_word
    .extern _dict_hash
    .extern _compile_cell
    .extern _cursor_load
    .extern _cursor_commit
    .extern here_ptr
    .extern host_app_open
    .extern host_app_close
    .extern host_app_blit
    .extern host_app_pblit
    .extern host_app_cblit
    .extern host_app_keyq
    .extern host_app_key
    .extern host_app_name
    .extern host_app_tone
    .extern host_app_pump
    .extern host_app_mouse
    .extern host_app_size
    .extern host_app_img_choose
    .extern host_app_img_load
    .extern host_app_img_size
    .extern host_app_img_render
    .extern host_app_file_choose
    .extern host_app_file_save_as
    .extern host_app_file_path
    .extern host_app_file_slurp
    .extern host_app_file_spew
    .extern host_oop_call
    .extern cfa_slit
    .extern slit_esc_buf
    .extern slit_esc_buf2
    .extern slit_esc_which
    .extern _putchar
    .extern emit_str
    .extern emit_cstr
    .extern _print_unsigned
    .extern latest_var
    .extern search_order
    .extern search_order_n
    .extern DODOES
    .extern words_user_base
    .extern words_filter
    .extern words_filter_len
    .extern words_nk_tmp
    .extern words_cfa
    .global _local_compile_reset
    .global _local_add_name
    .global _local_lookup
    .global _local_finalize_compile
    .global _local_frame_try_exit
    .global XLOCAL_INIT
    .global XLOCAL_AT
    .global XLOCAL_STORE
    .global XLOCAL_BRACE
    .global XSEARCH_WORDLIST
    .global XSOURCE
    .global XLEAVE
    .global XTWOSTAR
    .global XTWOSLASH
    .global XLFETCH
    .global XLSTORE
    .global _record_words_user_base_once
    .global _words_name_ptr
    .global _words_cfa_cmp
    .global _words_filter_match
    .global _print_wid_name
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XLOCAL_INIT:
    .ascii "LOCAL-INIT"
    .byte 0
hl_XLOCAL_INIT:
    .ascii "LOCAL-INIT ( n nInit rev -- ) create a locals frame"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_INIT:
    .quad nm_XLOCAL_INIT, hl_XLOCAL_INIT
    .quad 0
    .quad XLOCAL_INIT, XLOCAL_INIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_INIT
    .text
    .p2align 2
XLOCAL_INIT:
    mov x2, x20
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    cmp x0, #LOCAL_MAX
    b.ls _li_n_ok
    mov x0, #LOCAL_MAX
_li_n_ok:
    cmp x1, x0
    b.ls _li_i_ok
    mov x1, x0
_li_i_ok:
    adrp x3, :got:local_frame_depth
    ldr x3, [x3, :got_lo12:local_frame_depth]
    ldr x4, [x3]
    cmp x4, #LOCAL_FRAME_MAX
    b.hs _li_overflow
    mov x5, #LOCAL_MAX
    mul x5, x5, x4
    lsl x5, x5, #3
    adrp x6, :got:local_frames
    ldr x6, [x6, :got_lo12:local_frames]
    add x6, x6, x5
    mov x7, #0
_li_zero:
    cmp x7, x0
    b.hs _li_fill
    lsl x8, x7, #3
    str xzr, [x6, x8]
    add x7, x7, #1
    b _li_zero
_li_fill:
    cbz x2, _li_forward
    mov x7, x1
_li_rev:
    cbz x7, _li_mark
    sub x7, x7, #1
    lsl x8, x7, #3
    str x20, [x6, x8]
    ldr x20, [x22], #8
    b _li_rev
_li_forward:
    mov x7, #0
_li_fwd:
    cmp x7, x1
    b.hs _li_mark
    lsl x8, x7, #3
    str x20, [x6, x8]
    ldr x20, [x22], #8
    add x7, x7, #1
    b _li_fwd
_li_mark:
    adrp x5, :got:local_frame_rsp
    ldr x5, [x5, :got_lo12:local_frame_rsp]
    lsl x8, x4, #3
    str x23, [x5, x8]
    adrp x5, :got:local_frame_n
    ldr x5, [x5, :got_lo12:local_frame_n]
    str x0, [x5, x8]
    add x4, x4, #1
    str x4, [x3]
    b XLOCAL_INIT_END
_li_overflow:
    mov x7, x1
_li_drain:
    cbz x7, XLOCAL_INIT_END
    ldr x20, [x22], #8
    sub x7, x7, #1
    b _li_drain
XLOCAL_INIT_END:
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
nm_XLOCAL_AT:
    .ascii "(LOCAL@)"
    .byte 0
hl_XLOCAL_AT:
    .ascii "(LOCAL@) ( idx -- x ) fetch a local"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_AT:
    .quad nm_XLOCAL_AT, hl_XLOCAL_AT
    .quad 0
    .quad XLOCAL_AT, XLOCAL_AT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_AT
    .text
    .p2align 2
XLOCAL_AT:
    mov x0, x20
    adrp x1, :got:local_frame_depth
    ldr x1, [x1, :got_lo12:local_frame_depth]
    ldr x1, [x1]
    cbz x1, _lat_none
    sub x1, x1, #1
    mov x2, #LOCAL_MAX
    mul x2, x2, x1
    lsl x2, x2, #3
    adrp x3, :got:local_frames
    ldr x3, [x3, :got_lo12:local_frames]
    add x3, x3, x2
    adrp x2, :got:local_frame_n
    ldr x2, [x2, :got_lo12:local_frame_n]
    lsl x4, x1, #3
    ldr x2, [x2, x4]
    cmp x0, x2
    b.hs _lat_none
    lsl x4, x0, #3
    ldr x20, [x3, x4]
    b XLOCAL_AT_END
_lat_none:
    mov x20, #0
XLOCAL_AT_END:
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
nm_XLOCAL_STORE:
    .ascii "(LOCAL!)"
    .byte 0
hl_XLOCAL_STORE:
    .ascii "(LOCAL!) ( x idx -- ) store a local"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_STORE:
    .quad nm_XLOCAL_STORE, hl_XLOCAL_STORE
    .quad 0
    .quad XLOCAL_STORE, XLOCAL_STORE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_STORE
    .text
    .p2align 2
XLOCAL_STORE:
    mov x0, x20
    ldr x1, [x22], #8
    ldr x20, [x22], #8
    adrp x2, :got:local_frame_depth
    ldr x2, [x2, :got_lo12:local_frame_depth]
    ldr x2, [x2]
    cbz x2, XLOCAL_STORE_END
    sub x2, x2, #1
    mov x3, #LOCAL_MAX
    mul x3, x3, x2
    lsl x3, x3, #3
    adrp x4, :got:local_frames
    ldr x4, [x4, :got_lo12:local_frames]
    add x4, x4, x3
    adrp x3, :got:local_frame_n
    ldr x3, [x3, :got_lo12:local_frame_n]
    lsl x5, x2, #3
    ldr x3, [x3, x5]
    cmp x0, x3
    b.hs XLOCAL_STORE_END
    lsl x5, x0, #3
    str x1, [x4, x5]
XLOCAL_STORE_END:
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
nm_XLOCAL_BRACE:
    .ascii "{:"
    .byte 0
hl_XLOCAL_BRACE:
    .ascii "declare locals until :}"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_BRACE:
    .quad nm_XLOCAL_BRACE, hl_XLOCAL_BRACE
    .word 0, 2147483648
    .quad XLOCAL_BRACE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_BRACE
    .text
    .p2align 2
XLOCAL_BRACE:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    ldr x0, [x0]
    cbz x0, _lb_leave
    bl _local_compile_reset
    mov x0, #1
    adrp x1, :got:local_init_reverse
    ldr x1, [x1, :got_lo12:local_init_reverse]
    str x0, [x1]
    adrp x1, :got:local_brace_phase
    ldr x1, [x1, :got_lo12:local_brace_phase]
    str xzr, [x1]
_lb_loop:
    bl _next_word
    cbz x1, _lb_done
    cmp x1, #2
    b.ne _lb_bar
    ldrb w2, [x0]
    cmp w2, #':'
    b.ne _lb_bar
    ldrb w2, [x0, #1]
    cmp w2, #'}'
    b.eq _lb_done
_lb_bar:
    cmp x1, #1
    b.ne _lb_dash
    ldrb w2, [x0]
    cmp w2, #'|'
    b.ne _lb_dash
    mov x2, #1
    adrp x3, :got:local_brace_phase
    ldr x3, [x3, :got_lo12:local_brace_phase]
    str x2, [x3]
    b _lb_loop
_lb_dash:
    cmp x1, #2
    b.ne _lb_name
    ldrb w2, [x0]
    cmp w2, #'-'
    b.ne _lb_name
    ldrb w2, [x0, #1]
    cmp w2, #'-'
    b.ne _lb_name
    mov x2, #2
    adrp x3, :got:local_brace_phase
    ldr x3, [x3, :got_lo12:local_brace_phase]
    str x2, [x3]
    b _lb_loop
_lb_name:
    adrp x3, :got:local_brace_phase
    ldr x3, [x3, :got_lo12:local_brace_phase]
    ldr x3, [x3]
    cmp x3, #2
    b.eq _lb_loop
    bl _local_add_name
    adrp x3, :got:local_brace_phase
    ldr x3, [x3, :got_lo12:local_brace_phase]
    ldr x3, [x3]
    cbnz x3, _lb_loop
    adrp x2, :got:local_init_count
    ldr x2, [x2, :got_lo12:local_init_count]
    ldr x3, [x2]
    add x3, x3, #1
    str x3, [x2]
    b _lb_loop
_lb_done:
    bl _local_finalize_compile
_lb_leave:
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
nm_XLOCAL_COMPILE_RESET:
    .ascii "(LOCAL-COMPILE-RESET)"
    .byte 0
hl_XLOCAL_COMPILE_RESET:
    .ascii "(LOCAL-COMPILE-RESET) ( -- ) clear locals compile state"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_COMPILE_RESET:
    .quad nm_XLOCAL_COMPILE_RESET, hl_XLOCAL_COMPILE_RESET
    .word 0, 1073741824
    .quad XLOCAL_COMPILE_RESET, XLOCAL_COMPILE_RESET_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_COMPILE_RESET
    .text
    .p2align 2
XLOCAL_COMPILE_RESET:
_local_compile_reset:
    adrp x0, :got:local_name_count
    ldr x0, [x0, :got_lo12:local_name_count]
    str xzr, [x0]
    adrp x0, :got:local_init_count
    ldr x0, [x0, :got_lo12:local_init_count]
    str xzr, [x0]
    adrp x0, :got:local_init_reverse
    ldr x0, [x0, :got_lo12:local_init_reverse]
    str xzr, [x0]
    adrp x0, :got:local_declaring
    ldr x0, [x0, :got_lo12:local_declaring]
    str xzr, [x0]
    ret
XLOCAL_COMPILE_RESET_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XLOCAL_ADD_NAME:
    .ascii "(LOCAL-ADD-NAME)"
    .byte 0
hl_XLOCAL_ADD_NAME:
    .ascii "(LOCAL-ADD-NAME) ( -- ) add one local name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_ADD_NAME:
    .quad nm_XLOCAL_ADD_NAME, hl_XLOCAL_ADD_NAME
    .word 0, 1073741824
    .quad XLOCAL_ADD_NAME, XLOCAL_ADD_NAME_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_ADD_NAME
    .text
    .p2align 2
XLOCAL_ADD_NAME:
_local_add_name:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    mov x19, x0
    mov x20, x1
    adrp x0, :got:local_name_count
    ldr x0, [x0, :got_lo12:local_name_count]
    ldr x1, [x0]
    cmp x1, #LOCAL_MAX
    b.hs _lan_done
    mov x2, #LOCAL_NAME_STR
    mul x2, x2, x1
    adrp x3, :got:local_names
    ldr x3, [x3, :got_lo12:local_names]
    add x3, x3, x2
    cmp x20, #31
    b.ls _lan_len
    mov x20, #31
_lan_len:
    strb w20, [x3], #1
    mov x2, #0
_lan_cp:
    cmp x2, x20
    b.hs _lan_count
    ldrb w4, [x19, x2]
    cmp w4, #'a'
    b.lo _lan_st
    cmp w4, #'z'
    b.hi _lan_st
    sub w4, w4, #32
_lan_st:
    strb w4, [x3, x2]
    add x2, x2, #1
    b _lan_cp
_lan_count:
    adrp x0, :got:local_name_count
    ldr x0, [x0, :got_lo12:local_name_count]
    ldr x1, [x0]
    add x1, x1, #1
    str x1, [x0]
_lan_done:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
XLOCAL_ADD_NAME_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XLOCAL_LOOKUP:
    .ascii "(LOCAL-LOOKUP)"
    .byte 0
hl_XLOCAL_LOOKUP:
    .ascii "(LOCAL-LOOKUP) ( -- ) local name index or -1"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_LOOKUP:
    .quad nm_XLOCAL_LOOKUP, hl_XLOCAL_LOOKUP
    .word 0, 1073741824
    .quad XLOCAL_LOOKUP, XLOCAL_LOOKUP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_LOOKUP
    .text
    .p2align 2
XLOCAL_LOOKUP:
_local_lookup:
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    mov x19, x0
    mov x20, x1
    adrp x0, :got:local_name_count
    ldr x0, [x0, :got_lo12:local_name_count]
    ldr x21, [x0]
    mov x22, #0
_ll_loop:
    cmp x22, x21
    b.hs _ll_miss
    mov x2, #LOCAL_NAME_STR
    mul x2, x2, x22
    adrp x3, :got:local_names
    ldr x3, [x3, :got_lo12:local_names]
    add x3, x3, x2
    ldrb w2, [x3], #1
    cmp x2, x20
    b.ne _ll_next
    mov x4, #0
_ll_cmp:
    cmp x4, x20
    b.hs _ll_hit
    ldrb w5, [x3, x4]
    ldrb w6, [x19, x4]
    cmp w6, #'a'
    b.lo _ll_fold
    cmp w6, #'z'
    b.hi _ll_fold
    sub w6, w6, #32
_ll_fold:
    cmp w5, w6
    b.ne _ll_next
    add x4, x4, #1
    b _ll_cmp
_ll_next:
    add x22, x22, #1
    b _ll_loop
_ll_miss:
    mov x0, #-1
    b _ll_out
_ll_hit:
    mov x0, x22
_ll_out:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ret
XLOCAL_LOOKUP_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XLOCAL_FINALIZE:
    .ascii "(LOCAL-FINALIZE)"
    .byte 0
hl_XLOCAL_FINALIZE:
    .ascii "(LOCAL-FINALIZE) ( -- ) compile LOCAL-INIT"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_FINALIZE:
    .quad nm_XLOCAL_FINALIZE, hl_XLOCAL_FINALIZE
    .word 0, 1073741824
    .quad XLOCAL_FINALIZE, XLOCAL_FINALIZE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_FINALIZE
    .text
    .p2align 2
XLOCAL_FINALIZE:
_local_finalize_compile:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    adrp x0, :got:local_name_count
    ldr x0, [x0, :got_lo12:local_name_count]
    ldr x0, [x0]
    bl _compile_cell
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    adrp x0, :got:local_init_count
    ldr x0, [x0, :got_lo12:local_init_count]
    ldr x0, [x0]
    bl _compile_cell
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    adrp x0, :got:local_init_reverse
    ldr x0, [x0, :got_lo12:local_init_reverse]
    ldr x0, [x0]
    bl _compile_cell
    adrp x0, :got:cfa_local_init
    ldr x0, [x0, :got_lo12:cfa_local_init]
    ldr x0, [x0]
    bl _compile_cell
    ldp x29, x30, [sp], #16
    ret
XLOCAL_FINALIZE_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XLOCAL_FRAME_TRY_EXIT:
    .ascii "(LOCAL-FRAME-EXIT)"
    .byte 0
hl_XLOCAL_FRAME_TRY_EXIT:
    .ascii "(LOCAL-FRAME-EXIT) ( -- ) pop locals frame when RSP matches"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLOCAL_FRAME_TRY_EXIT:
    .quad nm_XLOCAL_FRAME_TRY_EXIT, hl_XLOCAL_FRAME_TRY_EXIT
    .word 0, 1073741824
    .quad XLOCAL_FRAME_TRY_EXIT, XLOCAL_FRAME_TRY_EXIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLOCAL_FRAME_TRY_EXIT
    .text
    .p2align 2
XLOCAL_FRAME_TRY_EXIT:
_local_frame_try_exit:
    adrp x0, :got:local_frame_depth
    ldr x0, [x0, :got_lo12:local_frame_depth]
    ldr x1, [x0]
    cbz x1, _lfe_done
    sub x1, x1, #1
    adrp x2, :got:local_frame_rsp
    ldr x2, [x2, :got_lo12:local_frame_rsp]
    lsl x3, x1, #3
    ldr x2, [x2, x3]
    cmp x2, x23
    b.ne _lfe_done
    str x1, [x0]
_lfe_done:
    ret
XLOCAL_FRAME_TRY_EXIT_END:
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XSEARCH_WORDLIST:
    .ascii "SEARCH-WORDLIST"
    .byte 0
hl_XSEARCH_WORDLIST:
    .ascii "SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) find in one wordlist"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSEARCH_WORDLIST:
    .quad nm_XSEARCH_WORDLIST, hl_XSEARCH_WORDLIST
    .quad 0
    .quad XSEARCH_WORDLIST, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSEARCH_WORDLIST
    .text
    .p2align 2
XSEARCH_WORDLIST:
    mov x9, x20
    ldr x8, [x22], #8
    ldr x7, [x22], #8
    cbz x9, _swl_zero
    cbz x8, _swl_zero
    stp x7, x8, [sp, #-16]!
    str x9, [sp, #-16]!
    mov x0, x7
    mov x1, x8
    mov x12, x30
    bl _dict_hash
    mov x30, x12
    mov x10, x0
    ldr x9, [sp], #16
    ldp x7, x8, [sp], #16
    add x9, x9, x10, lsl #3
    ldr x11, [x9]
_swl_loop:
    cbz x11, _swl_zero
    ldr x2, [x11, #-8]
    and x3, x2, #0xFFFF
    sub x4, x11, x3
    ldrb w3, [x4], #1
    tbnz w3, #7, _swl_next
    and w3, w3, #0x7F
    cmp x3, x8
    b.ne _swl_next
    mov x5, #0
_swl_cmp:
    cmp x5, x8
    b.hs _swl_hit
    ldrb w6, [x4, x5]
    ldrb w10, [x7, x5]
    cmp w10, #'a'
    b.lo _swl_fold
    cmp w10, #'z'
    b.hi _swl_fold
    sub w10, w10, #32
_swl_fold:
    cmp w6, w10
    b.ne _swl_next
    add x5, x5, #1
    b _swl_cmp
_swl_hit:
    ldr x1, [x11, #-8]
    tbnz x1, #63, _swl_imm
    mov x4, #-1
    b _swl_push
_swl_imm:
    mov x4, #1
_swl_push:
    str x11, [x22, #-8]!
    mov x20, x4
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_swl_next:
    ldr x11, [x11, #-16]
    b _swl_loop
_swl_zero:
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
nm_XSOURCE:
    .ascii "SOURCE"
    .byte 0
hl_XSOURCE:
    .ascii "SOURCE ( -- c-addr u ) current input buffer and length"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSOURCE:
    .quad nm_XSOURCE, hl_XSOURCE
    .quad 0
    .quad XSOURCE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSOURCE
    .text
    .p2align 2
XSOURCE:
    adrp x0, :got:source_base
    ldr x0, [x0, :got_lo12:source_base]
    ldr x0, [x0]
    adrp x1, :got:source_end
    ldr x1, [x1, :got_lo12:source_end]
    ldr x1, [x1]
    sub x1, x1, x0
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
nm_XLEAVE:
    .ascii "LEAVE"
    .byte 0
hl_XLEAVE:
    .ascii "LEAVE ( -- ) exit the current DO loop"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLEAVE:
    .quad nm_XLEAVE, hl_XLEAVE
    .quad 0
    .quad XLEAVE, XLEAVE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLEAVE
    .text
    .p2align 2
XLEAVE:
    add x23, x23, #16
    adrp x1, :got:cfa_loop
    ldr x1, [x1, :got_lo12:cfa_loop]
    ldr x1, [x1]
    adrp x2, :got:cfa_plusloop
    ldr x2, [x2, :got_lo12:cfa_plusloop]
    ldr x2, [x2]
_leave_scan:
    ldr x0, [x19], #8
    cmp x0, x1
    b.eq _leave_skip
    cmp x0, x2
    b.ne _leave_scan
_leave_skip:
    add x19, x19, #8
XLEAVE_END:
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
nm_XTWOSTAR:
    .ascii "2*"
    .byte 0
hl_XTWOSTAR:
    .ascii "2* ( x1 -- x2 ) shift left one bit"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTWOSTAR:
    .quad nm_XTWOSTAR, hl_XTWOSTAR
    .quad 0
    .quad XTWOSTAR, XTWOSTAR_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTWOSTAR
    .text
    .p2align 2
XTWOSTAR:
    lsl x20, x20, #1
XTWOSTAR_END:
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
nm_XTWOSLASH:
    .ascii "2/"
    .byte 0
hl_XTWOSLASH:
    .ascii "2/ ( x1 -- x2 ) arithmetic shift right one bit"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTWOSLASH:
    .quad nm_XTWOSLASH, hl_XTWOSLASH
    .quad 0
    .quad XTWOSLASH, XTWOSLASH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTWOSLASH
    .text
    .p2align 2
XTWOSLASH:
    asr x20, x20, #1
XTWOSLASH_END:
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
nm_XLFETCH:
    .ascii "L@"
    .byte 0
hl_XLFETCH:
    .ascii "L@ ( addr -- u ) fetch 32 bits zero-extended"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLFETCH:
    .quad nm_XLFETCH, hl_XLFETCH
    .quad 0
    .quad XLFETCH, XLFETCH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLFETCH
    .text
    .p2align 2
XLFETCH:
    ldr w20, [x20]
XLFETCH_END:
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
nm_XLSTORE:
    .ascii "L!"
    .byte 0
hl_XLSTORE:
    .ascii "L! ( u addr -- ) store 32 bits"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XLSTORE:
    .quad nm_XLSTORE, hl_XLSTORE
    .quad 0
    .quad XLSTORE, XLSTORE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XLSTORE
    .text
    .p2align 2
XLSTORE:
    ldr x0, [x22], #8
    str w0, [x20]
    ldr x20, [x22], #8
XLSTORE_END:
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
nm_XAPP_OPEN:
    .ascii "(APP-OPEN)"
    .byte 0
hl_XAPP_OPEN:
    .ascii "(APP-OPEN) ( cols rows -- ior ) open a character graphics window"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_OPEN:
    .quad nm_XAPP_OPEN, hl_XAPP_OPEN
    .quad 0
    .quad XAPP_OPEN, XAPP_OPEN_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_OPEN
    .text
    .p2align 2
XAPP_OPEN:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_open
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_OPEN_END:
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
nm_XOOP_CALL:
    .ascii "(OOP-CALL)"
    .byte 0
hl_XOOP_CALL:
    .ascii "(OOP-CALL) ( a b c d op -- n ) OOP window host"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XOOP_CALL:
    .quad nm_XOOP_CALL, hl_XOOP_CALL
    .quad 0
    .quad XOOP_CALL, XOOP_CALL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XOOP_CALL
    .text
    .p2align 2
XOOP_CALL:
    mov x4, x20
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_oop_call
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XOOP_CALL_END:
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
nm_XAPP_CLOSE:
    .ascii "(APP-CLOSE)"
    .byte 0
hl_XAPP_CLOSE:
    .ascii "(APP-CLOSE) ( -- ) close the character graphics window"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_CLOSE:
    .quad nm_XAPP_CLOSE, hl_XAPP_CLOSE
    .quad 0
    .quad XAPP_CLOSE, XAPP_CLOSE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_CLOSE
    .text
    .p2align 2
XAPP_CLOSE:
    stp x29, x30, [sp, #-16]!
    bl host_app_close
    ldp x29, x30, [sp], #16
XAPP_CLOSE_END:
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
nm_XAPP_BLIT:
    .ascii "(APP-BLIT)"
    .byte 0
hl_XAPP_BLIT:
    .ascii "(APP-BLIT) ( c-addr u -- ) blit the character buffer to the window"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_BLIT:
    .quad nm_XAPP_BLIT, hl_XAPP_BLIT
    .quad 0
    .quad XAPP_BLIT, XAPP_BLIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_BLIT
    .text
    .p2align 2
XAPP_BLIT:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_blit
    ldp x29, x30, [sp], #16
XAPP_BLIT_END:
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
nm_XAPP_PBLIT:
    .ascii "(APP-PBLIT)"
    .byte 0
hl_XAPP_PBLIT:
    .ascii "(APP-PBLIT) ( c-addr u -- ) blit a 1-bit pixel map to the window"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_PBLIT:
    .quad nm_XAPP_PBLIT, hl_XAPP_PBLIT
    .quad 0
    .quad XAPP_PBLIT, XAPP_PBLIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_PBLIT
    .text
    .p2align 2
XAPP_PBLIT:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_pblit
    ldp x29, x30, [sp], #16
XAPP_PBLIT_END:
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
nm_XAPP_CBLIT:
    .ascii "(APP-CBLIT)"
    .byte 0
hl_XAPP_CBLIT:
    .ascii "(APP-CBLIT) ( c-addr u depth -- ) blit pixels of depth 1 8 or 32"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_CBLIT:
    .quad nm_XAPP_CBLIT, hl_XAPP_CBLIT
    .quad 0
    .quad XAPP_CBLIT, XAPP_CBLIT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_CBLIT
    .text
    .p2align 2
XAPP_CBLIT:
    mov x2, x20
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_cblit
    ldp x29, x30, [sp], #16
XAPP_CBLIT_END:
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
nm_XAPP_KEYQ:
    .ascii "(APP-KEY?)"
    .byte 0
hl_XAPP_KEYQ:
    .ascii "(APP-KEY?) ( -- flag ) true when a graphics key is waiting"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_KEYQ:
    .quad nm_XAPP_KEYQ, hl_XAPP_KEYQ
    .quad 0
    .quad XAPP_KEYQ, XAPP_KEYQ_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_KEYQ
    .text
    .p2align 2
XAPP_KEYQ:
    stp x29, x30, [sp, #-16]!
    bl host_app_keyq
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_KEYQ_END:
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
nm_XAPP_KEY:
    .ascii "(APP-KEY)"
    .byte 0
hl_XAPP_KEY:
    .ascii "(APP-KEY) ( -- c ) next graphics key or -1 on timeout"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_KEY:
    .quad nm_XAPP_KEY, hl_XAPP_KEY
    .quad 0
    .quad XAPP_KEY, XAPP_KEY_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_KEY
    .text
    .p2align 2
XAPP_KEY:
    stp x29, x30, [sp, #-16]!
    bl host_app_key
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_KEY_END:
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
nm_XAPP_NAME:
    .ascii "(APP-NAME)"
    .byte 0
hl_XAPP_NAME:
    .ascii "(APP-NAME) ( c-addr u -- ) set the graphics window title"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_NAME:
    .quad nm_XAPP_NAME, hl_XAPP_NAME
    .quad 0
    .quad XAPP_NAME, XAPP_NAME_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_NAME
    .text
    .p2align 2
XAPP_NAME:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_name
    ldp x29, x30, [sp], #16
XAPP_NAME_END:
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
nm_XAPP_TONE:
    .ascii "(APP-TONE)"
    .byte 0
hl_XAPP_TONE:
    .ascii "(APP-TONE) ( freq dur -- ) play a tone for dur tenths of a second"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_TONE:
    .quad nm_XAPP_TONE, hl_XAPP_TONE
    .quad 0
    .quad XAPP_TONE, XAPP_TONE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_TONE
    .text
    .p2align 2
XAPP_TONE:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_tone
    ldp x29, x30, [sp], #16
XAPP_TONE_END:
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
nm_XAPP_PUMP:
    .ascii "(APP-PUMP)"
    .byte 0
hl_XAPP_PUMP:
    .ascii "(APP-PUMP) ( -- ) yield so the graphics window can run"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_PUMP:
    .quad nm_XAPP_PUMP, hl_XAPP_PUMP
    .quad 0
    .quad XAPP_PUMP, XAPP_PUMP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_PUMP
    .text
    .p2align 2
XAPP_PUMP:
    stp x29, x30, [sp, #-16]!
    bl host_app_pump
    ldp x29, x30, [sp], #16
XAPP_PUMP_END:
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
nm_XAPP_MOUSE:
    .ascii "(APP-MOUSE)"
    .byte 0
hl_XAPP_MOUSE:
    .ascii "(APP-MOUSE) ( -- x y buttons ) graphics mouse in plot coordinates"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_MOUSE:
    .quad nm_XAPP_MOUSE, hl_XAPP_MOUSE
    .quad 0
    .quad XAPP_MOUSE, XAPP_MOUSE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_MOUSE
    .text
    .p2align 2
XAPP_MOUSE:
    stp x29, x30, [sp, #-16]!
    sub sp, sp, #32
    mov x0, sp
    add x1, sp, #8
    add x2, sp, #16
    str xzr, [sp]
    str xzr, [sp, #8]
    str xzr, [sp, #16]
    bl host_app_mouse
    ldr x0, [sp]
    ldr x1, [sp, #8]
    ldr x2, [sp, #16]
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    str x0, [x22, #-8]!
    str x1, [x22, #-8]!
    mov x20, x2
XAPP_MOUSE_END:
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
nm_XAPP_SIZE:
    .ascii "(APP-SIZE?)"
    .byte 0
hl_XAPP_SIZE:
    .ascii "(APP-SIZE?) ( -- cols rows flag ) pending grid after a resize"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_SIZE:
    .quad nm_XAPP_SIZE, hl_XAPP_SIZE
    .quad 0
    .quad XAPP_SIZE, XAPP_SIZE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_SIZE
    .text
    .p2align 2
XAPP_SIZE:
    stp x29, x30, [sp, #-16]!
    sub sp, sp, #32
    mov x0, sp
    add x1, sp, #8
    str xzr, [sp]
    str xzr, [sp, #8]
    bl host_app_size
    ldr x1, [sp]
    ldr x2, [sp, #8]
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    str x1, [x22, #-8]!
    str x2, [x22, #-8]!
    mov x20, x0
XAPP_SIZE_END:
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
nm_XAPP_IMG_CHOOSE:
    .ascii "(APP-IMG-CHOOSE)"
    .byte 0
hl_XAPP_IMG_CHOOSE:
    .ascii "(APP-IMG-CHOOSE) ( -- ior ) choose an image file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_IMG_CHOOSE:
    .quad nm_XAPP_IMG_CHOOSE, hl_XAPP_IMG_CHOOSE
    .quad 0
    .quad XAPP_IMG_CHOOSE, XAPP_IMG_CHOOSE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_IMG_CHOOSE
    .text
    .p2align 2
XAPP_IMG_CHOOSE:
    stp x29, x30, [sp, #-16]!
    bl host_app_img_choose
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_IMG_CHOOSE_END:
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
nm_XAPP_IMG_LOAD:
    .ascii "(APP-IMG-LOAD)"
    .byte 0
hl_XAPP_IMG_LOAD:
    .ascii "(APP-IMG-LOAD) ( c-addr u -- ior ) load an image from a path"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_IMG_LOAD:
    .quad nm_XAPP_IMG_LOAD, hl_XAPP_IMG_LOAD
    .quad 0
    .quad XAPP_IMG_LOAD, XAPP_IMG_LOAD_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_IMG_LOAD
    .text
    .p2align 2
XAPP_IMG_LOAD:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_img_load
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_IMG_LOAD_END:
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
nm_XAPP_IMG_SIZE:
    .ascii "(APP-IMG-SIZE)"
    .byte 0
hl_XAPP_IMG_SIZE:
    .ascii "(APP-IMG-SIZE) ( -- w h ) loaded image size in pixels"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_IMG_SIZE:
    .quad nm_XAPP_IMG_SIZE, hl_XAPP_IMG_SIZE
    .quad 0
    .quad XAPP_IMG_SIZE, XAPP_IMG_SIZE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_IMG_SIZE
    .text
    .p2align 2
XAPP_IMG_SIZE:
    stp x29, x30, [sp, #-16]!
    sub sp, sp, #32
    mov x0, sp
    add x1, sp, #8
    str xzr, [sp]
    str xzr, [sp, #8]
    bl host_app_img_size
    ldr x0, [sp]
    ldr x1, [sp, #8]
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    str x0, [x22, #-8]!
    mov x20, x1
XAPP_IMG_SIZE_END:
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
nm_XAPP_IMG_RENDER:
    .ascii "(APP-IMG-RENDER)"
    .byte 0
hl_XAPP_IMG_RENDER:
    .ascii "(APP-IMG-RENDER) ( c-addr w h cx cy zoom100 -- ior ) render the image into BGRA"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_IMG_RENDER:
    .quad nm_XAPP_IMG_RENDER, hl_XAPP_IMG_RENDER
    .quad 0
    .quad XAPP_IMG_RENDER, XAPP_IMG_RENDER_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_IMG_RENDER
    .text
    .p2align 2
XAPP_IMG_RENDER:
    mov x5, x20
    ldr x4, [x22], #8
    ldr x3, [x22], #8
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_img_render
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_IMG_RENDER_END:
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
nm_XAPP_FILE_CHOOSE:
    .ascii "(APP-FILE-CHOOSE)"
    .byte 0
hl_XAPP_FILE_CHOOSE:
    .ascii "(APP-FILE-CHOOSE) ( -- ior ) choose a file and stage its path"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_FILE_CHOOSE:
    .quad nm_XAPP_FILE_CHOOSE, hl_XAPP_FILE_CHOOSE
    .quad 0
    .quad XAPP_FILE_CHOOSE, XAPP_FILE_CHOOSE_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_FILE_CHOOSE
    .text
    .p2align 2
XAPP_FILE_CHOOSE:
    stp x29, x30, [sp, #-16]!
    bl host_app_file_choose
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_FILE_CHOOSE_END:
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
nm_XAPP_FILE_SAVE_AS:
    .ascii "(APP-FILE-SAVE-AS)"
    .byte 0
hl_XAPP_FILE_SAVE_AS:
    .ascii "(APP-FILE-SAVE-AS) ( -- ior ) choose a save path and stage it"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_FILE_SAVE_AS:
    .quad nm_XAPP_FILE_SAVE_AS, hl_XAPP_FILE_SAVE_AS
    .quad 0
    .quad XAPP_FILE_SAVE_AS, XAPP_FILE_SAVE_AS_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_FILE_SAVE_AS
    .text
    .p2align 2
XAPP_FILE_SAVE_AS:
    stp x29, x30, [sp, #-16]!
    bl host_app_file_save_as
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_FILE_SAVE_AS_END:
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
nm_XAPP_FILE_PATH:
    .ascii "(APP-FILE-PATH)"
    .byte 0
hl_XAPP_FILE_PATH:
    .ascii "(APP-FILE-PATH) ( c-addr u -- u2 ) copy the staged file path"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_FILE_PATH:
    .quad nm_XAPP_FILE_PATH, hl_XAPP_FILE_PATH
    .quad 0
    .quad XAPP_FILE_PATH, XAPP_FILE_PATH_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_FILE_PATH
    .text
    .p2align 2
XAPP_FILE_PATH:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_file_path
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_FILE_PATH_END:
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
nm_XAPP_FILE_SLURP:
    .ascii "(APP-FILE-SLURP)"
    .byte 0
hl_XAPP_FILE_SLURP:
    .ascii "(APP-FILE-SLURP) ( c-addr max -- u ior ) read the staged file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_FILE_SLURP:
    .quad nm_XAPP_FILE_SLURP, hl_XAPP_FILE_SLURP
    .quad 0
    .quad XAPP_FILE_SLURP, XAPP_FILE_SLURP_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_FILE_SLURP
    .text
    .p2align 2
XAPP_FILE_SLURP:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    sub sp, sp, #16
    mov x2, sp
    str xzr, [sp]
    bl host_app_file_slurp
    ldr x1, [sp]
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    str x1, [x22, #-8]!
    mov x20, x0
XAPP_FILE_SLURP_END:
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
nm_XAPP_FILE_SPEW:
    .ascii "(APP-FILE-SPEW)"
    .byte 0
hl_XAPP_FILE_SPEW:
    .ascii "(APP-FILE-SPEW) ( c-addr u -- ior ) write bytes to the staged file"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XAPP_FILE_SPEW:
    .quad nm_XAPP_FILE_SPEW, hl_XAPP_FILE_SPEW
    .quad 0
    .quad XAPP_FILE_SPEW, XAPP_FILE_SPEW_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XAPP_FILE_SPEW
    .text
    .p2align 2
XAPP_FILE_SPEW:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_app_file_spew
    ldp x29, x30, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
XAPP_FILE_SPEW_END:
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
nm_XSESCAPE:
    .ascii "S"
    .byte 92
    .byte 34
    .byte 0
hl_XSESCAPE:
    .ascii "S"
    .byte 92
    .byte 34
    .ascii "escaped string"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XSESCAPE:
    .quad nm_XSESCAPE, hl_XSESCAPE
    .word 0, 2147483648
    .quad XSESCAPE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XSESCAPE
    .text
    .p2align 2
XSESCAPE:
    sub sp, sp, #96
    stp x29, x30, [sp, #32]
    bl _cursor_load
    mov x1, x0
    adrp x6, :got:source_end
    ldr x6, [x6, :got_lo12:source_end]
    ldr x6, [x6]
    adrp x8, :got:slit_esc_which
    ldr x8, [x8, :got_lo12:slit_esc_which]
    ldr x4, [x8]
    cbnz x4, _se_buf2
    adrp x7, :got:slit_esc_buf
    ldr x7, [x7, :got_lo12:slit_esc_buf]
    mov x4, #1
    str x4, [x8]
    b _se_ready
_se_buf2:
    adrp x7, :got:slit_esc_buf2
    ldr x7, [x7, :got_lo12:slit_esc_buf2]
    str xzr, [x8]
_se_ready:
    mov x5, #0
_se_loop:
    cmp x1, x6
    b.hs _se_done
    ldrb w2, [x1], #1
    cmp w2, #34
    b.eq _se_done
    cmp w2, #92
    b.ne _se_put
    cmp x1, x6
    b.hs _se_done
    ldrb w2, [x1], #1
    cmp w2, #'a'
    b.eq _se_a
    cmp w2, #'b'
    b.eq _se_b
    cmp w2, #'e'
    b.eq _se_e
    cmp w2, #'f'
    b.eq _se_f
    cmp w2, #'l'
    b.eq _se_l
    cmp w2, #'m'
    b.eq _se_m
    cmp w2, #'n'
    b.eq _se_n
    cmp w2, #'q'
    b.eq _se_q
    cmp w2, #'r'
    b.eq _se_r
    cmp w2, #'t'
    b.eq _se_t
    cmp w2, #'v'
    b.eq _se_v
    cmp w2, #'z'
    b.eq _se_z
    cmp w2, #34
    b.eq _se_q
    cmp w2, #92
    b.eq _se_put
    cmp w2, #'x'
    b.eq _se_hex
    b _se_put
_se_a:
    mov w2, #7
    b _se_put
_se_b:
    mov w2, #8
    b _se_put
_se_e:
    mov w2, #27
    b _se_put
_se_f:
    mov w2, #12
    b _se_put
_se_l:
    mov w2, #10
    b _se_put
_se_n:
    mov w2, #10
    b _se_put
_se_q:
    mov w2, #34
    b _se_put
_se_r:
    mov w2, #13
    b _se_put
_se_t:
    mov w2, #9
    b _se_put
_se_v:
    mov w2, #11
    b _se_put
_se_z:
    mov w2, #0
    b _se_put
_se_m:
    cmp x5, #254
    b.hs _se_loop
    mov w2, #13
    strb w2, [x7, x5]
    add x5, x5, #1
    mov w2, #10
    b _se_put
_se_hex:
    mov w3, #0
    mov x4, #2
_se_hx:
    cbz x4, _se_hexput
    cmp x1, x6
    b.hs _se_hexput
    ldrb w2, [x1]
    sub w8, w2, #'0'
    cmp w8, #9
    b.ls _se_hok
    sub w8, w2, #'A'
    cmp w8, #5
    b.ls _se_hu
    sub w8, w2, #'a'
    cmp w8, #5
    b.hi _se_hexput
_se_hu:
    add w8, w8, #10
_se_hok:
    add x1, x1, #1
    lsl w3, w3, #4
    orr w3, w3, w8
    sub x4, x4, #1
    b _se_hx
_se_hexput:
    mov w2, w3
_se_put:
    cmp x5, #255
    b.hs _se_loop
    strb w2, [x7, x5]
    add x5, x5, #1
    b _se_loop
_se_done:
    stp x7, x5, [sp, #48]
    mov x0, x1
    bl _cursor_commit
    ldp x7, x5, [sp, #48]
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    ldr x0, [x0]
    cbnz x0, _se_comp
    str x20, [x22, #-8]!
    str x7, [x22, #-8]!
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
_se_comp:
    stp x7, x5, [sp, #48]
    adrp x0, :got:cfa_slit
    ldr x0, [x0, :got_lo12:cfa_slit]
    ldr x0, [x0]
    bl _compile_cell
    ldr x0, [sp, #56]
    bl _compile_cell
    ldp x7, x5, [sp, #48]
    adrp x0, :got:here_ptr
    ldr x0, [x0, :got_lo12:here_ptr]
    ldr x1, [x0]
    mov x3, #0
_se_cpy:
    cmp x3, x5
    b.ge _se_align
    ldrb w4, [x7, x3]
    strb w4, [x1, x3]
    add x3, x3, #1
    b _se_cpy
_se_align:
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
nm_XWORDS:
    .ascii "WORDS"
    .byte 0
hl_XWORDS:
    .ascii "WORDS ( [filter] -- ) list first search-order wordlist sorted"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XWORDS:
    .quad nm_XWORDS, hl_XWORDS
    .quad 0
    .quad XWORDS, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XWORDS
    .text
    .p2align 2
XWORDS:
    sub sp, sp, #112
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    stp x23, x24, [sp, #80]
    stp x25, x26, [sp, #96]
    bl _next_word
    mov x2, #63
    cmp x1, x2
    csel x1, x2, x1, hi
    adrp x2, :got:words_filter_len
    ldr x2, [x2, :got_lo12:words_filter_len]
    str x1, [x2]
    adrp x3, :got:words_filter
    ldr x3, [x3, :got_lo12:words_filter]
    mov x4, #0
_xw_filt:
    cmp x4, x1
    b.hs _xw_wid
    ldrb w5, [x0, x4]
    cmp w5, #'a'
    b.lo _xw_filt_st
    cmp w5, #'z'
    b.hi _xw_filt_st
    sub w5, w5, #32
_xw_filt_st:
    strb w5, [x3, x4]
    add x4, x4, #1
    b _xw_filt
_xw_wid:
    adrp x0, :got:search_order_n
    ldr x0, [x0, :got_lo12:search_order_n]
    ldr x0, [x0]
    cbz x0, _xw_forth
    adrp x0, :got:search_order
    ldr x0, [x0, :got_lo12:search_order]
    ldr x19, [x0]
    b _xw_pass1
_xw_forth:
    adrp x19, :got:latest_var
    ldr x19, [x19, :got_lo12:latest_var]
_xw_pass1:
    adrp x21, :got:words_cfa
    ldr x21, [x21, :got_lo12:words_cfa]
    mov x22, #0
    mov x25, #0
_xw_t1:
    cmp x25, #16
    b.hs _xw_nk
    add x0, x19, x25, lsl #3
    ldr x20, [x0]
_xw_c1:
    cbz x20, _xw_n1
    cmp x22, #WORDS_MAX
    b.hs _xw_nk
    adrp x0, :got:words_user_base
    ldr x0, [x0, :got_lo12:words_user_base]
    ldr x0, [x0]
    cbz x0, _xw_kfilt
    cmp x20, x0
    b.hs _xw_link1
_xw_kfilt:
    adrp x0, :got:words_filter_len
    ldr x0, [x0, :got_lo12:words_filter_len]
    ldr x0, [x0]
    cbz x0, _xw_keep1
    mov x0, x20
    bl _words_name_ptr
    bl _words_filter_match
    cbz x0, _xw_link1
_xw_keep1:
    str x20, [x21, x22, lsl #3]
    add x22, x22, #1
_xw_link1:
    ldr x20, [x20, #-16]
    b _xw_c1
_xw_n1:
    add x25, x25, #1
    b _xw_t1
_xw_nk:
    adrp x0, :got:words_nk_tmp
    ldr x0, [x0, :got_lo12:words_nk_tmp]
    str x22, [x0]
    adrp x0, :got:words_user_base
    ldr x0, [x0, :got_lo12:words_user_base]
    ldr x0, [x0]
    cbz x0, _xw_rev
    mov x25, #0
_xw_t2:
    cmp x25, #16
    b.hs _xw_rev
    add x0, x19, x25, lsl #3
    ldr x20, [x0]
_xw_c2:
    cbz x20, _xw_n2
    cmp x22, #WORDS_MAX
    b.hs _xw_rev
    adrp x0, :got:words_user_base
    ldr x0, [x0, :got_lo12:words_user_base]
    ldr x0, [x0]
    cmp x20, x0
    b.lo _xw_link2
    adrp x0, :got:words_filter_len
    ldr x0, [x0, :got_lo12:words_filter_len]
    ldr x0, [x0]
    cbz x0, _xw_keep2
    mov x0, x20
    bl _words_name_ptr
    bl _words_filter_match
    cbz x0, _xw_link2
_xw_keep2:
    str x20, [x21, x22, lsl #3]
    add x22, x22, #1
_xw_link2:
    ldr x20, [x20, #-16]
    b _xw_c2
_xw_n2:
    add x25, x25, #1
    b _xw_t2
_xw_rev:
    adrp x0, :got:words_nk_tmp
    ldr x0, [x0, :got_lo12:words_nk_tmp]
    ldr x0, [x0]
    cmp x22, x0
    b.ls _xw_sort
    sub x1, x22, #1
_xw_rev_loop:
    cmp x0, x1
    b.ge _xw_sort
    ldr x2, [x21, x0, lsl #3]
    ldr x3, [x21, x1, lsl #3]
    str x3, [x21, x0, lsl #3]
    str x2, [x21, x1, lsl #3]
    add x0, x0, #1
    sub x1, x1, #1
    b _xw_rev_loop
_xw_sort:
    mov x1, #1
_xw_sort_i:
    adrp x0, :got:words_nk_tmp
    ldr x0, [x0, :got_lo12:words_nk_tmp]
    ldr x0, [x0]
    cmp x1, x0
    b.hs _xw_hdr
    ldr x2, [x21, x1, lsl #3]
    mov x3, x1
_xw_sort_j:
    cbz x3, _xw_sort_put
    sub x4, x3, #1
    ldr x5, [x21, x4, lsl #3]
    stp x1, x2, [sp, #-16]!
    stp x3, x4, [sp, #-16]!
    mov x0, x5
    mov x1, x2
    bl _words_cfa_cmp
    ldp x3, x4, [sp], #16
    ldp x1, x2, [sp], #16
    cmp x0, #0
    b.le _xw_sort_put
    ldr x5, [x21, x4, lsl #3]
    str x5, [x21, x3, lsl #3]
    mov x3, x4
    b _xw_sort_j
_xw_sort_put:
    str x2, [x21, x3, lsl #3]
    add x1, x1, #1
    b _xw_sort_i
_xw_hdr:
    mov x0, #10
    bl _putchar
    adrp x0, :got:str_words_hdr1
    ldr x0, [x0, :got_lo12:str_words_hdr1]
    bl emit_cstr
    mov x0, x19
    bl _print_wid_name
    mov x0, #32
    bl _putchar
    mov x0, #'('
    bl _putchar
    mov x0, x22
    bl _print_unsigned
    mov x0, #')'
    bl _putchar
    adrp x0, :got:str_words_hdr2
    ldr x0, [x0, :got_lo12:str_words_hdr2]
    bl emit_cstr
    mov x0, #10
    bl _putchar
    adrp x0, :got:words_nk_tmp
    ldr x0, [x0, :got_lo12:words_nk_tmp]
    ldr x0, [x0]
    cbz x0, _xw_user
    adrp x0, :got:str_words_sys
    ldr x0, [x0, :got_lo12:str_words_sys]
    bl emit_cstr
    mov x23, #0
    mov x24, #0
_xw_sys_i:
    adrp x0, :got:words_nk_tmp
    ldr x0, [x0, :got_lo12:words_nk_tmp]
    ldr x0, [x0]
    cmp x23, x0
    b.hs _xw_sys_nl
    ldr x0, [x21, x23, lsl #3]
    bl _words_name_ptr
    cbz x1, _xw_sys_sp
    stp x23, x24, [sp, #-16]!
    bl emit_str
    ldp x23, x24, [sp], #16
_xw_sys_sp:
    mov x0, #32
    bl _putchar
    add x24, x24, #1
    cmp x24, #8
    b.lo _xw_sys_next
    mov x0, #10
    bl _putchar
    mov x24, #0
_xw_sys_next:
    add x23, x23, #1
    b _xw_sys_i
_xw_sys_nl:
    cbz x24, _xw_user
    mov x0, #10
    bl _putchar
_xw_user:
    adrp x0, :got:words_nk_tmp
    ldr x0, [x0, :got_lo12:words_nk_tmp]
    ldr x0, [x0]
    cmp x22, x0
    b.ls _xw_done
    adrp x0, :got:str_words_user
    ldr x0, [x0, :got_lo12:str_words_user]
    bl emit_cstr
    adrp x0, :got:words_nk_tmp
    ldr x0, [x0, :got_lo12:words_nk_tmp]
    ldr x23, [x0]
    mov x24, #0
_xw_user_i:
    cmp x23, x22
    b.hs _xw_user_nl
    ldr x0, [x21, x23, lsl #3]
    bl _words_name_ptr
    cbz x1, _xw_user_sp
    stp x23, x24, [sp, #-16]!
    bl emit_str
    ldp x23, x24, [sp], #16
_xw_user_sp:
    mov x0, #32
    bl _putchar
    add x24, x24, #1
    cmp x24, #8
    b.lo _xw_user_next
    mov x0, #10
    bl _putchar
    mov x24, #0
_xw_user_next:
    add x23, x23, #1
    b _xw_user_i
_xw_user_nl:
    cbz x24, _xw_done
    mov x0, #10
    bl _putchar
_xw_done:
    ldp x25, x26, [sp, #96]
    ldp x23, x24, [sp, #80]
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #112
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_record_words_user_base_once:
    adrp x0, :got:words_user_base
    ldr x0, [x0, :got_lo12:words_user_base]
    ldr x1, [x0]
    cbnz x1, _rec_done
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    ldr x1, [x1]
    str x1, [x0]
_rec_done:
    ret
_words_name_ptr:
    ldr x1, [x0, #-8]
    and x1, x1, #0xFFFF
    sub x0, x0, x1
    ldrb w1, [x0], #1
    tst w1, #0x80
    b.eq _wnp_len
    mov x1, #0
    ret
_wnp_len:
    and w1, w1, #0x7F
    ret
_words_cfa_cmp:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    mov x19, x0
    mov x20, x1
    bl _words_name_ptr
    mov x21, x0
    mov x22, x1
    mov x0, x20
    bl _words_name_ptr
    mov x2, x22
    cmp x2, x1
    csel x2, x1, x2, hi
    mov x3, #0
_wcmp_ch:
    cmp x3, x2
    b.hs _wcmp_len
    ldrb w4, [x21, x3]
    ldrb w5, [x0, x3]
    cmp w4, #'a'
    b.lo _wcmp_b
    cmp w4, #'z'
    b.hi _wcmp_b
    sub w4, w4, #32
_wcmp_b:
    cmp w5, #'a'
    b.lo _wcmp_eq
    cmp w5, #'z'
    b.hi _wcmp_eq
    sub w5, w5, #32
_wcmp_eq:
    cmp w4, w5
    b.ne _wcmp_diff
    add x3, x3, #1
    b _wcmp_ch
_wcmp_len:
    cmp x22, x1
    b.eq _wcmp_zero
    mov x0, #1
    b.hs _wcmp_out
    mov x0, #-1
    b _wcmp_out
_wcmp_diff:
    mov x0, #1
    cmp w4, w5
    b.hs _wcmp_out
    mov x0, #-1
    b _wcmp_out
_wcmp_zero:
    mov x0, #0
_wcmp_out:
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    ret
_words_filter_match:
    adrp x2, :got:words_filter_len
    ldr x2, [x2, :got_lo12:words_filter_len]
    ldr x2, [x2]
    cbz x2, _wfm_yes
    adrp x3, :got:words_filter
    ldr x3, [x3, :got_lo12:words_filter]
    mov x4, #0
_wfm_start:
    add x5, x4, x2
    cmp x5, x1
    b.hi _wfm_no
    mov x6, #0
_wfm_i:
    cmp x6, x2
    b.hs _wfm_yes
    add x7, x4, x6
    ldrb w8, [x0, x7]
    cmp w8, #'a'
    b.lo _wfm_cmp
    cmp w8, #'z'
    b.hi _wfm_cmp
    sub w8, w8, #32
_wfm_cmp:
    ldrb w9, [x3, x6]
    cmp w8, w9
    b.ne _wfm_next
    add x6, x6, #1
    b _wfm_i
_wfm_next:
    add x4, x4, #1
    b _wfm_start
_wfm_no:
    mov x0, #0
    ret
_wfm_yes:
    mov x0, #1
    ret
_print_wid_name:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    mov x19, x0
    adrp x1, :got:latest_var
    ldr x1, [x1, :got_lo12:latest_var]
    cmp x19, x1
    b.ne _pwn_scan
    adrp x0, :got:str_forth_name
    ldr x0, [x0, :got_lo12:str_forth_name]
    bl emit_cstr
    b _pwn_done
_pwn_scan:
    adrp x22, :got:DODOES
    ldr x22, [x22, :got_lo12:DODOES]
    mov x20, #0
_pwn_thread:
    cmp x20, #16
    b.hs _pwn_anon
    adrp x0, :got:latest_var
    ldr x0, [x0, :got_lo12:latest_var]
    add x0, x0, x20, lsl #3
    ldr x21, [x0]
_pwn_cfa:
    cbz x21, _pwn_next_th
    ldr x0, [x21]
    cmp x0, x22
    b.ne _pwn_link
    add x0, x21, #16
    cmp x0, x19
    b.ne _pwn_link
    ldr x0, [x21, #-8]
    and x0, x0, #0xFFFF
    sub x0, x21, x0
    ldrb w1, [x0], #1
    and w1, w1, #0x7F
    mov x20, x0
    mov x21, x1
    mov x22, #0
_pwn_ch:
    cmp x22, x21
    b.hs _pwn_done
    ldrb w0, [x20, x22]
    bl _putchar
    add x22, x22, #1
    b _pwn_ch
_pwn_link:
    ldr x21, [x21, #-16]
    b _pwn_cfa
_pwn_next_th:
    add x20, x20, #1
    b _pwn_thread
_pwn_anon:
    adrp x0, :got:str_wid
    ldr x0, [x0, :got_lo12:str_wid]
    bl emit_cstr
_pwn_done:
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    ret
next_debug_gate:
    adrp x16, :got:next_debug
    ldr x16, [x16, :got_lo12:next_debug]
    br x16
    .section .rodata,"a",@progbits
    .p2align 3
str_forth_name:
    .ascii "FORTH"
    .byte 0
str_wid:
    .ascii "wid"
    .byte 0
str_words_hdr1:
    .ascii "--- "
    .byte 0
str_words_hdr2:
    .ascii " ---"
    .byte 0
str_words_sys:
    .ascii "EditForthWin System Words"
    .byte 10
    .byte 0
str_words_user:
    .ascii "EditForthWin User Words"
    .byte 10
    .byte 0

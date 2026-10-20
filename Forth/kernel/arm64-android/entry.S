/* Generated from Forth/kernel/arm64/entry.asm. Do not edit. */
    .extern next_debug
    .extern debug_break_asap
    .text
    .p2align 2
    .extern emit_hook
    .extern key_hook
    .extern facility_op_hook
    .extern kernel_inited
    .extern bye_flag
    .extern latest_var
    .extern last_cfa
    .extern here_ptr
    .extern state_var
    .extern vm_tos
    .extern vm_dsp
    .extern vm_rsp
    .extern debug_armed
    .extern source_cur
    .extern source_end
    .extern source_base
    .extern to_in
    .extern throw_handler
    .extern line_mode
    .extern line_origin
    .extern line_limit
    .extern line_next
    .extern source_id
    .extern view_src_id
    .extern view_id_sp
    .extern _view_pop_src_id
    .extern file_echo
    .extern file_echo_pos
    .extern file_echo_stack
    .extern blk_var
    .extern blk_stack
    .extern source_sp
    .extern source_stack
    .extern local_frame_depth
    .extern eval_resume_sp
    .extern eval_resume_stack
    .extern cfa_exit
    .extern cfa_lit
    .extern cfa_branch
    .extern cfa_0branch
    .extern cfa_does
    .extern cfa_slit
    .extern cfa_cstr
    .extern cfa_execute
    .extern cfa_comma
    .extern cfa_flit
    .extern cfa_local_init
    .extern cfa_local_at
    .extern cfa_local_store
    .extern cfa_loop
    .extern cfa_plusloop
    .extern _local_lookup
    .extern _local_compile_reset
    .extern noname_xt
    .extern restart_cell
    .extern data_stack
    .extern return_stack
    .extern user_dict_area
    .extern _header_build
    .extern _strlen
    .extern _find_word
    .extern _parse_number
    .extern host_float_op
    .extern XTHROW
    .extern _next_word
    .extern _compile_cell
    .extern _record_words_user_base_once
    .extern emit_str
    .extern emit_cstr
    .extern _putchar
    .extern _print_unsigned
    .extern forth_init_str
    .extern forth_init_end
    .global kernel_init
    .global _kernel_init
    .global kernel_eval
    .global _kernel_eval
    .global kernel_set_emit
    .global _kernel_set_emit
    .global kernel_set_key
    .global _kernel_set_key
    .global kernel_set_facility_op
    .global _kernel_set_facility_op
    .global _kernel_cold_common
    .global _boot_kernel
    .global _boot_cache_cfa
    .global _zcmp
    .global _vm_save
    .global _vm_load
    .global _vm_reset_stacks
    .global _interpret_loop
    .global _try_find
    .global _exec_found
    .global _compile_entry
    .global _compile_lit
    .global _try_number_after_find
    .global _interpret_empty
    .global _embed_finish
    .global _do_quit
    .global _arm_lines
    .global _take_line
    .global _push_source
    .global _pop_source
    .global _eval_resume_push
    .global _eval_resume_pop
    .global _throw_unwind_to_sp
    .global _quit_exit
    .global _embed_bye_return
    .global _embed_ret_x0
_kernel_set_emit:
kernel_set_emit:
    adrp x1, :got:emit_hook
    ldr x1, [x1, :got_lo12:emit_hook]
    str x0, [x1]
    ret
_kernel_set_key:
kernel_set_key:
    adrp x1, :got:key_hook
    ldr x1, [x1, :got_lo12:key_hook]
    str x0, [x1]
    ret
_kernel_set_facility_op:
kernel_set_facility_op:
    adrp x1, :got:facility_op_hook
    ldr x1, [x1, :got_lo12:facility_op_hook]
    str x0, [x1]
    ret
_kernel_init:
kernel_init:
    sub sp, sp, #128
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    stp x23, x24, [sp, #80]
    stp x25, x26, [sp, #96]
    stp x27, x28, [sp, #112]
    adrp x0, :got:kernel_inited
    ldr x0, [x0, :got_lo12:kernel_inited]
    ldr x1, [x0]
    cbnz x1, _kinit_already
    bl _kernel_cold_common
    bl _vm_save
    mov x1, #1
    adrp x0, :got:kernel_inited
    ldr x0, [x0, :got_lo12:kernel_inited]
    str x1, [x0]
    adrp x0, :got:forth_init_str
    ldr x0, [x0, :got_lo12:forth_init_str]
    adrp x1, :got:forth_init_end
    ldr x1, [x1, :got_lo12:forth_init_end]
    sub x1, x1, x0
    sub x1, x1, #1
    adrp x2, :got:source_base
    ldr x2, [x2, :got_lo12:source_base]
    str x0, [x2]
    adrp x2, :got:to_in
    ldr x2, [x2, :got_lo12:to_in]
    str xzr, [x2]
    adrp x2, :got:source_cur
    ldr x2, [x2, :got_lo12:source_cur]
    str x0, [x2]
    adrp x2, :got:source_end
    ldr x2, [x2, :got_lo12:source_end]
    add x0, x0, x1
    str x0, [x2]
    adrp x2, :got:throw_handler
    ldr x2, [x2, :got_lo12:throw_handler]
    str xzr, [x2]
    adrp x2, :got:bye_flag
    ldr x2, [x2, :got_lo12:bye_flag]
    str xzr, [x2]
    b _interpret_loop
_kinit_already:
    mov x0, #0
    b _embed_ret_x0
_kernel_cold_common:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    adrp x22, :got:data_stack
    ldr x22, [x22, :got_lo12:data_stack]
    add x22, x22, #1, lsl #12
    adrp x23, :got:return_stack
    ldr x23, [x23, :got_lo12:return_stack]
    add x23, x23, #1, lsl #12
    adrp x24, :got:latest_var
    ldr x24, [x24, :got_lo12:latest_var]
    mov x20, #0
    mov x28, #0
    mov x0, x24
    mov x1, #16
_cold_clear:
    str xzr, [x0], #8
    subs x1, x1, #1
    b.ne _cold_clear
    adrp x0, :got:last_cfa
    ldr x0, [x0, :got_lo12:last_cfa]
    str xzr, [x0]
    adrp x0, :got:here_ptr
    ldr x0, [x0, :got_lo12:here_ptr]
    adrp x1, :got:user_dict_area
    ldr x1, [x1, :got_lo12:user_dict_area]
    str x1, [x0]
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    str xzr, [x0]
    adrp x0, :got:bye_flag
    ldr x0, [x0, :got_lo12:bye_flag]
    str xzr, [x0]
    bl _boot_kernel
    adrp x24, :got:latest_var
    ldr x24, [x24, :got_lo12:latest_var]
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    ret
_boot_kernel:
    sub sp, sp, #112
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    stp x23, x24, [sp, #80]
    str x25, [sp, #96]
    adrp x19, :got:bootptr_start
    ldr x19, [x19, :got_lo12:bootptr_start]
    adrp x25, :got:bootptr_end
    ldr x25, [x25, :got_lo12:bootptr_end]
_bk_loop:
    cmp x19, x25
    b.hs _bk_done
    ldr x7, [x19], #8
    cbz x7, _bk_loop
    ldr x20, [x7]
    cbz x20, _bk_loop
    ldr x21, [x7, #8]
    ldr x22, [x7, #16]
    ldr x23, [x7, #24]
    mov x0, x20
    bl _strlen
    str x0, [sp, #104]
    mov x0, x21
    bl _strlen
    mov x3, x0
    ldr x1, [sp, #104]
    mov x0, x20
    mov x2, x21
    mov x4, x23
    mov x5, x22
    bl _header_build
    mov x21, x0
    mov x0, x20
    bl _boot_cache_cfa
    b _bk_loop
_bk_done:
    ldr x25, [sp, #96]
    ldp x23, x24, [sp, #80]
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #112
    ret
    .extern bootptr_start
    .extern bootptr_end
_boot_cache_cfa:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    mov x19, x0
    mov x20, x21
    adrp x1, :got:boot_cmp_lit
    ldr x1, [x1, :got_lo12:boot_cmp_lit]
    adrp x2, :got:cfa_lit
    ldr x2, [x2, :got_lo12:cfa_lit]
    bl _bcc_match
    adrp x1, :got:boot_cmp_exit
    ldr x1, [x1, :got_lo12:boot_cmp_exit]
    adrp x2, :got:cfa_exit
    ldr x2, [x2, :got_lo12:cfa_exit]
    bl _bcc_match
    adrp x1, :got:boot_cmp_branch
    ldr x1, [x1, :got_lo12:boot_cmp_branch]
    adrp x2, :got:cfa_branch
    ldr x2, [x2, :got_lo12:cfa_branch]
    bl _bcc_match
    adrp x1, :got:boot_cmp_0branch
    ldr x1, [x1, :got_lo12:boot_cmp_0branch]
    adrp x2, :got:cfa_0branch
    ldr x2, [x2, :got_lo12:cfa_0branch]
    bl _bcc_match
    adrp x1, :got:boot_cmp_does
    ldr x1, [x1, :got_lo12:boot_cmp_does]
    adrp x2, :got:cfa_does
    ldr x2, [x2, :got_lo12:cfa_does]
    bl _bcc_match
    adrp x1, :got:boot_cmp_slit
    ldr x1, [x1, :got_lo12:boot_cmp_slit]
    adrp x2, :got:cfa_slit
    ldr x2, [x2, :got_lo12:cfa_slit]
    bl _bcc_match
    adrp x1, :got:boot_cmp_cstr
    ldr x1, [x1, :got_lo12:boot_cmp_cstr]
    adrp x2, :got:cfa_cstr
    ldr x2, [x2, :got_lo12:cfa_cstr]
    bl _bcc_match
    adrp x1, :got:boot_cmp_execute
    ldr x1, [x1, :got_lo12:boot_cmp_execute]
    adrp x2, :got:cfa_execute
    ldr x2, [x2, :got_lo12:cfa_execute]
    bl _bcc_match
    adrp x1, :got:boot_cmp_comma
    ldr x1, [x1, :got_lo12:boot_cmp_comma]
    adrp x2, :got:cfa_comma
    ldr x2, [x2, :got_lo12:cfa_comma]
    bl _bcc_match
    adrp x1, :got:boot_cmp_flit
    ldr x1, [x1, :got_lo12:boot_cmp_flit]
    adrp x2, :got:cfa_flit
    ldr x2, [x2, :got_lo12:cfa_flit]
    bl _bcc_match
    adrp x1, :got:boot_cmp_linit
    ldr x1, [x1, :got_lo12:boot_cmp_linit]
    adrp x2, :got:cfa_local_init
    ldr x2, [x2, :got_lo12:cfa_local_init]
    bl _bcc_match
    adrp x1, :got:boot_cmp_lat
    ldr x1, [x1, :got_lo12:boot_cmp_lat]
    adrp x2, :got:cfa_local_at
    ldr x2, [x2, :got_lo12:cfa_local_at]
    bl _bcc_match
    adrp x1, :got:boot_cmp_lstore
    ldr x1, [x1, :got_lo12:boot_cmp_lstore]
    adrp x2, :got:cfa_local_store
    ldr x2, [x2, :got_lo12:cfa_local_store]
    bl _bcc_match
    adrp x1, :got:boot_cmp_loop
    ldr x1, [x1, :got_lo12:boot_cmp_loop]
    adrp x2, :got:cfa_loop
    ldr x2, [x2, :got_lo12:cfa_loop]
    bl _bcc_match
    adrp x1, :got:boot_cmp_ploop
    ldr x1, [x1, :got_lo12:boot_cmp_ploop]
    adrp x2, :got:cfa_plusloop
    ldr x2, [x2, :got_lo12:cfa_plusloop]
    bl _bcc_match
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    ret
_bcc_match:
    stp x29, x30, [sp, #-16]!
    stp x2, x19, [sp, #-16]!
    mov x0, x19
    bl _zcmp
    ldp x2, x19, [sp], #16
    cbnz x0, _bcc_match_no
    str x20, [x2]
_bcc_match_no:
    ldp x29, x30, [sp], #16
    ret
_zcmp:
    ldrb w2, [x0], #1
    ldrb w3, [x1], #1
    cmp w2, w3
    b.ne _zcmp_ne
    cbnz w2, _zcmp
    mov x0, #0
    ret
_zcmp_ne:
    mov x0, #1
    ret
_kernel_eval:
kernel_eval:
    sub sp, sp, #128
    stp x29, x30, [sp, #32]
    stp x19, x20, [sp, #48]
    stp x21, x22, [sp, #64]
    stp x23, x24, [sp, #80]
    stp x25, x26, [sp, #96]
    stp x27, x28, [sp, #112]
    adrp x2, :got:kernel_inited
    ldr x2, [x2, :got_lo12:kernel_inited]
    ldr x2, [x2]
    cbnz x2, _eval_go
    mov x0, #2
    neg x0, x0
    b _embed_ret_x0
_eval_go:
    adrp x2, :got:source_base
    ldr x2, [x2, :got_lo12:source_base]
    str x0, [x2]
    adrp x2, :got:to_in
    ldr x2, [x2, :got_lo12:to_in]
    str xzr, [x2]
    adrp x2, :got:source_cur
    ldr x2, [x2, :got_lo12:source_cur]
    str x0, [x2]
    adrp x2, :got:source_end
    ldr x2, [x2, :got_lo12:source_end]
    add x0, x0, x1
    str x0, [x2]
    adrp x2, :got:throw_handler
    ldr x2, [x2, :got_lo12:throw_handler]
    str xzr, [x2]
    adrp x2, :got:bye_flag
    ldr x2, [x2, :got_lo12:bye_flag]
    str xzr, [x2]
    adrp x2, :got:line_mode
    ldr x2, [x2, :got_lo12:line_mode]
    str xzr, [x2]
    adrp x2, :got:source_id
    ldr x2, [x2, :got_lo12:source_id]
    str xzr, [x2]
    adrp x2, :got:source_sp
    ldr x2, [x2, :got_lo12:source_sp]
    str xzr, [x2]
    adrp x2, :got:view_src_id
    ldr x2, [x2, :got_lo12:view_src_id]
    str xzr, [x2]
    adrp x2, :got:view_id_sp
    ldr x2, [x2, :got_lo12:view_id_sp]
    str xzr, [x2]
    adrp x2, :got:eval_resume_sp
    ldr x2, [x2, :got_lo12:eval_resume_sp]
    str xzr, [x2]
    bl _vm_load
    b _interpret_loop
_interpret_loop:
    adrp x24, :got:latest_var
    ldr x24, [x24, :got_lo12:latest_var]
    bl _check_stack
    bl _file_echo_upto_cursor
    bl _next_word
    cbz x1, _interpret_empty
    mov x25, x0
    mov x26, x1
    b _try_find
_try_find:
    adrp x2, :got:state_var
    ldr x2, [x2, :got_lo12:state_var]
    ldr x2, [x2]
    cbz x2, _try_find_dict
    mov x0, x25
    mov x1, x26
    bl _local_lookup
    cmp x0, #-1
    b.eq _try_find_dict
    mov x25, x0
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    mov x0, x25
    bl _compile_cell
    adrp x0, :got:cfa_local_at
    ldr x0, [x0, :got_lo12:cfa_local_at]
    ldr x0, [x0]
    bl _compile_cell
    b _interpret_loop
_try_find_dict:
    mov x0, x25
    mov x1, x26
    bl _find_word
    cbz x0, _try_number_after_find
    mov x2, x0
    mov x3, x1
    tbnz x3, #63, _exec_found
    adrp x6, :got:state_var
    ldr x6, [x6, :got_lo12:state_var]
    ldr x6, [x6]
    cbnz x6, _compile_entry
_exec_found:
    adrp x19, :got:restart_cell
    ldr x19, [x19, :got_lo12:restart_cell]
    mov x21, x2
    ldr x5, [x21]
    br x5
_compile_entry:
    mov x0, x2
    bl _compile_cell
    b _interpret_loop
_try_number_after_find:
    mov x0, x25
    mov x1, x26
    bl _parse_number
    cbz x0, _try_charlit
    cmp x0, #2
    b.eq _number_double
    adrp x2, :got:state_var
    ldr x2, [x2, :got_lo12:state_var]
    ldr x2, [x2]
    cbnz x2, _compile_lit
    mov x0, x1
    str x20, [x22, #-8]!
    mov x20, x0
    b _interpret_loop
_compile_lit:
    mov x25, x1
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    mov x0, x25
    bl _compile_cell
    b _interpret_loop
_number_double:
    adrp x3, :got:state_var
    ldr x3, [x3, :got_lo12:state_var]
    ldr x3, [x3]
    cbnz x3, _compile_dlit
    str x20, [x22, #-8]!
    str x1, [x22, #-8]!
    mov x20, x2
    b _interpret_loop
_compile_dlit:
    stp x1, x2, [sp, #-16]!
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    ldr x0, [sp]
    bl _compile_cell
    adrp x0, :got:cfa_lit
    ldr x0, [x0, :got_lo12:cfa_lit]
    ldr x0, [x0]
    bl _compile_cell
    ldr x0, [sp, #8]
    bl _compile_cell
    add sp, sp, #16
    b _interpret_loop
_try_charlit:
    cmp x26, #3
    b.ne _try_float
    ldrb w2, [x25]
    cmp w2, #39
    b.ne _try_float
    ldrb w2, [x25, #2]
    cmp w2, #39
    b.ne _try_float
    ldrb w1, [x25, #1]
    adrp x2, :got:state_var
    ldr x2, [x2, :got_lo12:state_var]
    ldr x2, [x2]
    cbnz x2, _compile_lit
    mov x0, x1
    str x20, [x22, #-8]!
    mov x20, x0
    b _interpret_loop
_try_float:
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    mov x0, #100
    mov x1, #0
    mov x2, x26
    mov x3, #0
    mov x4, #0
    mov x5, x25
    add x6, sp, #48
    str xzr, [sp, #48]
    str xzr, [sp, #56]
    str xzr, [sp, #64]
    bl host_float_op
    ldr x6, [sp, #48]
    ldr x7, [sp, #56]
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    cbz x6, _interpret_undef
    mov x26, x7
    adrp x2, :got:state_var
    ldr x2, [x2, :got_lo12:state_var]
    ldr x2, [x2]
    cbnz x2, _compile_flit
    mov x1, x26
    mov x0, #101
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    sub sp, sp, #80
    stp x29, x30, [sp, #32]
    add x6, sp, #48
    str xzr, [sp, #48]
    str xzr, [sp, #56]
    str xzr, [sp, #64]
    bl host_float_op
    ldp x29, x30, [sp, #32]
    add sp, sp, #80
    b _interpret_loop
_compile_flit:
    mov x25, x26
    adrp x0, :got:cfa_flit
    ldr x0, [x0, :got_lo12:cfa_flit]
    ldr x0, [x0]
    bl _compile_cell
    mov x0, x25
    bl _compile_cell
    b _interpret_loop
_interpret_undef:
    mov x0, x25
    mov x1, x26
    bl emit_str
    adrp x0, :got:msg_huh
    ldr x0, [x0, :got_lo12:msg_huh]
    bl emit_cstr
    adrp x7, :got:throw_handler
    ldr x7, [x7, :got_lo12:throw_handler]
    ldr x1, [x7]
    cbz x1, _undef_abandon
    mov x20, #-13
    b XTHROW
_undef_abandon:
    adrp x22, :got:data_stack
    ldr x22, [x22, :got_lo12:data_stack]
    add x22, x22, #1, lsl #12
    mov x20, #0
    bl _local_compile_reset
    adrp x0, :got:noname_xt
    ldr x0, [x0, :got_lo12:noname_xt]
    str xzr, [x0]
    b _do_quit
_interpret_empty:
    adrp x0, :got:line_mode
    ldr x0, [x0, :got_lo12:line_mode]
    ldr x0, [x0]
    cbz x0, _ie_whole
    bl _take_line
    cbnz x0, _interpret_loop
    b _ie_pop
_ie_whole:
    adrp x0, :got:source_sp
    ldr x0, [x0, :got_lo12:source_sp]
    ldr x0, [x0]
    cbz x0, _embed_finish
_ie_pop:
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
    ldr x25, [x0]
    bl _pop_source
    cbz x0, _embed_finish
    cmp x25, #0
    b.gt _ie_view_pop
    cmn x25, #2
    b.ne _ie_after_view
_ie_view_pop:
    bl _view_pop_src_id
_ie_after_view:
    cmn x25, #1
    b.eq _ie_resume
    cmn x25, #2
    b.ne _interpret_loop
_ie_resume:
    bl _eval_resume_pop
    cbz x0, _interpret_loop
    mov x19, x0
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_do_quit:
    adrp x23, :got:return_stack
    ldr x23, [x23, :got_lo12:return_stack]
    add x23, x23, #1, lsl #12
    adrp x0, :got:throw_handler
    ldr x0, [x0, :got_lo12:throw_handler]
    str xzr, [x0]
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    str xzr, [x0]
    adrp x0, :got:source_sp
    ldr x0, [x0, :got_lo12:source_sp]
    str xzr, [x0]
    adrp x0, :got:eval_resume_sp
    ldr x0, [x0, :got_lo12:eval_resume_sp]
    str xzr, [x0]
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
    str xzr, [x0]
    adrp x0, :got:view_src_id
    ldr x0, [x0, :got_lo12:view_src_id]
    str xzr, [x0]
    adrp x0, :got:view_id_sp
    ldr x0, [x0, :got_lo12:view_id_sp]
    str xzr, [x0]
    adrp x0, :got:line_mode
    ldr x0, [x0, :got_lo12:line_mode]
    str xzr, [x0]
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
    str xzr, [x0]
    adrp x0, :got:local_frame_depth
    ldr x0, [x0, :got_lo12:local_frame_depth]
    str xzr, [x0]
    bl _vm_save
    mov x0, #0
    b _embed_ret_x0
_embed_finish:
    bl _record_words_user_base_once
    bl _vm_save
    mov x0, #0
    b _embed_ret_x0
_quit_exit:
    b _embed_bye_return
_embed_bye_return:
    bl _vm_save
    mov x0, #1
    b _embed_ret_x0
_embed_ret_x0:
    ldp x27, x28, [sp, #112]
    ldp x25, x26, [sp, #96]
    ldp x23, x24, [sp, #80]
    ldp x21, x22, [sp, #64]
    ldp x19, x20, [sp, #48]
    ldp x29, x30, [sp, #32]
    add sp, sp, #128
    ret
_check_stack:
    adrp x0, :got:data_stack
    ldr x0, [x0, :got_lo12:data_stack]
    add x1, x0, #1, lsl #12
    cmp x22, x1
    b.hi _stack_underflow
    cmp x22, x0
    b.lo _stack_overflow
    ret
_stack_underflow:
    adrp x0, :got:msg_underflow
    ldr x0, [x0, :got_lo12:msg_underflow]
    bl emit_cstr
    b _stack_reset_abandon
_stack_overflow:
    adrp x0, :got:msg_overflow
    ldr x0, [x0, :got_lo12:msg_overflow]
    bl emit_cstr
_stack_reset_abandon:
    b _undef_abandon
_file_echo_upto_cursor:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:file_echo
    ldr x0, [x0, :got_lo12:file_echo]
    ldr x0, [x0]
    cbz x0, _fe_done
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
    ldr x0, [x0]
    cmp x0, #0
    b.gt _fe_on
    cmn x0, #2
    b.ne _fe_done
_fe_on:
    sub sp, sp, #48
    adrp x4, :got:line_mode
    ldr x4, [x4, :got_lo12:line_mode]
    ldr x4, [x4]
    cbz x4, _fe_src
    adrp x1, :got:line_origin
    ldr x1, [x1, :got_lo12:line_origin]
    ldr x1, [x1]
    adrp x2, :got:line_limit
    ldr x2, [x2, :got_lo12:line_limit]
    ldr x2, [x2]
    b _fe_bounds
_fe_src:
    adrp x1, :got:source_base
    ldr x1, [x1, :got_lo12:source_base]
    ldr x1, [x1]
    adrp x2, :got:source_end
    ldr x2, [x2, :got_lo12:source_end]
    ldr x2, [x2]
_fe_bounds:
    str x1, [sp]
    str x2, [sp, #8]
    adrp x0, :got:source_cur
    ldr x0, [x0, :got_lo12:source_cur]
    ldr x0, [x0]
    cmp x0, x1
    b.hs _fe_clamp_hi
    mov x0, x1
_fe_clamp_hi:
    cmp x0, x2
    b.ls _fe_skip
    mov x0, x2
_fe_skip:
    cmp x0, x2
    b.hs _fe_eol
    ldrb w3, [x0]
    cbz w3, _fe_eol
    cmp w3, #32
    b.eq _fe_skip1
    cmp w3, #9
    b.eq _fe_skip1
    cmp w3, #10
    b.eq _fe_skip1
    cmp w3, #13
    b.eq _fe_skip1
    b _fe_eol
_fe_skip1:
    add x0, x0, #1
    b _fe_skip
_fe_eol:
    mov x3, x0
_fe_eol_scan:
    cmp x3, x2
    b.hs _fe_eol_ok
    ldrb w4, [x3]
    cbz w4, _fe_eol_ok
    cmp w4, #10
    b.eq _fe_eol_ok
    cmp w4, #13
    b.eq _fe_eol_ok
    add x3, x3, #1
    b _fe_eol_scan
_fe_eol_ok:
    str x3, [sp, #16]
    adrp x4, :got:file_echo_pos
    ldr x4, [x4, :got_lo12:file_echo_pos]
    ldr x0, [x4]
    ldr x1, [sp]
    cmp x0, x1
    b.hs _fe_pos_hi
    mov x0, x1
_fe_pos_hi:
    ldr x2, [sp, #8]
    cmp x0, x2
    b.ls _fe_pos_ok
    mov x0, x2
_fe_pos_ok:
    str x0, [sp, #24]
    ldr x3, [sp, #16]
    cmp x0, x3
    b.hs _fe_drop
_fe_line:
    ldr x0, [sp, #24]
    ldr x3, [sp, #16]
    cmp x0, x3
    b.hs _fe_drop
    ldr x1, [sp]
    cmp x0, x1
    b.eq _fe_num
    ldrb w4, [x0, #-1]
    cmp w4, #10
    b.eq _fe_num
    cmp w4, #13
    b.eq _fe_num
    b _fe_text
_fe_num:
    mov x4, #1
    mov x3, x1
_fe_count:
    cmp x3, x0
    b.hs _fe_count_done
    ldrb w5, [x3]
    cmp w5, #10
    b.ne _fe_count_next
    add x4, x4, #1
_fe_count_next:
    add x3, x3, #1
    b _fe_count
_fe_count_done:
    mov x0, x4
    bl _fe_emit_lineno
_fe_text:
    ldr x0, [sp, #24]
    ldr x2, [sp, #8]
    mov x3, x0
_fe_text_scan:
    cmp x3, x2
    b.hs _fe_text_write
    ldrb w4, [x3]
    cbz w4, _fe_text_write
    cmp w4, #10
    b.eq _fe_text_write
    cmp w4, #13
    b.eq _fe_text_write
    add x3, x3, #1
    b _fe_text_scan
_fe_text_write:
    mov x1, x3
    ldr x0, [sp, #24]
    subs x1, x1, x0
    b.eq _fe_advance
    str x3, [sp, #32]
    bl emit_str
    ldr x3, [sp, #32]
_fe_advance:
    ldr x2, [sp, #8]
    mov x1, x3
    cmp x3, x2
    b.hs _fe_store
    ldrb w0, [x3]
    cmp w0, #10
    b.eq _fe_one
    cmp w0, #13
    b.ne _fe_store
    add x1, x3, #1
    cmp x1, x2
    b.hs _fe_store
    ldrb w0, [x1]
    cmp w0, #10
    b.ne _fe_store
    add x1, x1, #1
    b _fe_store
_fe_one:
    add x1, x3, #1
_fe_store:
    str x1, [sp, #24]
    adrp x4, :got:file_echo_pos
    ldr x4, [x4, :got_lo12:file_echo_pos]
    str x1, [x4]
    mov x0, #10
    bl _putchar
    b _fe_line
_fe_drop:
    add sp, sp, #48
_fe_done:
    ldp x29, x30, [sp], #16
    ret
_fe_emit_lineno:
    stp x29, x30, [sp, #-32]!
    str x0, [sp, #16]
    mov x1, #1
    mov x2, #10
_fe_digits:
    cmp x0, x2
    b.lo _fe_pad
    add x1, x1, #1
    mov x3, #10
    mul x2, x2, x3
    cmp x1, #5
    b.lo _fe_digits
_fe_pad:
    mov x2, #5
    subs x2, x2, x1
    b.ls _fe_print
_fe_spaces:
    mov x0, #32
    str x2, [sp, #24]
    bl _putchar
    ldr x2, [sp, #24]
    subs x2, x2, #1
    b.ne _fe_spaces
_fe_print:
    ldr x0, [sp, #16]
    bl _print_unsigned
    mov x0, #124
    bl _putchar
    mov x0, #32
    bl _putchar
    ldp x29, x30, [sp], #32
    ret
_arm_lines:
    adrp x2, :got:file_echo_pos
    ldr x2, [x2, :got_lo12:file_echo_pos]
    str x0, [x2]
    adrp x2, :got:line_origin
    ldr x2, [x2, :got_lo12:line_origin]
    str x0, [x2]
    add x3, x0, x1
    adrp x2, :got:line_limit
    ldr x2, [x2, :got_lo12:line_limit]
    str x3, [x2]
    adrp x2, :got:line_next
    ldr x2, [x2, :got_lo12:line_next]
    str x0, [x2]
    mov x3, #1
    adrp x2, :got:line_mode
    ldr x2, [x2, :got_lo12:line_mode]
    str x3, [x2]
    ret
_take_line:
    adrp x2, :got:line_next
    ldr x2, [x2, :got_lo12:line_next]
    ldr x0, [x2]
    adrp x3, :got:line_limit
    ldr x3, [x3, :got_lo12:line_limit]
    ldr x3, [x3]
    cmp x0, x3
    b.hs _tl_eof
    mov x1, x0
_tl_scan:
    cmp x1, x3
    b.hs _tl_eos
    ldrb w4, [x1]
    cmp w4, #10
    b.eq _tl_lf
    cmp w4, #13
    b.eq _tl_cr
    add x1, x1, #1
    b _tl_scan
_tl_lf:
    mov x5, x1
    add x1, x1, #1
    b _tl_set
_tl_cr:
    mov x5, x1
    add x1, x1, #1
    cmp x1, x3
    b.hs _tl_set
    ldrb w4, [x1]
    cmp w4, #10
    b.ne _tl_set
    add x1, x1, #1
    b _tl_set
_tl_eos:
    mov x5, x1
_tl_set:
    adrp x2, :got:line_next
    ldr x2, [x2, :got_lo12:line_next]
    str x1, [x2]
    adrp x2, :got:source_base
    ldr x2, [x2, :got_lo12:source_base]
    str x0, [x2]
    adrp x2, :got:source_end
    ldr x2, [x2, :got_lo12:source_end]
    str x5, [x2]
    adrp x2, :got:to_in
    ldr x2, [x2, :got_lo12:to_in]
    str xzr, [x2]
    adrp x2, :got:source_cur
    ldr x2, [x2, :got_lo12:source_cur]
    str x0, [x2]
    mov x0, #1
    ret
_tl_eof:
    mov x0, #0
    ret
_push_source:
    adrp x0, :got:source_sp
    ldr x0, [x0, :got_lo12:source_sp]
    ldr x1, [x0]
    cmp x1, #8
    b.hs _ps_full
    lsl x3, x1, #6
    adrp x2, :got:source_stack
    ldr x2, [x2, :got_lo12:source_stack]
    add x2, x2, x3
    adrp x3, :got:source_base
    ldr x3, [x3, :got_lo12:source_base]
    ldr x3, [x3]
    str x3, [x2], #8
    adrp x3, :got:source_end
    ldr x3, [x3, :got_lo12:source_end]
    ldr x3, [x3]
    str x3, [x2], #8
    adrp x3, :got:to_in
    ldr x3, [x3, :got_lo12:to_in]
    ldr x3, [x3]
    str x3, [x2], #8
    adrp x3, :got:source_id
    ldr x3, [x3, :got_lo12:source_id]
    ldr x3, [x3]
    str x3, [x2], #8
    adrp x3, :got:line_mode
    ldr x3, [x3, :got_lo12:line_mode]
    ldr x3, [x3]
    str x3, [x2], #8
    adrp x3, :got:line_origin
    ldr x3, [x3, :got_lo12:line_origin]
    ldr x3, [x3]
    str x3, [x2], #8
    adrp x3, :got:line_limit
    ldr x3, [x3, :got_lo12:line_limit]
    ldr x3, [x3]
    str x3, [x2], #8
    adrp x3, :got:line_next
    ldr x3, [x3, :got_lo12:line_next]
    ldr x3, [x3]
    str x3, [x2]
    adrp x3, :got:file_echo_pos
    ldr x3, [x3, :got_lo12:file_echo_pos]
    ldr x3, [x3]
    adrp x2, :got:file_echo_stack
    ldr x2, [x2, :got_lo12:file_echo_stack]
    str x3, [x2, x1, lsl #3]
    adrp x3, :got:blk_var
    ldr x3, [x3, :got_lo12:blk_var]
    ldr x3, [x3]
    adrp x2, :got:blk_stack
    ldr x2, [x2, :got_lo12:blk_stack]
    str x3, [x2, x1, lsl #3]
    add x1, x1, #1
    str x1, [x0]
    mov x0, #1
    ret
_ps_full:
    mov x0, #0
    ret
_pop_source:
    adrp x0, :got:source_sp
    ldr x0, [x0, :got_lo12:source_sp]
    ldr x1, [x0]
    cbz x1, _pop_empty
    sub x1, x1, #1
    str x1, [x0]
    lsl x3, x1, #6
    adrp x2, :got:source_stack
    ldr x2, [x2, :got_lo12:source_stack]
    add x2, x2, x3
    ldr x3, [x2], #8
    adrp x0, :got:source_base
    ldr x0, [x0, :got_lo12:source_base]
    str x3, [x0]
    mov x4, x3
    ldr x3, [x2], #8
    adrp x0, :got:source_end
    ldr x0, [x0, :got_lo12:source_end]
    str x3, [x0]
    ldr x3, [x2], #8
    adrp x0, :got:to_in
    ldr x0, [x0, :got_lo12:to_in]
    str x3, [x0]
    add x4, x4, x3
    adrp x0, :got:source_cur
    ldr x0, [x0, :got_lo12:source_cur]
    str x4, [x0]
    ldr x3, [x2], #8
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
    str x3, [x0]
    ldr x3, [x2], #8
    adrp x0, :got:line_mode
    ldr x0, [x0, :got_lo12:line_mode]
    str x3, [x0]
    ldr x3, [x2], #8
    adrp x0, :got:line_origin
    ldr x0, [x0, :got_lo12:line_origin]
    str x3, [x0]
    ldr x3, [x2], #8
    adrp x0, :got:line_limit
    ldr x0, [x0, :got_lo12:line_limit]
    str x3, [x0]
    ldr x3, [x2]
    adrp x0, :got:line_next
    ldr x0, [x0, :got_lo12:line_next]
    str x3, [x0]
    adrp x2, :got:file_echo_stack
    ldr x2, [x2, :got_lo12:file_echo_stack]
    ldr x3, [x2, x1, lsl #3]
    adrp x0, :got:file_echo_pos
    ldr x0, [x0, :got_lo12:file_echo_pos]
    str x3, [x0]
    adrp x2, :got:blk_stack
    ldr x2, [x2, :got_lo12:blk_stack]
    ldr x3, [x2, x1, lsl #3]
    adrp x0, :got:blk_var
    ldr x0, [x0, :got_lo12:blk_var]
    str x3, [x0]
    mov x0, #1
    ret
_pop_empty:
    mov x0, #0
    ret
_eval_resume_push:
    adrp x0, :got:eval_resume_sp
    ldr x0, [x0, :got_lo12:eval_resume_sp]
    ldr x1, [x0]
    cmp x1, #8
    b.hs _erp_full
    adrp x2, :got:eval_resume_stack
    ldr x2, [x2, :got_lo12:eval_resume_stack]
    lsl x3, x1, #3
    str x19, [x2, x3]
    add x1, x1, #1
    str x1, [x0]
_erp_full:
    ret
_eval_resume_pop:
    adrp x0, :got:eval_resume_sp
    ldr x0, [x0, :got_lo12:eval_resume_sp]
    ldr x1, [x0]
    cbz x1, _erpop_empty
    sub x1, x1, #1
    str x1, [x0]
    adrp x2, :got:eval_resume_stack
    ldr x2, [x2, :got_lo12:eval_resume_stack]
    lsl x3, x1, #3
    ldr x0, [x2, x3]
    ret
_erpop_empty:
    mov x0, #0
    ret
_throw_unwind_to_sp:
    sub sp, sp, #64
    stp x29, x30, [sp, #32]
    str x0, [sp, #48]
_tu_loop:
    adrp x0, :got:source_sp
    ldr x0, [x0, :got_lo12:source_sp]
    ldr x1, [x0]
    ldr x2, [sp, #48]
    cmp x1, x2
    b.ls _tu_done
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
    ldr x0, [x0]
    str x0, [sp, #56]
    bl _pop_source
    cbz x0, _tu_done
    ldr x0, [sp, #56]
    cmp x0, #0
    b.gt _tu_view
    cmn x0, #2
    b.ne _tu_loop
_tu_view:
    bl _view_pop_src_id
    b _tu_loop
_tu_done:
    ldp x29, x30, [sp, #32]
    add sp, sp, #64
    ret
_vm_save:
    adrp x0, :got:vm_tos
    ldr x0, [x0, :got_lo12:vm_tos]
    str x20, [x0]
    adrp x0, :got:vm_dsp
    ldr x0, [x0, :got_lo12:vm_dsp]
    str x22, [x0]
    adrp x0, :got:vm_rsp
    ldr x0, [x0, :got_lo12:vm_rsp]
    str x23, [x0]
    ret
_vm_load:
    adrp x24, :got:latest_var
    ldr x24, [x24, :got_lo12:latest_var]
    adrp x0, :got:vm_tos
    ldr x0, [x0, :got_lo12:vm_tos]
    ldr x20, [x0]
    adrp x0, :got:vm_dsp
    ldr x0, [x0, :got_lo12:vm_dsp]
    ldr x22, [x0]
    adrp x0, :got:vm_rsp
    ldr x0, [x0, :got_lo12:vm_rsp]
    ldr x23, [x0]
    adrp x0, :got:debug_armed
    ldr x0, [x0, :got_lo12:debug_armed]
    ldr x28, [x0]
    cbnz x22, _vm_load_ok
    b _vm_reset_stacks
_vm_load_ok:
    ret
_vm_reset_stacks:
    adrp x22, :got:data_stack
    ldr x22, [x22, :got_lo12:data_stack]
    add x22, x22, #1, lsl #12
    mov x20, #0
    adrp x23, :got:return_stack
    ldr x23, [x23, :got_lo12:return_stack]
    add x23, x23, #1, lsl #12
    adrp x24, :got:latest_var
    ldr x24, [x24, :got_lo12:latest_var]
    adrp x0, :got:state_var
    ldr x0, [x0, :got_lo12:state_var]
    str xzr, [x0]
    ret
next_debug_gate:
    adrp x16, :got:next_debug
    ldr x16, [x16, :got_lo12:next_debug]
    br x16
    .section .rodata,"a",@progbits
    .p2align 3
msg_huh:
    .ascii " ?"
    .byte 10
    .byte 0
msg_underflow:
    .ascii "stack underflow"
    .byte 10
    .byte 0
msg_overflow:
    .ascii "stack overflow"
    .byte 10
    .byte 0
    .p2align 3
boot_cmp_lit:
    .ascii "LIT"
    .byte 0
boot_cmp_exit:
    .ascii "EXIT"
    .byte 0
boot_cmp_branch:
    .ascii "BRANCH"
    .byte 0
boot_cmp_0branch:
    .ascii "0BRANCH"
    .byte 0
boot_cmp_does:
    .ascii "(DOES>)"
    .byte 0
boot_cmp_slit:
    .ascii "(S"
    .byte 34
    .ascii ")"
    .byte 0
boot_cmp_cstr:
    .ascii "(C"
    .byte 34
    .ascii ")"
    .byte 0
boot_cmp_execute:
    .ascii "EXECUTE"
    .byte 0
boot_cmp_comma:
    .byte 44
    .byte 0
boot_cmp_flit:
    .ascii "FLIT"
    .byte 0
boot_cmp_linit:
    .ascii "LOCAL-INIT"
    .byte 0
boot_cmp_lat:
    .ascii "(LOCAL@)"
    .byte 0
boot_cmp_lstore:
    .ascii "(LOCAL!)"
    .byte 0
boot_cmp_loop:
    .ascii "(LOOP)"
    .byte 0
boot_cmp_ploop:
    .ascii "(+LOOP)"
    .byte 0

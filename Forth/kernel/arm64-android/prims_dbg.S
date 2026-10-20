/* Generated from Forth/kernel/arm64/prims_dbg.asm. Do not edit. */
    .equ DBG_DSAVE_MAX, 64
    .equ DBG_HOME, 1
    .equ DEBUG_CALL_MAX, 4
    .equ DEBUG_STACK_COL, 23
    .equ DEBUG_VMSAVE_SIZE, 72
    .equ DICT_THREADS, 16
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .equ NFA_LEN_MASK, 127
    .equ VIEW_FILE_MASK, 8191
    .equ VIEW_FILE_MAX, 256
    .equ VIEW_PATH_MAX, 256
    .text
    .p2align 2
    .extern _putchar
    .extern _print_signed
    .extern _print_unsigned
    .extern DOCOL
    .extern DODOES
    .extern XEXECUTE
    .extern XCATCH
    .extern XCATCH_OK
    .extern XTHROW
    .extern key_fn
    .extern data_stack
    .extern return_stack
    .extern throw_handler
    .extern here_ptr
    .extern user_dict_area
    .extern cfa_lit
    .extern cfa_branch
    .extern cfa_0branch
    .extern cfa_loop
    .extern cfa_plusloop
    .extern wordlist_reg
    .extern wordlist_reg_n
    .extern latest_var
    .extern catch_ok_cell
    .extern tw_continue_cell
    .extern tw_continue_cfa
    .extern host_debug_paint
    .extern host_debug_set_span
    .extern host_debug_get_span
    .extern source_id
    .extern source_base
    .extern to_in
    .extern line_mode
    .extern line_origin
    .global next_debug
    .global debug_break_asap
    .global debug_armed
    .global debug_busy
    .global debug_bp_go
    .global debug_bp_xts
    .global debug_bp_en
    .global debug_cfa
    .global debug_xt
    .global debug_name
    .global view_file_n
    .global view_paths
    .global view_src_id
    .global view_id_sp
    .global include_name_pending
    .global include_name_len
    .global _view_line_now
    .global _view_push_src_id
    .global _view_pop_src_id
    .global _view_set_src_from_pending
    .global debug_runto_ip
    .global debug_runto_off
    .global debug_runto_status
    .global debug_floor
    .global debug_field_count
    .global debug_field_len
    .global _debug_note_byte
    .global _getchar
next_debug_gate:
next_debug:
    adrp x1, :got:debug_busy
    ldr x1, [x1, :got_lo12:debug_busy]
    ldr x2, [x1]
    cbnz x2, nd_exec
    adrp x2, :got:debug_break_asap
    ldr x2, [x2, :got_lo12:debug_break_asap]
    ldr x3, [x2]
    cbz x3, nd_floor
    ldr x21, [x19]
    mov x3, #1
    mov x28, x3
    adrp x4, :got:debug_armed
    ldr x4, [x4, :got_lo12:debug_armed]
    ldr x5, [x4]
    str x3, [x4]
    cbnz x5, nd_asap_floor
    adrp x4, :got:debug_need_intro
    ldr x4, [x4, :got_lo12:debug_need_intro]
    str x3, [x4]
nd_asap_floor:
    adrp x4, :got:debug_floor
    ldr x4, [x4, :got_lo12:debug_floor]
    str xzr, [x4]
    adrp x4, :got:debug_bp_go
    ldr x4, [x4, :got_lo12:debug_bp_go]
    str xzr, [x4]
    adrp x4, :got:debug_runto_ip
    ldr x4, [x4, :got_lo12:debug_runto_ip]
    str xzr, [x4]
    adrp x4, :got:debug_over
    ldr x4, [x4, :got_lo12:debug_over]
    str xzr, [x4]
    adrp x4, :got:debug_out
    ldr x4, [x4, :got_lo12:debug_out]
    str xzr, [x4]
    adrp x4, :got:debug_break_min_cfa
    ldr x4, [x4, :got_lo12:debug_break_min_cfa]
    ldr x4, [x4]
    cbz x4, nd_asap_hit
    mov x0, x19
    mov x1, x21
    stp x29, x30, [sp, #-16]!
    bl _debug_resolve_enclosing
    ldp x29, x30, [sp], #16
    cbz x0, nd_exec
    adrp x4, :got:debug_break_min_cfa
    ldr x4, [x4, :got_lo12:debug_break_min_cfa]
    ldr x4, [x4]
    cmp x0, x4
    b.lo nd_exec
nd_asap_hit:
    adrp x2, :got:debug_break_asap
    ldr x2, [x2, :got_lo12:debug_break_asap]
    str xzr, [x2]
    add x3, x23, #8
    adrp x4, :got:debug_floor
    ldr x4, [x4, :got_lo12:debug_floor]
    str x3, [x4]
    b nd_force
nd_floor:
    adrp x2, :got:debug_floor
    ldr x2, [x2, :got_lo12:debug_floor]
    ldr x2, [x2]
    cbz x2, nd_out
    cmp x23, x2
    b.lo nd_out
    b.eq nd_exec
    mov x28, #0
    adrp x3, :got:debug_armed
    ldr x3, [x3, :got_lo12:debug_armed]
    str xzr, [x3]
    adrp x3, :got:debug_bp_go
    ldr x3, [x3, :got_lo12:debug_bp_go]
    str xzr, [x3]
    adrp x3, :got:debug_runto_ip
    ldr x3, [x3, :got_lo12:debug_runto_ip]
    str xzr, [x3]
    adrp x3, :got:debug_break_asap
    ldr x3, [x3, :got_lo12:debug_break_asap]
    str xzr, [x3]
    stp x29, x30, [sp, #-16]!
    bl host_debug_paint
    ldp x29, x30, [sp], #16
    b nd_exec
nd_out:
    adrp x2, :got:debug_out
    ldr x2, [x2, :got_lo12:debug_out]
    ldr x2, [x2]
    cbz x2, nd_over
    cmp x23, x2
    b.ls nd_exec
nd_over:
    adrp x2, :got:debug_over
    ldr x2, [x2, :got_lo12:debug_over]
    ldr x2, [x2]
    cbz x2, nd_peek
    cmp x23, x2
    b.lo nd_exec
nd_peek:
    ldr x21, [x19]
    adrp x2, :got:debug_runto_ip
    ldr x2, [x2, :got_lo12:debug_runto_ip]
    ldr x3, [x2]
    cbz x3, nd_bp
    cmp x19, x3
    b.ne nd_runto_miss
    str xzr, [x2]
    adrp x2, :got:debug_bp_go
    ldr x2, [x2, :got_lo12:debug_bp_go]
    str xzr, [x2]
    b nd_force
nd_runto_miss:
    adrp x2, :got:debug_bp_go
    ldr x2, [x2, :got_lo12:debug_bp_go]
    ldr x3, [x2]
    cbz x3, nd_exec
    b nd_scan
nd_bp:
    adrp x2, :got:debug_bp_go
    ldr x2, [x2, :got_lo12:debug_bp_go]
    ldr x3, [x2]
    cbz x3, nd_force
nd_scan:
    adrp x3, :got:debug_bp_xts
    ldr x3, [x3, :got_lo12:debug_bp_xts]
    adrp x6, :got:debug_bp_en
    ldr x6, [x6, :got_lo12:debug_bp_en]
    mov x4, #8
nd_scan_loop:
    ldr x5, [x3], #8
    ldr x7, [x6], #8
    cbz x5, nd_scan_next
    cbz x7, nd_scan_next
    cmp x5, x21
    b.eq nd_scan_hit
nd_scan_next:
    subs x4, x4, #1
    b.ne nd_scan_loop
    b nd_exec
nd_scan_hit:
    adrp x2, :got:debug_bp_go
    ldr x2, [x2, :got_lo12:debug_bp_go]
    str xzr, [x2]
    adrp x3, :got:debug_runto_ip
    ldr x3, [x3, :got_lo12:debug_runto_ip]
    str xzr, [x3]
nd_force:
    ldr x2, [x21]
    adrp x3, :got:XCATCH_OK
    ldr x3, [x3, :got_lo12:XCATCH_OK]
    cmp x2, x3
    b.eq nd_exec
    adrp x3, :got:XDBGOFF
    ldr x3, [x3, :got_lo12:XDBGOFF]
    cmp x2, x3
    b.eq nd_exec
    adrp x2, :got:debug_over
    ldr x2, [x2, :got_lo12:debug_over]
    str xzr, [x2]
    adrp x2, :got:debug_out
    ldr x2, [x2, :got_lo12:debug_out]
    str xzr, [x2]
    adrp x1, :got:debug_busy
    ldr x1, [x1, :got_lo12:debug_busy]
    mov x2, #1
    str x2, [x1]
    stp x29, x30, [sp, #-16]!
    bl _debug_pause
    ldp x29, x30, [sp], #16
    adrp x1, :got:debug_busy
    ldr x1, [x1, :got_lo12:debug_busy]
    str xzr, [x1]
    adrp x1, :got:debug_abort
    ldr x1, [x1, :got_lo12:debug_abort]
    ldr x2, [x1]
    cbz x2, nd_exec
    str xzr, [x1]
    mov x20, x2
    b XTHROW
nd_exec:
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGSHOWXT:
    .ascii "DBG-SHOW-XT"
    .byte 0
hl_XDBGSHOWXT:
    .ascii "DBG-SHOW-XT ( -- addr ) xt of the view sync word or 0"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGSHOWXT:
    .quad nm_XDBGSHOWXT, hl_XDBGSHOWXT
    .quad 0
    .quad XDBGSHOWXT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGSHOWXT
    .text
    .p2align 2
XDBGSHOWXT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_show_xt
    ldr x20, [x20, :got_lo12:debug_show_xt]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGSYNCOK:
    .ascii "DBG-SYNC-OK"
    .byte 0
hl_XDBGSYNCOK:
    .ascii "DBG-SYNC-OK ( -- addr ) set 1 after a debug VIEW"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGSYNCOK:
    .quad nm_XDBGSYNCOK, hl_XDBGSYNCOK
    .quad 0
    .quad XDBGSYNCOK, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGSYNCOK
    .text
    .p2align 2
XDBGSYNCOK:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_sync_ok
    ldr x20, [x20, :got_lo12:debug_sync_ok]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGHLXT:
    .ascii "DBG-HL-XT"
    .byte 0
hl_XDBGHLXT:
    .ascii "DBG-HL-XT ( -- addr ) xt of the highlight word or 0"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGHLXT:
    .quad nm_XDBGHLXT, hl_XDBGHLXT
    .quad 0
    .quad XDBGHLXT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGHLXT
    .text
    .p2align 2
XDBGHLXT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_hl_xt
    ldr x20, [x20, :got_lo12:debug_hl_xt]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGWHEELXT:
    .ascii "DBG-WHEEL-XT"
    .byte 0
hl_XDBGWHEELXT:
    .ascii "DBG-WHEEL-XT ( -- addr ) xt of the wheel word or 0"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGWHEELXT:
    .quad nm_XDBGWHEELXT, hl_XDBGWHEELXT
    .quad 0
    .quad XDBGWHEELXT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGWHEELXT
    .text
    .p2align 2
XDBGWHEELXT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_wheel_xt
    ldr x20, [x20, :got_lo12:debug_wheel_xt]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGPAUSEXT:
    .ascii "DBG-PAUSE-XT"
    .byte 0
hl_XDBGPAUSEXT:
    .ascii "DBG-PAUSE-XT ( -- addr ) Forth pause xt or 0"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGPAUSEXT:
    .quad nm_XDBGPAUSEXT, hl_XDBGPAUSEXT
    .quad 0
    .quad XDBGPAUSEXT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGPAUSEXT
    .text
    .p2align 2
XDBGPAUSEXT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_pause_xt
    ldr x20, [x20, :got_lo12:debug_pause_xt]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGKEYXT:
    .ascii "DBG-KEY-XT"
    .byte 0
hl_XDBGKEYXT:
    .ascii "DBG-KEY-XT ( -- addr ) Forth key mode xt or 0"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGKEYXT:
    .quad nm_XDBGKEYXT, hl_XDBGKEYXT
    .quad 0
    .quad XDBGKEYXT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGKEYXT
    .text
    .p2align 2
XDBGKEYXT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_key_xt
    ldr x20, [x20, :got_lo12:debug_key_xt]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGINLINE:
    .ascii "DBG-INLINE"
    .byte 0
hl_XDBGINLINE:
    .ascii "DBG-INLINE ( -- x ) cell after the paused IP"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGINLINE:
    .quad nm_XDBGINLINE, hl_XDBGINLINE
    .quad 0
    .quad XDBGINLINE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGINLINE
    .text
    .p2align 2
XDBGINLINE:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_inline
    ldr x20, [x20, :got_lo12:debug_inline]
    ldr x20, [x20]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGTOSAT:
    .ascii "DBG-TOS@"
    .byte 0
hl_XDBGTOSAT:
    .ascii "DBG-TOS@ ( -- x ) data TOS at the last pause or 0"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGTOSAT:
    .quad nm_XDBGTOSAT, hl_XDBGTOSAT
    .quad 0
    .quad XDBGTOSAT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGTOSAT
    .text
    .p2align 2
XDBGTOSAT:
    str x20, [x22, #-8]!
    adrp x0, :got:debug_scnt
    ldr x0, [x0, :got_lo12:debug_scnt]
    ldr x0, [x0]
    cbz x0, dbg_tos_empty
    adrp x1, :got:debug_sbuf
    ldr x1, [x1, :got_lo12:debug_sbuf]
    sub x0, x0, #1
    ldr x20, [x1, x0, lsl #3]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
dbg_tos_empty:
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
nm_XDBGXTAT:
    .ascii "DBG-XT@"
    .byte 0
hl_XDBGXTAT:
    .ascii "DBG-XT@ ( -- xt ) upcoming xt at the last pause"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGXTAT:
    .quad nm_XDBGXTAT, hl_XDBGXTAT
    .quad 0
    .quad XDBGXTAT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGXTAT
    .text
    .p2align 2
XDBGXTAT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_xt
    ldr x20, [x20, :got_lo12:debug_xt]
    ldr x20, [x20]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGIPAT:
    .ascii "DBG-IP@"
    .byte 0
hl_XDBGIPAT:
    .ascii "DBG-IP@ ( -- ip ) paused IP"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGIPAT:
    .quad nm_XDBGIPAT, hl_XDBGIPAT
    .quad 0
    .quad XDBGIPAT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGIPAT
    .text
    .p2align 2
XDBGIPAT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_ip
    ldr x20, [x20, :got_lo12:debug_ip]
    ldr x20, [x20]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGCFAAT:
    .ascii "DBG-CFA@"
    .byte 0
hl_XDBGCFAAT:
    .ascii "DBG-CFA@ ( -- cfa|0 ) enclosing colon at the last pause"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGCFAAT:
    .quad nm_XDBGCFAAT, hl_XDBGCFAAT
    .quad 0
    .quad XDBGCFAAT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGCFAAT
    .text
    .p2align 2
XDBGCFAAT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_cfa
    ldr x20, [x20, :got_lo12:debug_cfa]
    ldr x20, [x20]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGBODYN:
    .ascii "DBG-BODY#"
    .byte 0
hl_XDBGBODYN:
    .ascii "DBG-BODY# ( -- u ) body cell index of the paused IP"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGBODYN:
    .quad nm_XDBGBODYN, hl_XDBGBODYN
    .quad 0
    .quad XDBGBODYN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGBODYN
    .text
    .p2align 2
XDBGBODYN:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_body_cells
    ldr x20, [x20, :got_lo12:debug_body_cells]
    ldr x20, [x20]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGNEEDINTRO:
    .ascii "DBG-NEED-INTRO"
    .byte 0
hl_XDBGNEEDINTRO:
    .ascii "DBG-NEED-INTRO ( -- addr )"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGNEEDINTRO:
    .quad nm_XDBGNEEDINTRO, hl_XDBGNEEDINTRO
    .quad 0
    .quad XDBGNEEDINTRO, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGNEEDINTRO
    .text
    .p2align 2
XDBGNEEDINTRO:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_need_intro
    ldr x20, [x20, :got_lo12:debug_need_intro]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGNEEDSTACKS:
    .ascii "DBG-NEED-STACKS"
    .byte 0
hl_XDBGNEEDSTACKS:
    .ascii "DBG-NEED-STACKS ( -- addr )"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGNEEDSTACKS:
    .quad nm_XDBGNEEDSTACKS, hl_XDBGNEEDSTACKS
    .quad 0
    .quad XDBGNEEDSTACKS, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGNEEDSTACKS
    .text
    .p2align 2
XDBGNEEDSTACKS:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_need_stacks
    ldr x20, [x20, :got_lo12:debug_need_stacks]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGHELPSHOWN:
    .ascii "DBG-HELP-SHOWN"
    .byte 0
hl_XDBGHELPSHOWN:
    .ascii "DBG-HELP-SHOWN ( -- addr )"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGHELPSHOWN:
    .quad nm_XDBGHELPSHOWN, hl_XDBGHELPSHOWN
    .quad 0
    .quad XDBGHELPSHOWN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGHELPSHOWN
    .text
    .p2align 2
XDBGHELPSHOWN:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_help_shown
    ldr x20, [x20, :got_lo12:debug_help_shown]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGSKIPNL:
    .ascii "DBG-SKIP-NL"
    .byte 0
hl_XDBGSKIPNL:
    .ascii "DBG-SKIP-NL ( -- addr )"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGSKIPNL:
    .quad nm_XDBGSKIPNL, hl_XDBGSKIPNL
    .quad 0
    .quad XDBGSKIPNL, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGSKIPNL
    .text
    .p2align 2
XDBGSKIPNL:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_skip_nl
    ldr x20, [x20, :got_lo12:debug_skip_nl]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGMIDLINE:
    .ascii "DBG-MIDLINE"
    .byte 0
hl_XDBGMIDLINE:
    .ascii "DBG-MIDLINE ( -- addr )"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGMIDLINE:
    .quad nm_XDBGMIDLINE, hl_XDBGMIDLINE
    .quad 0
    .quad XDBGMIDLINE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGMIDLINE
    .text
    .p2align 2
XDBGMIDLINE:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_midline
    ldr x20, [x20, :got_lo12:debug_midline]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGLINECOL:
    .ascii "DBG-LINE-COL"
    .byte 0
hl_XDBGLINECOL:
    .ascii "DBG-LINE-COL ( -- addr )"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGLINECOL:
    .quad nm_XDBGLINECOL, hl_XDBGLINECOL
    .quad 0
    .quad XDBGLINECOL, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGLINECOL
    .text
    .p2align 2
XDBGLINECOL:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_line_col
    ldr x20, [x20, :got_lo12:debug_line_col]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGDOTSR:
    .ascii "DBG-.SR"
    .byte 0
hl_XDBGDOTSR:
    .ascii "DBG-.SR ( -- ) pad to the stack column and print S and R"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGDOTSR:
    .quad nm_XDBGDOTSR, hl_XDBGDOTSR
    .quad 0
    .quad XDBGDOTSR, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGDOTSR
    .text
    .p2align 2
XDBGDOTSR:
    stp x29, x30, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    adrp x0, :got:debug_busy
    ldr x0, [x0, :got_lo12:debug_busy]
    ldr x0, [x0]
    cbz x0, dbg_sr_live
    adrp x0, :got:debug_pause_rsp
    ldr x0, [x0, :got_lo12:debug_pause_rsp]
    ldr x0, [x0]
    cbz x0, dbg_sr_live
    mov x23, x0
dbg_sr_live:
    bl _debug_pad_to_stack_col
    bl _debug_print_SR
    ldp x23, x24, [sp], #16
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
nm_XDBGCURON:
    .ascii "DBG-CURSOR-ON"
    .byte 0
hl_XDBGCURON:
    .ascii "DBG-CURSOR-ON ( -- )"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGCURON:
    .quad nm_XDBGCURON, hl_XDBGCURON
    .quad 0
    .quad XDBGCURON, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGCURON
    .text
    .p2align 2
XDBGCURON:
    stp x29, x30, [sp, #-16]!
    bl _debug_cursor_on
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
nm_XDBGCUROFF:
    .ascii "DBG-CURSOR-OFF"
    .byte 0
hl_XDBGCUROFF:
    .ascii "DBG-CURSOR-OFF ( -- )"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGCUROFF:
    .quad nm_XDBGCUROFF, hl_XDBGCUROFF
    .quad 0
    .quad XDBGCUROFF, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGCUROFF
    .text
    .p2align 2
XDBGCUROFF:
    stp x29, x30, [sp, #-16]!
    bl _debug_cursor_off
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
nm_XDBGPRINTINL:
    .ascii "DBG-PRINT-INLINE"
    .byte 0
hl_XDBGPRINTINL:
    .ascii "DBG-PRINT-INLINE ( -- ) LIT or branch suffix after the name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGPRINTINL:
    .quad nm_XDBGPRINTINL, hl_XDBGPRINTINL
    .quad 0
    .quad XDBGPRINTINL, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGPRINTINL
    .text
    .p2align 2
XDBGPRINTINL:
    stp x29, x30, [sp, #-16]!
    bl _debug_print_inline_suffix
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
nm_XDBGPRINTNAME:
    .ascii "DBG-PRINT-NAME"
    .byte 0
hl_XDBGPRINTNAME:
    .ascii "DBG-PRINT-NAME ( -- ) print the paused xt name"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGPRINTNAME:
    .quad nm_XDBGPRINTNAME, hl_XDBGPRINTNAME
    .quad 0
    .quad XDBGPRINTNAME, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGPRINTNAME
    .text
    .p2align 2
XDBGPRINTNAME:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:debug_xt
    ldr x0, [x0, :got_lo12:debug_xt]
    ldr x0, [x0]
    bl _print_xt_name
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
nm_XDBGINTOABLE:
    .ascii "DBG-XT-INTOABLE?"
    .byte 0
hl_XDBGINTOABLE:
    .ascii "DBG-XT-INTOABLE? ( -- flag ) true when the paused xt can nest"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGINTOABLE:
    .quad nm_XDBGINTOABLE, hl_XDBGINTOABLE
    .quad 0
    .quad XDBGINTOABLE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGINTOABLE
    .text
    .p2align 2
XDBGINTOABLE:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:debug_xt
    ldr x0, [x0, :got_lo12:debug_xt]
    ldr x0, [x0]
    bl _debug_xt_intoable
    ldp x29, x30, [sp], #16
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
nm_XDBGHOSTPAINT:
    .ascii "DBG-HOST-PAINT"
    .byte 0
hl_XDBGHOSTPAINT:
    .ascii "DBG-HOST-PAINT ( -- ) refresh the editor debug pane"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGHOSTPAINT:
    .quad nm_XDBGHOSTPAINT, hl_XDBGHOSTPAINT
    .quad 0
    .quad XDBGHOSTPAINT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGHOSTPAINT
    .text
    .p2align 2
XDBGHOSTPAINT:
    stp x29, x30, [sp, #-16]!
    bl host_debug_paint
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
nm_XDBGHOSTSPAN:
    .ascii "DBG-HOST-SPAN"
    .byte 0
hl_XDBGHOSTSPAN:
    .ascii "DBG-HOST-SPAN ( off len -- ) pending editor highlight span"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGHOSTSPAN:
    .quad nm_XDBGHOSTSPAN, hl_XDBGHOSTSPAN
    .quad 0
    .quad XDBGHOSTSPAN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGHOSTSPAN
    .text
    .p2align 2
XDBGHOSTSPAN:
    mov x1, x20
    ldr x0, [x22], #8
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    bl host_debug_set_span
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
nm_XDBGHOSTSPANAT:
    .ascii "DBG-HOST-SPAN@"
    .byte 0
hl_XDBGHOSTSPANAT:
    .ascii "DBG-HOST-SPAN@ ( -- off len ) peek the pending highlight span"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGHOSTSPANAT:
    .quad nm_XDBGHOSTSPANAT, hl_XDBGHOSTSPANAT
    .quad 0
    .quad XDBGHOSTSPANAT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGHOSTSPANAT
    .text
    .p2align 2
XDBGHOSTSPANAT:
    sub sp, sp, #32
    stp x29, x30, [sp, #16]
    mov x0, sp
    add x1, sp, #8
    str xzr, [sp]
    str xzr, [sp, #8]
    bl host_debug_get_span
    ldr x1, [sp]
    ldr x2, [sp, #8]
    ldp x29, x30, [sp, #16]
    add sp, sp, #32
    str x20, [x22, #-8]!
    mov x20, x1
    str x20, [x22, #-8]!
    mov x20, x2
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XDBGVIEWUPD:
    .ascii "DBG-VIEW-UPDATE"
    .byte 0
hl_XDBGVIEWUPD:
    .ascii "DBG-VIEW-UPDATE ( -- ) sync VIEW highlight and paint"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGVIEWUPD:
    .quad nm_XDBGVIEWUPD, hl_XDBGVIEWUPD
    .quad 0
    .quad XDBGVIEWUPD, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGVIEWUPD
    .text
    .p2align 2
XDBGVIEWUPD:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    bl _debug_sync_view
    bl _debug_highlight
    bl host_debug_paint
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
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
nm_XDBGWHEELDO:
    .ascii "DBG-WHEEL-DO"
    .byte 0
hl_XDBGWHEELDO:
    .ascii "DBG-WHEEL-DO ( u -- ) wheel or resize while paused"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGWHEELDO:
    .quad nm_XDBGWHEELDO, hl_XDBGWHEELDO
    .quad 0
    .quad XDBGWHEELDO, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGWHEELDO
    .text
    .p2align 2
XDBGWHEELDO:
    mov x0, x20
    ldr x20, [x22], #8
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    bl _debug_wheel
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
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
nm_XDBGSTEPOVER:
    .ascii "DBG-STEP-OVER"
    .byte 0
hl_XDBGSTEPOVER:
    .ascii "DBG-STEP-OVER ( -- ) step over a colon word"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGSTEPOVER:
    .quad nm_XDBGSTEPOVER, hl_XDBGSTEPOVER
    .quad 0
    .quad XDBGSTEPOVER, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGSTEPOVER
    .text
    .p2align 2
XDBGSTEPOVER:
    stp x29, x30, [sp, #-16]!
    bl _debug_cursor_off
    mov x1, #1
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str x1, [x0]
    adrp x1, :got:debug_out
    ldr x1, [x1, :got_lo12:debug_out]
    str xzr, [x1]
    adrp x1, :got:debug_over
    ldr x1, [x1, :got_lo12:debug_over]
    str xzr, [x1]
    adrp x0, :got:debug_xt
    ldr x0, [x0, :got_lo12:debug_xt]
    ldr x0, [x0]
    cbz x0, dbg_over_done
    ldr x0, [x0]
    adrp x2, :got:DOCOL
    ldr x2, [x2, :got_lo12:DOCOL]
    cmp x0, x2
    b.ne dbg_over_done
    adrp x0, :got:debug_pause_rsp
    ldr x0, [x0, :got_lo12:debug_pause_rsp]
    ldr x0, [x0]
    str x0, [x1]
dbg_over_done:
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
nm_XDBGSTEPINTO:
    .ascii "DBG-STEP-INTO"
    .byte 0
hl_XDBGSTEPINTO:
    .ascii "DBG-STEP-INTO ( -- ) step into the next xt"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGSTEPINTO:
    .quad nm_XDBGSTEPINTO, hl_XDBGSTEPINTO
    .quad 0
    .quad XDBGSTEPINTO, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGSTEPINTO
    .text
    .p2align 2
XDBGSTEPINTO:
    stp x29, x30, [sp, #-16]!
    bl _debug_cursor_off
    mov x1, #1
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str x1, [x0]
    adrp x1, :got:debug_out
    ldr x1, [x1, :got_lo12:debug_out]
    str xzr, [x1]
    adrp x1, :got:debug_over
    ldr x1, [x1, :got_lo12:debug_over]
    str xzr, [x1]
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
nm_XDBGSTEPOUT:
    .ascii "DBG-STEP-OUT"
    .byte 0
hl_XDBGSTEPOUT:
    .ascii "DBG-STEP-OUT ( -- ) run until this colon returns"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGSTEPOUT:
    .quad nm_XDBGSTEPOUT, hl_XDBGSTEPOUT
    .quad 0
    .quad XDBGSTEPOUT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGSTEPOUT
    .text
    .p2align 2
XDBGSTEPOUT:
    stp x29, x30, [sp, #-16]!
    bl _debug_cursor_off
    mov x1, #1
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str x1, [x0]
    adrp x1, :got:debug_over
    ldr x1, [x1, :got_lo12:debug_over]
    str xzr, [x1]
    adrp x1, :got:debug_out
    ldr x1, [x1, :got_lo12:debug_out]
    adrp x0, :got:debug_pause_rsp
    ldr x0, [x0, :got_lo12:debug_pause_rsp]
    ldr x0, [x0]
    str x0, [x1]
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
nm_XDBGGO:
    .ascii "DBG-GO"
    .byte 0
hl_XDBGGO:
    .ascii "DBG-GO ( -- ) disarm unless a breakpoint or run-to is armed"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGGO:
    .quad nm_XDBGGO, hl_XDBGGO
    .quad 0
    .quad XDBGGO, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGGO
    .text
    .p2align 2
XDBGGO:
    stp x29, x30, [sp, #-16]!
    bl _debug_cursor_off
    bl _debug_clear_step
    adrp x1, :got:debug_bp_go
    ldr x1, [x1, :got_lo12:debug_bp_go]
    ldr x0, [x1]
    cbnz x0, dbg_go_keep
    adrp x1, :got:debug_runto_ip
    ldr x1, [x1, :got_lo12:debug_runto_ip]
    ldr x0, [x1]
    cbnz x0, dbg_go_keep
    mov x28, #0
    adrp x1, :got:debug_armed
    ldr x1, [x1, :got_lo12:debug_armed]
    str xzr, [x1]
    adrp x1, :got:debug_bp_go
    ldr x1, [x1, :got_lo12:debug_bp_go]
    str xzr, [x1]
    adrp x1, :got:debug_runto_ip
    ldr x1, [x1, :got_lo12:debug_runto_ip]
    str xzr, [x1]
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    str xzr, [x1]
    bl host_debug_paint
dbg_go_keep:
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
nm_XDBGABORT:
    .ascii "DBG-ABORT-SESSION"
    .byte 0
hl_XDBGABORT:
    .ascii "DBG-ABORT-SESSION ( -- ) disarm and THROW -1"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGABORT:
    .quad nm_XDBGABORT, hl_XDBGABORT
    .quad 0
    .quad XDBGABORT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGABORT
    .text
    .p2align 2
XDBGABORT:
    stp x29, x30, [sp, #-16]!
    bl _debug_cursor_off
    bl _debug_clear_step
    adrp x0, :got:str_dbg_abort
    ldr x0, [x0, :got_lo12:str_dbg_abort]
    bl _emit_z
    bl _debug_disarm
    bl host_debug_paint
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
nm_XTDBGARM:
    .ascii "TDBG-ARM-KEYS"
    .byte 0
hl_XTDBGARM:
    .ascii "TDBG-ARM-KEYS ( -- ) arm the host debug-key steal"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTDBGARM:
    .quad nm_XTDBGARM, hl_XTDBGARM
    .quad 0
    .quad XTDBGARM, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTDBGARM
    .text
    .p2align 2
XTDBGARM:
    adrp x0, :got:tdebug_armed
    ldr x0, [x0, :got_lo12:tdebug_armed]
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
nm_XTDBGDISARM:
    .ascii "TDBG-DISARM-KEYS"
    .byte 0
hl_XTDBGDISARM:
    .ascii "TDBG-DISARM-KEYS ( -- ) disarm the host debug-key steal"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XTDBGDISARM:
    .quad nm_XTDBGDISARM, hl_XTDBGDISARM
    .quad 0
    .quad XTDBGDISARM, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XTDBGDISARM
    .text
    .p2align 2
XTDBGDISARM:
    adrp x0, :got:tdebug_armed
    ldr x0, [x0, :got_lo12:tdebug_armed]
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
nm_XDBGBREAKMIN:
    .ascii "DBG-BREAK-MIN!"
    .byte 0
hl_XDBGBREAKMIN:
    .ascii "DBG-BREAK-MIN! ( addr -- ) low water for Break ASAP"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGBREAKMIN:
    .quad nm_XDBGBREAKMIN, hl_XDBGBREAKMIN
    .quad 0
    .quad XDBGBREAKMIN, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGBREAKMIN
    .text
    .p2align 2
XDBGBREAKMIN:
    adrp x0, :got:debug_break_min_cfa
    ldr x0, [x0, :got_lo12:debug_break_min_cfa]
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
nm_XDBGON:
    .ascii "DBG-ON"
    .byte 0
hl_XDBGON:
    .ascii "DBG-ON ( -- ) arm the NEXT stepper"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGON:
    .quad nm_XDBGON, hl_XDBGON
    .quad 0
    .quad XDBGON, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGON
    .text
    .p2align 2
XDBGON:
    adrp x0, :got:debug_floor
    ldr x0, [x0, :got_lo12:debug_floor]
    str x23, [x0]
    mov x1, #1
    mov x28, x1
    adrp x0, :got:debug_armed
    ldr x0, [x0, :got_lo12:debug_armed]
    str x1, [x0]
    adrp x0, :got:debug_bp_go
    ldr x0, [x0, :got_lo12:debug_bp_go]
    str xzr, [x0]
    adrp x0, :got:debug_runto_ip
    ldr x0, [x0, :got_lo12:debug_runto_ip]
    str xzr, [x0]
    adrp x0, :got:debug_runto_off
    ldr x0, [x0, :got_lo12:debug_runto_off]
    str xzr, [x0]
    adrp x0, :got:debug_runto_status
    ldr x0, [x0, :got_lo12:debug_runto_status]
    str xzr, [x0]
    adrp x0, :got:debug_break_asap
    ldr x0, [x0, :got_lo12:debug_break_asap]
    str xzr, [x0]
    adrp x0, :got:debug_over
    ldr x0, [x0, :got_lo12:debug_over]
    str xzr, [x0]
    adrp x0, :got:debug_out
    ldr x0, [x0, :got_lo12:debug_out]
    str xzr, [x0]
    adrp x0, :got:debug_abort
    ldr x0, [x0, :got_lo12:debug_abort]
    str xzr, [x0]
    adrp x0, :got:debug_view_cfa
    ldr x0, [x0, :got_lo12:debug_view_cfa]
    str xzr, [x0]
    adrp x0, :got:debug_skip_nl
    ldr x0, [x0, :got_lo12:debug_skip_nl]
    str x1, [x0]
    adrp x0, :got:debug_midline
    ldr x0, [x0, :got_lo12:debug_midline]
    str xzr, [x0]
    adrp x0, :got:debug_help_shown
    ldr x0, [x0, :got_lo12:debug_help_shown]
    str xzr, [x0]
    adrp x0, :got:debug_cursor_on
    ldr x0, [x0, :got_lo12:debug_cursor_on]
    str xzr, [x0]
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str xzr, [x0]
    adrp x0, :got:debug_need_intro
    ldr x0, [x0, :got_lo12:debug_need_intro]
    str x1, [x0]
    adrp x0, :got:debug_line_col
    ldr x0, [x0, :got_lo12:debug_line_col]
    str xzr, [x0]
    adrp x0, :got:debug_stack_anchor
    ldr x0, [x0, :got_lo12:debug_stack_anchor]
    str xzr, [x0]
    adrp x0, :got:debug_ip
    ldr x0, [x0, :got_lo12:debug_ip]
    str xzr, [x0]
    adrp x0, :got:debug_cfa
    ldr x0, [x0, :got_lo12:debug_cfa]
    str xzr, [x0]
    adrp x0, :got:debug_body_cells
    ldr x0, [x0, :got_lo12:debug_body_cells]
    str xzr, [x0]
    adrp x0, :got:debug_call_depth
    ldr x0, [x0, :got_lo12:debug_call_depth]
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
nm_XDBGOFF:
    .ascii "DBG-OFF"
    .byte 0
hl_XDBGOFF:
    .ascii "DBG-OFF ( -- ) disarm the NEXT stepper"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XDBGOFF:
    .quad nm_XDBGOFF, hl_XDBGOFF
    .quad 0
    .quad XDBGOFF, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XDBGOFF
    .text
    .p2align 2
XDBGOFF:
    mov x28, #0
    adrp x0, :got:debug_armed
    ldr x0, [x0, :got_lo12:debug_armed]
    str xzr, [x0]
    adrp x0, :got:debug_call_depth
    ldr x0, [x0, :got_lo12:debug_call_depth]
    str xzr, [x0]
    adrp x0, :got:debug_midline
    ldr x0, [x0, :got_lo12:debug_midline]
    str xzr, [x0]
    adrp x0, :got:debug_help_shown
    ldr x0, [x0, :got_lo12:debug_help_shown]
    str xzr, [x0]
    adrp x0, :got:debug_cursor_on
    ldr x0, [x0, :got_lo12:debug_cursor_on]
    str xzr, [x0]
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str xzr, [x0]
    adrp x0, :got:debug_need_intro
    ldr x0, [x0, :got_lo12:debug_need_intro]
    str xzr, [x0]
    adrp x0, :got:debug_line_col
    ldr x0, [x0, :got_lo12:debug_line_col]
    str xzr, [x0]
    adrp x0, :got:debug_stack_anchor
    ldr x0, [x0, :got_lo12:debug_stack_anchor]
    str xzr, [x0]
    adrp x0, :got:debug_ip
    ldr x0, [x0, :got_lo12:debug_ip]
    str xzr, [x0]
    adrp x0, :got:debug_cfa
    ldr x0, [x0, :got_lo12:debug_cfa]
    str xzr, [x0]
    adrp x0, :got:debug_body_cells
    ldr x0, [x0, :got_lo12:debug_body_cells]
    str xzr, [x0]
    adrp x0, :got:debug_floor
    ldr x0, [x0, :got_lo12:debug_floor]
    str xzr, [x0]
    adrp x0, :got:debug_over
    ldr x0, [x0, :got_lo12:debug_over]
    str xzr, [x0]
    adrp x0, :got:debug_out
    ldr x0, [x0, :got_lo12:debug_out]
    str xzr, [x0]
    adrp x0, :got:debug_bp_go
    ldr x0, [x0, :got_lo12:debug_bp_go]
    str xzr, [x0]
    adrp x0, :got:debug_runto_ip
    ldr x0, [x0, :got_lo12:debug_runto_ip]
    str xzr, [x0]
    adrp x0, :got:debug_runto_off
    ldr x0, [x0, :got_lo12:debug_runto_off]
    str xzr, [x0]
    adrp x0, :got:debug_runto_status
    ldr x0, [x0, :got_lo12:debug_runto_status]
    str xzr, [x0]
    adrp x0, :got:debug_break_asap
    ldr x0, [x0, :got_lo12:debug_break_asap]
    str xzr, [x0]
    adrp x0, :got:debug_abort
    ldr x0, [x0, :got_lo12:debug_abort]
    str xzr, [x0]
    adrp x0, :got:debug_view_cfa
    ldr x0, [x0, :got_lo12:debug_view_cfa]
    str xzr, [x0]
    stp x29, x30, [sp, #-16]!
    bl host_debug_paint
    adrp x0, :got:str_dbg_done
    ldr x0, [x0, :got_lo12:str_dbg_done]
    bl _emit_z
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
nm_XBREAK_TABLE:
    .ascii "BREAK-TABLE"
    .byte 0
hl_XBREAK_TABLE:
    .ascii "BREAK-TABLE ( -- addr ) 8 breakpoint xt slots"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBREAK_TABLE:
    .quad nm_XBREAK_TABLE, hl_XBREAK_TABLE
    .quad 0
    .quad XBREAK_TABLE, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBREAK_TABLE
    .text
    .p2align 2
XBREAK_TABLE:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_bp_xts
    ldr x20, [x20, :got_lo12:debug_bp_xts]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XBREAK_ENABLES:
    .ascii "BREAK-ENABLES"
    .byte 0
hl_XBREAK_ENABLES:
    .ascii "BREAK-ENABLES ( -- addr ) 8 breakpoint enable flags"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBREAK_ENABLES:
    .quad nm_XBREAK_ENABLES, hl_XBREAK_ENABLES
    .quad 0
    .quad XBREAK_ENABLES, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBREAK_ENABLES
    .text
    .p2align 2
XBREAK_ENABLES:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_bp_en
    ldr x20, [x20, :got_lo12:debug_bp_en]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XBPGO:
    .ascii "(BP-GO)"
    .byte 0
hl_XBPGO:
    .ascii "(BP-GO) ( -- ) run until an enabled breakpoint xt"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XBPGO:
    .quad nm_XBPGO, hl_XBPGO
    .quad 0
    .quad XBPGO, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XBPGO
    .text
    .p2align 2
XBPGO:
    adrp x0, :got:debug_bp_go
    ldr x0, [x0, :got_lo12:debug_bp_go]
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
nm_XRUNTOIP:
    .ascii "(RUNTO-IP)"
    .byte 0
hl_XRUNTOIP:
    .ascii "(RUNTO-IP) ( addr -- ) arm run-to at a threaded cell"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRUNTOIP:
    .quad nm_XRUNTOIP, hl_XRUNTOIP
    .quad 0
    .quad XRUNTOIP, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRUNTOIP
    .text
    .p2align 2
XRUNTOIP:
    mov x0, x20
    ldr x20, [x22], #8
    adrp x1, :got:debug_runto_ip
    ldr x1, [x1, :got_lo12:debug_runto_ip]
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
nm_XRUNTOOFFAT:
    .ascii "RUNTO-OFF@"
    .byte 0
hl_XRUNTOOFFAT:
    .ascii "RUNTO-OFF@ ( -- off ) pending file offset for run-to"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRUNTOOFFAT:
    .quad nm_XRUNTOOFFAT, hl_XRUNTOOFFAT
    .quad 0
    .quad XRUNTOOFFAT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRUNTOOFFAT
    .text
    .p2align 2
XRUNTOOFFAT:
    str x20, [x22, #-8]!
    adrp x20, :got:debug_runto_off
    ldr x20, [x20, :got_lo12:debug_runto_off]
    ldr x20, [x20]
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XRUNTOSTAT:
    .ascii "RUNTO-STATUS!"
    .byte 0
hl_XRUNTOSTAT:
    .ascii "RUNTO-STATUS! ( n -- ) store the host run-to status"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XRUNTOSTAT:
    .quad nm_XRUNTOSTAT, hl_XRUNTOSTAT
    .quad 0
    .quad XRUNTOSTAT, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XRUNTOSTAT
    .text
    .p2align 2
XRUNTOSTAT:
    mov x0, x20
    ldr x20, [x22], #8
    adrp x1, :got:debug_runto_status
    ldr x1, [x1, :got_lo12:debug_runto_status]
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
nm_XVIEW_PATH:
    .ascii "VIEW-PATH"
    .byte 0
hl_XVIEW_PATH:
    .ascii "VIEW-PATH ( id -- c-addr u | 0 0 ) path for a VIEW file id"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XVIEW_PATH:
    .quad nm_XVIEW_PATH, hl_XVIEW_PATH
    .quad 0
    .quad XVIEW_PATH, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XVIEW_PATH
    .text
    .p2align 2
XVIEW_PATH:
    mov x1, x20
    cbz x1, view_path_none
    adrp x0, :got:view_file_n
    ldr x0, [x0, :got_lo12:view_file_n]
    ldr x0, [x0]
    cmp x1, x0
    b.hi view_path_none
    sub x2, x1, #1
    mov x3, #VIEW_PATH_MAX
    mul x2, x2, x3
    adrp x0, :got:view_paths
    ldr x0, [x0, :got_lo12:view_paths]
    add x0, x0, x2
    ldrb w2, [x0]
    add x3, x0, #1
    str x3, [x22, #-8]!
    mov x20, x2
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
view_path_none:
    str xzr, [x22, #-8]!
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
nm_XVIEW_REG:
    .ascii "VIEW-REG"
    .byte 0
hl_XVIEW_REG:
    .ascii "VIEW-REG ( c-addr u -- id ) register a source path for VIEW"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XVIEW_REG:
    .quad nm_XVIEW_REG, hl_XVIEW_REG
    .quad 0
    .quad XVIEW_REG, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XVIEW_REG
    .text
    .p2align 2
XVIEW_REG:
    mov x1, x20
    ldr x0, [x22], #8
    cmp x1, #0
    b.le view_reg_fail
    cmp x1, #255
    b.hi view_reg_fail
    cbz x0, view_reg_fail
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    bl _view_register_path
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
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
view_reg_fail:
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
nm_XVIEW_STAMP:
    .ascii "VIEW-STAMP"
    .byte 0
hl_XVIEW_STAMP:
    .ascii "VIEW-STAMP ( xt file-id line -- ) set the source VIEW in the header"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XVIEW_STAMP:
    .quad nm_XVIEW_STAMP, hl_XVIEW_STAMP
    .quad 0
    .quad XVIEW_STAMP, 0
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XVIEW_STAMP
    .text
    .p2align 2
XVIEW_STAMP:
    mov x3, x20
    ldr x2, [x22], #8
    ldr x1, [x22], #8
    ldr x20, [x22], #8
    cbz x1, view_stamp_done
    ldr x0, [x1, #-8]
    mov x4, #0xFFFF
    lsl x4, x4, #32
    bic x0, x0, x4
    mov x4, #VIEW_FILE_MASK
    lsl x4, x4, #48
    bic x0, x0, x4
    and x3, x3, #0xFFFF
    lsl x3, x3, #32
    orr x0, x0, x3
    mov x4, #VIEW_FILE_MASK
    and x2, x2, x4
    lsl x2, x2, #48
    orr x0, x0, x2
    str x0, [x1, #-8]
view_stamp_done:
    cbnz x28, next_debug_gate
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    ldr x1, [x1]
    cbnz x1, next_debug_gate
    ldr x21, [x19], #8
    ldr x1, [x21]
    br x1
_debug_pause:
    stp x29, x30, [sp, #-64]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    adrp x0, :got:debug_pause_rsp
    ldr x0, [x0, :got_lo12:debug_pause_rsp]
    str x23, [x0]
    adrp x0, :got:debug_xt
    ldr x0, [x0, :got_lo12:debug_xt]
    str x21, [x0]
    ldr x0, [x19, #8]
    adrp x1, :got:debug_inline
    ldr x1, [x1, :got_lo12:debug_inline]
    str x0, [x1]
    adrp x0, :got:debug_ip
    ldr x0, [x0, :got_lo12:debug_ip]
    str x19, [x0]
    mov x0, x19
    mov x1, x21
    bl _debug_resolve_enclosing
    adrp x2, :got:debug_cfa
    ldr x2, [x2, :got_lo12:debug_cfa]
    str x0, [x2]
    lsr x1, x1, #3
    adrp x2, :got:debug_body_cells
    ldr x2, [x2, :got_lo12:debug_body_cells]
    str x1, [x2]
    adrp x0, :got:tw_continue_cell
    ldr x0, [x0, :got_lo12:tw_continue_cell]
    cmp x19, x0
    b.eq pause_leave
    adrp x0, :got:debug_pause_xt
    ldr x0, [x0, :got_lo12:debug_pause_xt]
    ldr x0, [x0]
    cbz x0, pause_asm
    bl _debug_capture
    adrp x0, :got:debug_pause_xt
    ldr x0, [x0, :got_lo12:debug_pause_xt]
    ldr x0, [x0]
    bl _debug_call_xt
    b pause_leave
pause_asm:
    adrp x0, :got:debug_need_intro
    ldr x0, [x0, :got_lo12:debug_need_intro]
    ldr x1, [x0]
    cbz x1, pause_after
    str xzr, [x0]
    bl _debug_end_line
    adrp x0, :got:str_dbg_keys
    ldr x0, [x0, :got_lo12:str_dbg_keys]
    bl _emit_z
    mov x0, #10
    bl _putchar
    bl _debug_pad_to_stack_col
    bl _debug_print_SR
    mov x0, #10
    bl _putchar
    b pause_word
pause_after:
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    ldr x1, [x0]
    cbz x1, pause_word
    str xzr, [x0]
    adrp x0, :got:debug_help_shown
    ldr x0, [x0, :got_lo12:debug_help_shown]
    ldr x1, [x0]
    cbz x1, pause_pad_sr
    str xzr, [x0]
    mov x0, #10
    bl _putchar
pause_pad_sr:
    bl _debug_pad_to_stack_col
    bl _debug_print_SR
    mov x0, #10
    bl _putchar
pause_word:
    adrp x0, :got:debug_line_col
    ldr x0, [x0, :got_lo12:debug_line_col]
    str xzr, [x0]
    mov x0, x21
    bl _debug_xt_intoable
    cbz x0, pause_chevrons
    mov x0, #'I'
    bl _putchar
pause_chevrons:
    mov x0, #62
    bl _putchar
    mov x0, #62
    bl _putchar
    mov x0, #32
    bl _putchar
    mov x0, x21
    bl _print_xt_name
    bl _debug_print_inline_suffix
    mov x0, #32
    bl _putchar
    bl _debug_cursor_on
    bl _debug_capture
    bl _debug_sync_view
    bl _debug_highlight
    bl host_debug_paint
pause_key:
    bl _getchar
    tbnz x0, #63, pause_key_abort
    adrp x2, :got:debug_key_xt
    ldr x2, [x2, :got_lo12:debug_key_xt]
    ldr x2, [x2]
    cbz x2, pause_asm_key
    adrp x1, :got:debug_key_raw
    ldr x1, [x1, :got_lo12:debug_key_raw]
    str x0, [x1]
    bl _debug_ds_isolate
    adrp x1, :got:debug_key_raw
    ldr x1, [x1, :got_lo12:debug_key_raw]
    ldr x20, [x1]
    adrp x0, :got:debug_key_xt
    ldr x0, [x0, :got_lo12:debug_key_xt]
    ldr x0, [x0]
    bl _debug_call_xt
    adrp x1, :got:debug_call_tos
    ldr x1, [x1, :got_lo12:debug_call_tos]
    ldr x1, [x1]
    adrp x0, :got:debug_key_mode
    ldr x0, [x0, :got_lo12:debug_key_mode]
    str x1, [x0]
    bl _debug_ds_restore
    adrp x0, :got:debug_key_mode
    ldr x0, [x0, :got_lo12:debug_key_mode]
    ldr x0, [x0]
    cbz x0, pause_key
    cmp x0, #1
    b.eq pause_over
    cmp x0, #2
    b.eq pause_into
    cmp x0, #3
    b.eq pause_out
    cmp x0, #4
    b.eq pause_go
    cmp x0, #5
    b.eq pause_key_abort
    cmp x0, #6
    b.eq pause_wheel_key
    cmp x0, #7
    b.eq pause_help
    adrp x0, :got:debug_key_raw
    ldr x0, [x0, :got_lo12:debug_key_raw]
    ldr x0, [x0]
pause_asm_key:
    lsr x1, x0, #24
    and x1, x1, #0xFF
    cmp x1, #2
    b.ne pause_not_fkey
    mov x2, #0xFFFFFF
    and x0, x0, x2
    cmp x0, #16
    b.eq pause_over
    cmp x0, #17
    b.eq pause_into
    cmp x0, #18
    b.eq pause_out
    b pause_key
pause_not_fkey:
    cmp x1, #1
    b.ne pause_plain
    mov x2, #0x1FFFFF
    and x0, x0, x2
pause_plain:
    adrp x1, :got:debug_skip_nl
    ldr x1, [x1, :got_lo12:debug_skip_nl]
    ldr x2, [x1]
    cbz x2, pause_take
    cmp w0, #10
    b.eq pause_key
    cmp w0, #13
    b.eq pause_key
    str xzr, [x1]
pause_take:
    cmp w0, #'h'
    b.eq pause_help
    cmp w0, #'H'
    b.eq pause_help
    cmp w0, #134
    b.eq pause_go
    cmp w0, #'g'
    b.eq pause_go
    cmp w0, #'G'
    b.eq pause_go
    cmp w0, #27
    b.eq pause_key_abort
    cmp w0, #'q'
    b.eq pause_key_abort
    cmp w0, #'Q'
    b.eq pause_key_abort
    cmp w0, #32
    b.eq pause_over
    cmp w0, #13
    b.eq pause_over
    cmp w0, #'o'
    b.eq pause_over
    cmp w0, #'O'
    b.eq pause_over
    cmp w0, #'i'
    b.eq pause_into
    cmp w0, #'I'
    b.eq pause_into
    cmp w0, #'u'
    b.eq pause_out
    cmp w0, #'U'
    b.eq pause_out
    cmp w0, #3
    b.eq pause_wheel_raw
    cmp w0, #7
    b.eq pause_wheel_raw
    cbz w0, pause_wheel_raw
    b pause_key
pause_help:
    adrp x1, :got:debug_help_shown
    ldr x1, [x1, :got_lo12:debug_help_shown]
    ldr x0, [x1]
    cbnz x0, pause_key
    bl _debug_cursor_off
    adrp x0, :got:str_dbg_keys
    ldr x0, [x0, :got_lo12:str_dbg_keys]
    bl _emit_z
    mov x1, #1
    adrp x0, :got:debug_help_shown
    ldr x0, [x0, :got_lo12:debug_help_shown]
    str x1, [x0]
    bl _debug_cursor_on
    b pause_key
pause_wheel_key:
    adrp x0, :got:debug_key_raw
    ldr x0, [x0, :got_lo12:debug_key_raw]
    ldr x0, [x0]
pause_wheel_raw:
    bl _debug_wheel
    b pause_key
pause_over:
    bl _debug_cursor_off
    mov x1, #1
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str x1, [x0]
    adrp x1, :got:debug_out
    ldr x1, [x1, :got_lo12:debug_out]
    str xzr, [x1]
    adrp x1, :got:debug_over
    ldr x1, [x1, :got_lo12:debug_over]
    str xzr, [x1]
    adrp x0, :got:debug_xt
    ldr x0, [x0, :got_lo12:debug_xt]
    ldr x0, [x0]
    cbz x0, pause_leave
    ldr x0, [x0]
    adrp x2, :got:DOCOL
    ldr x2, [x2, :got_lo12:DOCOL]
    cmp x0, x2
    b.ne pause_leave
    str x23, [x1]
    b pause_leave
pause_into:
    bl _debug_cursor_off
    mov x1, #1
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str x1, [x0]
    adrp x1, :got:debug_out
    ldr x1, [x1, :got_lo12:debug_out]
    str xzr, [x1]
    adrp x1, :got:debug_over
    ldr x1, [x1, :got_lo12:debug_over]
    str xzr, [x1]
    b pause_leave
pause_out:
    bl _debug_cursor_off
    mov x1, #1
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str x1, [x0]
    adrp x1, :got:debug_over
    ldr x1, [x1, :got_lo12:debug_over]
    str xzr, [x1]
    adrp x1, :got:debug_out
    ldr x1, [x1, :got_lo12:debug_out]
    str x23, [x1]
    b pause_leave
pause_key_abort:
    bl _debug_cursor_off
    bl _debug_clear_step
    adrp x0, :got:str_dbg_abort
    ldr x0, [x0, :got_lo12:str_dbg_abort]
    bl _emit_z
    bl _debug_disarm
    bl host_debug_paint
    b pause_leave
pause_go:
    bl _debug_cursor_off
    bl _debug_clear_step
    adrp x1, :got:debug_bp_go
    ldr x1, [x1, :got_lo12:debug_bp_go]
    ldr x0, [x1]
    cbnz x0, pause_leave
    adrp x1, :got:debug_runto_ip
    ldr x1, [x1, :got_lo12:debug_runto_ip]
    ldr x0, [x1]
    cbnz x0, pause_leave
    mov x28, #0
    adrp x1, :got:debug_armed
    ldr x1, [x1, :got_lo12:debug_armed]
    str xzr, [x1]
    adrp x1, :got:debug_bp_go
    ldr x1, [x1, :got_lo12:debug_bp_go]
    str xzr, [x1]
    adrp x1, :got:debug_runto_ip
    ldr x1, [x1, :got_lo12:debug_runto_ip]
    str xzr, [x1]
    bl host_debug_paint
pause_leave:
    adrp x0, :got:debug_armed
    ldr x0, [x0, :got_lo12:debug_armed]
    ldr x28, [x0]
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    ldp x23, x24, [sp, #48]
    ldp x29, x30, [sp], #64
    ret
_debug_disarm:
    mov x2, #-1
    adrp x1, :got:debug_abort
    ldr x1, [x1, :got_lo12:debug_abort]
    str x2, [x1]
    mov x28, #0
    adrp x1, :got:debug_armed
    ldr x1, [x1, :got_lo12:debug_armed]
    str xzr, [x1]
    adrp x1, :got:debug_bp_go
    ldr x1, [x1, :got_lo12:debug_bp_go]
    str xzr, [x1]
    adrp x1, :got:debug_runto_ip
    ldr x1, [x1, :got_lo12:debug_runto_ip]
    str xzr, [x1]
    adrp x1, :got:debug_runto_off
    ldr x1, [x1, :got_lo12:debug_runto_off]
    str xzr, [x1]
    adrp x1, :got:debug_runto_status
    ldr x1, [x1, :got_lo12:debug_runto_status]
    str xzr, [x1]
    adrp x1, :got:debug_over
    ldr x1, [x1, :got_lo12:debug_over]
    str xzr, [x1]
    adrp x1, :got:debug_out
    ldr x1, [x1, :got_lo12:debug_out]
    str xzr, [x1]
    adrp x1, :got:debug_break_asap
    ldr x1, [x1, :got_lo12:debug_break_asap]
    str xzr, [x1]
    ret
_debug_clear_step:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:debug_need_stacks
    ldr x0, [x0, :got_lo12:debug_need_stacks]
    str xzr, [x0]
    adrp x0, :got:debug_need_intro
    ldr x0, [x0, :got_lo12:debug_need_intro]
    str xzr, [x0]
    bl _debug_end_line
    adrp x0, :got:debug_help_shown
    ldr x0, [x0, :got_lo12:debug_help_shown]
    str xzr, [x0]
    adrp x1, :got:debug_midline
    ldr x1, [x1, :got_lo12:debug_midline]
    str xzr, [x1]
    adrp x1, :got:debug_over
    ldr x1, [x1, :got_lo12:debug_over]
    str xzr, [x1]
    adrp x1, :got:debug_out
    ldr x1, [x1, :got_lo12:debug_out]
    str xzr, [x1]
    ldp x29, x30, [sp], #16
    ret
_debug_end_line:
    stp x29, x30, [sp, #-16]!
    adrp x1, :got:debug_midline
    ldr x1, [x1, :got_lo12:debug_midline]
    ldr x0, [x1]
    cbz x0, end_line_done
    str xzr, [x1]
    mov x0, #10
    bl _putchar
end_line_done:
    ldp x29, x30, [sp], #16
    ret
_emit_z:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    mov x19, x0
emit_z_loop:
    ldrb w0, [x19], #1
    cbz w0, emit_z_done
    bl _putchar
    b emit_z_loop
emit_z_done:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_call_xt:
    cbz x0, call_xt_ret
    adrp x2, :got:debug_call_depth
    ldr x2, [x2, :got_lo12:debug_call_depth]
    ldr x3, [x2]
    cmp x3, #DEBUG_CALL_MAX
    b.hs call_xt_ret
    adrp x1, :got:debug_vmsave_stack
    ldr x1, [x1, :got_lo12:debug_vmsave_stack]
    mov x4, #DEBUG_VMSAVE_SIZE
    mul x4, x3, x4
    add x1, x1, x4
    add x3, x3, #1
    str x3, [x2]
    stp x19, x20, [x1]
    stp x21, x22, [x1, #16]
    stp x23, x24, [x1, #32]
    stp x29, x30, [x1, #48]
    str x28, [x1, #64]
    sub x4, x3, #1
    mov x5, #4096
    adrp x23, :got:debug_nest_rstack
    ldr x23, [x23, :got_lo12:debug_nest_rstack]
    mul x4, x4, x5
    add x23, x23, x4
    add x23, x23, x5
    mov x28, #0
    adrp x19, :got:debug_ret_ipcell
    ldr x19, [x19, :got_lo12:debug_ret_ipcell]
    mov x21, x0
    ldr x1, [x21]
    br x1
call_xt_ret:
    ret
    .p2align 2
XDBG_CALL_DONE:
    adrp x1, :got:debug_call_tos
    ldr x1, [x1, :got_lo12:debug_call_tos]
    str x20, [x1]
    adrp x2, :got:debug_call_depth
    ldr x2, [x2, :got_lo12:debug_call_depth]
    ldr x3, [x2]
    cbz x3, call_done_ret
    sub x3, x3, #1
    str x3, [x2]
    adrp x1, :got:debug_vmsave_stack
    ldr x1, [x1, :got_lo12:debug_vmsave_stack]
    mov x4, #DEBUG_VMSAVE_SIZE
    mul x4, x3, x4
    add x1, x1, x4
    ldp x19, x20, [x1]
    ldp x21, x22, [x1, #16]
    ldp x23, x24, [x1, #32]
    ldp x29, x30, [x1, #48]
    ldr x28, [x1, #64]
call_done_ret:
    ret
_debug_ds_isolate:
    stp x29, x30, [sp, #-16]!
    stp x19, x21, [sp, #-16]!
    adrp x19, :got:data_stack
    ldr x19, [x19, :got_lo12:data_stack]
    add x19, x19, #1, lsl #12
    adrp x0, :got:debug_dsave_tos
    ldr x0, [x0, :got_lo12:debug_dsave_tos]
    str x20, [x0]
    adrp x0, :got:debug_dsave_dsp
    ldr x0, [x0, :got_lo12:debug_dsave_dsp]
    str x22, [x0]
    mov x1, #0
    cmp x22, x19
    b.hs ds_iso_store
    sub x1, x19, x22
    lsr x1, x1, #3
    cmp x1, #DBG_DSAVE_MAX
    b.ls ds_iso_copy
    mov x1, #DBG_DSAVE_MAX
ds_iso_copy:
    adrp x0, :got:debug_dsave_buf
    ldr x0, [x0, :got_lo12:debug_dsave_buf]
    mov x2, #0
ds_iso_loop:
    cmp x2, x1
    b.hs ds_iso_store
    ldr x3, [x22, x2, lsl #3]
    str x3, [x0, x2, lsl #3]
    add x2, x2, #1
    b ds_iso_loop
ds_iso_store:
    adrp x0, :got:debug_dsave_n
    ldr x0, [x0, :got_lo12:debug_dsave_n]
    str x1, [x0]
    mov x22, x19
    mov x20, #0
    ldp x19, x21, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_ds_restore:
    stp x29, x30, [sp, #-16]!
    stp x19, x21, [sp, #-16]!
    adrp x0, :got:debug_dsave_n
    ldr x0, [x0, :got_lo12:debug_dsave_n]
    ldr x1, [x0]
    adrp x0, :got:debug_dsave_dsp
    ldr x0, [x0, :got_lo12:debug_dsave_dsp]
    ldr x22, [x0]
    adrp x0, :got:debug_dsave_tos
    ldr x0, [x0, :got_lo12:debug_dsave_tos]
    ldr x20, [x0]
    cbz x1, ds_res_done
    adrp x0, :got:debug_dsave_buf
    ldr x0, [x0, :got_lo12:debug_dsave_buf]
    mov x2, #0
ds_res_loop:
    cmp x2, x1
    b.hs ds_res_done
    ldr x3, [x0, x2, lsl #3]
    str x3, [x22, x2, lsl #3]
    add x2, x2, #1
    b ds_res_loop
ds_res_done:
    ldp x19, x21, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_sync_view:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:debug_cfa
    ldr x0, [x0, :got_lo12:debug_cfa]
    ldr x0, [x0]
    cbnz x0, sync_have
    mov x0, x19
    adrp x1, :got:debug_xt
    ldr x1, [x1, :got_lo12:debug_xt]
    ldr x1, [x1]
    bl _debug_resolve_enclosing
sync_have:
    cbz x0, sync_done
    adrp x1, :got:debug_view_cfa
    ldr x1, [x1, :got_lo12:debug_view_cfa]
    ldr x2, [x1]
    cmp x0, x2
    b.eq sync_done
    stp x0, x1, [sp, #-16]!
    adrp x24, :got:debug_view_name
    ldr x24, [x24, :got_lo12:debug_view_name]
    strb wzr, [x24]
    tst x0, #7
    b.ne sync_drop
    ldr x1, [x0, #-8]
    and x1, x1, #0xFFFF
    cbz x1, sync_drop
    lsr x4, x1, #12
    cbnz x4, sync_drop
    sub x0, x0, x1
    ldrb w1, [x0], #1
    and w1, w1, #NFA_LEN_MASK
    cbz w1, sync_drop
    cmp w1, #31
    b.ls sync_len_ok
    mov w1, #31
sync_len_ok:
    strb w1, [x24], #1
    mov x2, #0
sync_copy:
    cmp x2, x1
    b.hs sync_copied
    ldrb w3, [x0, x2]
    strb w3, [x24, x2]
    add x2, x2, #1
    b sync_copy
sync_copied:
    adrp x0, :got:debug_show_xt
    ldr x0, [x0, :got_lo12:debug_show_xt]
    ldr x0, [x0]
    cbz x0, sync_drop
    adrp x1, :got:debug_view_name
    ldr x1, [x1, :got_lo12:debug_view_name]
    ldrb w2, [x1], #1
    cbz w2, sync_drop
    adrp x3, :got:debug_sync_ok
    ldr x3, [x3, :got_lo12:debug_sync_ok]
    str xzr, [x3]
    stp x1, x2, [sp, #-16]!
    bl _debug_ds_isolate
    ldp x1, x2, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x1
    str x20, [x22, #-8]!
    mov x20, x2
    adrp x0, :got:debug_show_xt
    ldr x0, [x0, :got_lo12:debug_show_xt]
    ldr x0, [x0]
    bl _debug_call_xt
    bl _debug_ds_restore
    adrp x3, :got:debug_sync_ok
    ldr x3, [x3, :got_lo12:debug_sync_ok]
    ldr x0, [x3]
    str xzr, [x3]
    cbz x0, sync_drop
    ldp x0, x1, [sp], #16
    str x0, [x1]
    b sync_done
sync_drop:
    add sp, sp, #16
sync_done:
    ldp x29, x30, [sp], #16
    ret
_debug_wheel:
    stp x29, x30, [sp, #-16]!
    adrp x1, :got:debug_wheel_xt
    ldr x1, [x1, :got_lo12:debug_wheel_xt]
    ldr x1, [x1]
    cbz x1, wheel_done
    stp x0, x1, [sp, #-16]!
    bl _debug_ds_isolate
    ldp x0, x1, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x0
    mov x0, x1
    bl _debug_call_xt
    bl _debug_ds_restore
    bl host_debug_paint
wheel_done:
    ldp x29, x30, [sp], #16
    ret
_debug_highlight:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:debug_ip
    ldr x0, [x0, :got_lo12:debug_ip]
    ldr x0, [x0]
    adrp x1, :got:tw_continue_cell
    ldr x1, [x1, :got_lo12:tw_continue_cell]
    cmp x0, x1
    b.eq hl_done
    adrp x0, :got:debug_hl_xt
    ldr x0, [x0, :got_lo12:debug_hl_xt]
    ldr x0, [x0]
    cbz x0, hl_done
    adrp x1, :got:debug_name
    ldr x1, [x1, :got_lo12:debug_name]
    ldrb w2, [x1], #1
    cbz w2, hl_done
    stp x1, x2, [sp, #-16]!
    bl _debug_ds_isolate
    ldp x1, x2, [sp], #16
    str x20, [x22, #-8]!
    mov x20, x1
    str x20, [x22, #-8]!
    mov x20, x2
    adrp x0, :got:debug_hl_xt
    ldr x0, [x0, :got_lo12:debug_hl_xt]
    ldr x0, [x0]
    bl _debug_call_xt
    bl _debug_ds_restore
hl_done:
    ldp x29, x30, [sp], #16
    ret
_debug_capture:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    adrp x19, :got:data_stack
    ldr x19, [x19, :got_lo12:data_stack]
    add x19, x19, #1, lsl #12
    adrp x9, :got:debug_scnt
    ldr x9, [x9, :got_lo12:debug_scnt]
    cmp x22, x19
    b.hs cap_s_empty
    sub x21, x19, x22
    lsr x21, x21, #3
    cmp x21, #16
    b.ls cap_s_n
    mov x21, #16
cap_s_n:
    str x21, [x9]
    adrp x24, :got:debug_sbuf
    ldr x24, [x24, :got_lo12:debug_sbuf]
    cbz x21, cap_r
    sub x1, x21, #1
    str x20, [x24, x1, lsl #3]
    cbz x1, cap_r
    mov x0, #0
cap_s_loop:
    cmp x0, x1
    b.hs cap_r
    sub x2, x1, x0
    sub x2, x2, #1
    ldr x3, [x22, x2, lsl #3]
    str x3, [x24, x0, lsl #3]
    add x0, x0, #1
    b cap_s_loop
cap_s_empty:
    str xzr, [x9]
cap_r:
    adrp x19, :got:return_stack
    ldr x19, [x19, :got_lo12:return_stack]
    add x19, x19, #1, lsl #12
    adrp x10, :got:debug_floor
    ldr x10, [x10, :got_lo12:debug_floor]
    ldr x10, [x10]
    cbz x10, cap_r_clip
    cmp x10, x19
    b.hi cap_r_clip
    cmp x10, x23
    b.ls cap_r_clip
    mov x19, x10
cap_r_clip:
    adrp x24, :got:debug_rbuf
    ldr x24, [x24, :got_lo12:debug_rbuf]
    adrp x10, :got:throw_handler
    ldr x10, [x10, :got_lo12:throw_handler]
    ldr x10, [x10]
    cmp x23, x19
    b.hs cap_r_empty
    sub x21, x19, x23
    lsr x21, x21, #3
    mov x0, #0
    mov x1, #0
cap_r_loop:
    cmp x0, x21
    b.hs cap_r_store
    add x2, x23, x0, lsl #3
    cmp x2, x10
    b.ne cap_r_keep
    add x0, x0, #6
    b cap_r_loop
cap_r_keep:
    cmp x1, #16
    b.hs cap_r_store
    ldr x2, [x23, x0, lsl #3]
    str x2, [x24, x1, lsl #3]
    add x1, x1, #1
    add x0, x0, #1
    b cap_r_loop
cap_r_empty:
    mov x1, #0
cap_r_store:
    adrp x9, :got:debug_rcnt
    ldr x9, [x9, :got_lo12:debug_rcnt]
    str x1, [x9]
    adrp x0, :got:debug_xt
    ldr x0, [x0, :got_lo12:debug_xt]
    ldr x0, [x0]
    adrp x19, :got:debug_name
    ldr x19, [x19, :got_lo12:debug_name]
    strb wzr, [x19]
    cbz x0, cap_done
    adrp x1, :got:tw_continue_cfa
    ldr x1, [x1, :got_lo12:tw_continue_cfa]
    cmp x0, x1
    b.eq cap_done
    tst x0, #7
    b.ne cap_done
    ldr x1, [x0, #-8]
    and x1, x1, #0xFFFF
    cbz x1, cap_done
    lsr x4, x1, #12
    cbnz x4, cap_done
    sub x0, x0, x1
    ldrb w1, [x0], #1
    and w1, w1, #NFA_LEN_MASK
    cbz w1, cap_done
    cmp w1, #31
    b.ls cap_name_ok
    mov w1, #31
cap_name_ok:
    strb w1, [x19], #1
    mov x2, #0
cap_name_loop:
    cmp x2, x1
    b.hs cap_done
    ldrb w3, [x0, x2]
    strb w3, [x19, x2]
    add x2, x2, #1
    b cap_name_loop
cap_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_resolve_enclosing:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    mov x19, x0
    mov x20, x1
    adrp x0, :got:catch_ok_cell
    ldr x0, [x0, :got_lo12:catch_ok_cell]
    cmp x19, x0
    b.eq res_catch
    adrp x0, :got:tw_continue_cell
    ldr x0, [x0, :got_lo12:tw_continue_cell]
    cmp x19, x0
    b.ne res_scan
    ldr x0, [x23, #8]
    cbz x0, res_none
    tst x0, #7
    b.ne res_none
    ldr x1, [x0]
    adrp x2, :got:DOCOL
    ldr x2, [x2, :got_lo12:DOCOL]
    cmp x1, x2
    b.ne res_none
    mov x1, #0
    b res_out
res_catch:
    mov x0, x20
    cbz x0, res_none
    tst x0, #7
    b.ne res_none
    ldr x1, [x0]
    adrp x2, :got:DOCOL
    ldr x2, [x2, :got_lo12:DOCOL]
    cmp x1, x2
    b.ne res_none
    mov x1, #0
    b res_out
res_scan:
    mov x0, x19
    bl _ip_find_colon
    cbnz x0, res_out
    mov x0, x20
    cbz x0, res_none
    tst x0, #7
    b.ne res_none
    ldr x1, [x0]
    adrp x2, :got:DOCOL
    ldr x2, [x2, :got_lo12:DOCOL]
    cmp x1, x2
    b.ne res_none
    mov x1, #0
    b res_out
res_none:
    mov x0, #0
    mov x1, #0
res_out:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_ip_find_colon:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    mov x20, x0
    mov x21, #0
    mov x22, #0
    adrp x19, :got:wordlist_reg_n
    ldr x19, [x19, :got_lo12:wordlist_reg_n]
    ldr x19, [x19]
    adrp x23, :got:wordlist_reg
    ldr x23, [x23, :got_lo12:wordlist_reg]
    mov x24, #0
ip_wid_loop:
    cmp x24, x19
    b.hs ip_wid_done
    ldr x0, [x23, x24, lsl #3]
    bl _ip_scan_wid
    add x24, x24, #1
    b ip_wid_loop
ip_wid_done:
    adrp x0, :got:latest_var
    ldr x0, [x0, :got_lo12:latest_var]
    bl _ip_scan_wid
    mov x0, x21
    cbz x21, ip_no_off
    sub x1, x20, x22
    b ip_find_out
ip_no_off:
    mov x1, #0
ip_find_out:
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_ip_scan_wid:
    cbz x0, scan_ret
    mov x9, #0
scan_thread:
    cmp x9, #DICT_THREADS
    b.hs scan_ret
    ldr x10, [x0, x9, lsl #3]
scan_link:
    cbz x10, scan_next_thread
    tst x10, #7
    b.ne scan_next_thread
    ldr x11, [x10]
    adrp x12, :got:DOCOL
    ldr x12, [x12, :got_lo12:DOCOL]
    cmp x11, x12
    b.ne scan_lfa
    add x11, x10, #8
    cmp x11, x20
    b.hi scan_lfa
    sub x12, x20, x11
    lsr x13, x12, #20
    cbnz x13, scan_lfa
    cbz x21, scan_take
    cmp x11, x22
    b.ls scan_lfa
scan_take:
    mov x22, x11
    mov x21, x10
scan_lfa:
    ldr x10, [x10, #-16]
    b scan_link
scan_next_thread:
    add x9, x9, #1
    b scan_thread
scan_ret:
    ret
_debug_print_inline_suffix:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    adrp x0, :got:debug_xt
    ldr x0, [x0, :got_lo12:debug_xt]
    ldr x19, [x0]
    cbz x19, inl_done
    adrp x0, :got:debug_inline
    ldr x0, [x0, :got_lo12:debug_inline]
    ldr x20, [x0]
    adrp x1, :got:cfa_lit
    ldr x1, [x1, :got_lo12:cfa_lit]
    ldr x1, [x1]
    cmp x19, x1
    b.ne inl_branch
    mov x0, #32
    bl _putchar
    mov x0, x20
    cbz x0, inl_number
    tst x0, #7
    b.ne inl_number
    adrp x1, :got:user_dict_area
    ldr x1, [x1, :got_lo12:user_dict_area]
    cmp x0, x1
    b.lo inl_number
    adrp x1, :got:here_ptr
    ldr x1, [x1, :got_lo12:here_ptr]
    ldr x1, [x1]
    cmp x0, x1
    b.hs inl_number
    ldr x1, [x0, #-8]
    and x1, x1, #0xFFFF
    cbz x1, inl_number
    lsr x4, x1, #12
    cbnz x4, inl_number
    sub x2, x0, x1
    cbz x2, inl_number
    adrp x3, :got:user_dict_area
    ldr x3, [x3, :got_lo12:user_dict_area]
    cmp x2, x3
    b.lo inl_number
    ldrb w2, [x2]
    and w2, w2, #NFA_LEN_MASK
    cbz w2, inl_number
    cmp w2, #64
    b.hs inl_number
    bl _print_xt_name
    b inl_done
inl_number:
    mov x0, x20
    bl _print_signed
    b inl_done
inl_branch:
    adrp x1, :got:cfa_branch
    ldr x1, [x1, :got_lo12:cfa_branch]
    ldr x1, [x1]
    cmp x19, x1
    b.eq inl_cells
    adrp x1, :got:cfa_0branch
    ldr x1, [x1, :got_lo12:cfa_0branch]
    ldr x1, [x1]
    cmp x19, x1
    b.eq inl_cells
    adrp x1, :got:cfa_loop
    ldr x1, [x1, :got_lo12:cfa_loop]
    ldr x1, [x1]
    cmp x19, x1
    b.eq inl_cells
    adrp x1, :got:cfa_plusloop
    ldr x1, [x1, :got_lo12:cfa_plusloop]
    ldr x1, [x1]
    cmp x19, x1
    b.ne inl_done
inl_cells:
    mov x0, #32
    bl _putchar
    asr x20, x20, #3
    tbnz x20, #63, inl_neg
    mov x0, #'+'
    bl _putchar
    mov x0, x20
    bl _print_unsigned
    b inl_cells_word
inl_neg:
    mov x0, x20
    bl _print_signed
inl_cells_word:
    mov x0, #32
    bl _putchar
    mov x0, #'C'
    bl _putchar
    mov x0, #'E'
    bl _putchar
    mov x0, #'L'
    bl _putchar
    mov x0, #'L'
    bl _putchar
    mov x0, #'S'
    bl _putchar
inl_done:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_xt_intoable:
    cbz x0, into_no
    tst x0, #7
    b.ne into_no
    ldr x1, [x0]
    adrp x0, :got:DOCOL
    ldr x0, [x0, :got_lo12:DOCOL]
    cmp x1, x0
    b.eq into_yes
    adrp x0, :got:DODOES
    ldr x0, [x0, :got_lo12:DODOES]
    cmp x1, x0
    b.eq into_yes
    adrp x0, :got:XEXECUTE
    ldr x0, [x0, :got_lo12:XEXECUTE]
    cmp x1, x0
    b.eq into_yes
    adrp x0, :got:XCATCH
    ldr x0, [x0, :got_lo12:XCATCH]
    cmp x1, x0
    b.eq into_yes
into_no:
    mov x0, #0
    ret
into_yes:
    mov x0, #1
    ret
_print_xt_name:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    cbz x0, pxn_q
    adrp x1, :got:tw_continue_cfa
    ldr x1, [x1, :got_lo12:tw_continue_cfa]
    cmp x0, x1
    b.ne pxn_check
    adrp x0, :got:str_traverse
    ldr x0, [x0, :got_lo12:str_traverse]
    bl _emit_z
    b pxn_done
pxn_check:
    tst x0, #7
    b.ne pxn_q
    ldr x1, [x0, #-8]
    and x1, x1, #0xFFFF
    cbz x1, pxn_q
    lsr x4, x1, #12
    cbnz x4, pxn_q
    sub x19, x0, x1
    ldrb w20, [x19], #1
    and w20, w20, #NFA_LEN_MASK
    cbz w20, pxn_q
    cmp w20, #64
    b.hs pxn_q
    mov x1, #0
pxn_scan:
    cmp x1, x20
    b.hs pxn_print
    ldrb w0, [x19, x1]
    cmp w0, #32
    b.lo pxn_q
    cmp w0, #126
    b.hi pxn_q
    add x1, x1, #1
    b pxn_scan
pxn_print:
    mov x1, #0
pxn_out:
    cmp x1, x20
    b.hs pxn_done
    ldrb w0, [x19, x1]
    stp x1, x20, [sp, #-16]!
    bl _putchar
    ldp x1, x20, [sp], #16
    add x1, x1, #1
    b pxn_out
pxn_done:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
pxn_q:
    mov x0, #63
    bl _putchar
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_note_byte:
    adrp x1, :got:debug_armed
    ldr x1, [x1, :got_lo12:debug_armed]
    ldr x1, [x1]
    cbz x1, note_ret
    adrp x2, :got:debug_line_col
    ldr x2, [x2, :got_lo12:debug_line_col]
    adrp x3, :got:debug_midline
    ldr x3, [x3, :got_lo12:debug_midline]
    cmp w0, #10
    b.ne note_not_nl
    str xzr, [x2]
    str xzr, [x3]
    ret
note_not_nl:
    cmp w0, #8
    b.ne note_glyph
    ldr x1, [x2]
    cbz x1, note_bs_flag
    sub x1, x1, #1
    str x1, [x2]
note_bs_flag:
    ldr x1, [x2]
    cmp x1, #0
    b.eq note_bs_zero
    mov x1, #1
    b note_bs_store
note_bs_zero:
    mov x1, #0
note_bs_store:
    str x1, [x3]
    ret
note_glyph:
    and w1, w0, #0xC0
    cmp w1, #0x80
    b.eq note_ret
    ldr x1, [x2]
    add x1, x1, #1
    str x1, [x2]
    mov x1, #1
    str x1, [x3]
note_ret:
    ret
_debug_pad_to_stack_col:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    adrp x0, :got:debug_line_col
    ldr x0, [x0, :got_lo12:debug_line_col]
    ldr x19, [x0]
    cmp x19, #DEBUG_STACK_COL
    b.eq pad_done
    b.hi pad_one
    mov x0, #DEBUG_STACK_COL
    sub x19, x0, x19
pad_loop:
    cbz x19, pad_done
    sub x19, x19, #1
    mov x0, #32
    bl _putchar
    b pad_loop
pad_one:
    mov x0, #32
    bl _putchar
pad_done:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_cursor_on:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:debug_line_col
    ldr x0, [x0, :got_lo12:debug_line_col]
    ldr x1, [x0]
    adrp x0, :got:debug_stack_anchor
    ldr x0, [x0, :got_lo12:debug_stack_anchor]
    str x1, [x0]
    mov x0, #0xE2
    bl _putchar
    mov x0, #0x96
    bl _putchar
    mov x0, #0x88
    bl _putchar
    mov x1, #1
    adrp x0, :got:debug_cursor_on
    ldr x0, [x0, :got_lo12:debug_cursor_on]
    str x1, [x0]
    ldp x29, x30, [sp], #16
    ret
_debug_cursor_off:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:debug_cursor_on
    ldr x0, [x0, :got_lo12:debug_cursor_on]
    ldr x1, [x0]
    cbz x1, cursor_off_done
    str xzr, [x0]
    mov x0, #8
    bl _putchar
    adrp x0, :got:debug_stack_anchor
    ldr x0, [x0, :got_lo12:debug_stack_anchor]
    ldr x1, [x0]
    adrp x0, :got:debug_line_col
    ldr x0, [x0, :got_lo12:debug_line_col]
    str x1, [x0]
cursor_off_done:
    ldp x29, x30, [sp], #16
    ret
_debug_print_SR:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    adrp x0, :got:debug_field_len
    ldr x0, [x0, :got_lo12:debug_field_len]
    str xzr, [x0]
    mov x1, #1
    adrp x0, :got:debug_field_count
    ldr x0, [x0, :got_lo12:debug_field_count]
    str x1, [x0]
    mov x0, #83
    bl _putchar
    bl _debug_print_dots
    adrp x0, :got:debug_field_len
    ldr x0, [x0, :got_lo12:debug_field_len]
    ldr x19, [x0]
    cmp x19, #45
    b.hs sr_past
    mov x0, #45
    sub x19, x0, x19
sr_pad:
    cbz x19, sr_r
    sub x19, x19, #1
    mov x0, #32
    bl _putchar
    b sr_pad
sr_past:
    b.eq sr_r
    mov x0, #32
    bl _putchar
sr_r:
    mov x0, #82
    bl _putchar
    bl _debug_print_rstack
    adrp x0, :got:debug_field_count
    ldr x0, [x0, :got_lo12:debug_field_count]
    str xzr, [x0]
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_print_dots:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    adrp x19, :got:data_stack
    ldr x19, [x19, :got_lo12:data_stack]
    add x19, x19, #1, lsl #12
    cmp x22, x19
    b.hs dpd_empty
    sub x21, x19, x22
    lsr x21, x21, #3
    mov x0, #40
    bl _putchar
    mov x0, x21
    bl _print_unsigned
    mov x0, #41
    bl _putchar
    mov x0, #58
    bl _putchar
    mov x0, #32
    bl _putchar
    cmp x21, #6
    b.ls dpd_under
    mov x0, #'.'
    bl _putchar
    mov x0, #'.'
    bl _putchar
    mov x0, #'.'
    bl _putchar
    mov x0, #32
    bl _putchar
dpd_under:
    cmp x21, #1
    b.eq dpd_tos
    sub x19, x21, #1
    cmp x19, #5
    b.ls dpd_mem
    mov x19, #5
dpd_mem:
    cbz x19, dpd_tos
    sub x19, x19, #1
    lsl x0, x19, #3
    ldr x0, [x22, x0]
    bl _print_signed
    mov x0, #32
    bl _putchar
    b dpd_mem
dpd_tos:
    mov x0, x20
    bl _print_signed
    mov x0, #32
    bl _putchar
    b dpd_done
dpd_empty:
    mov x0, #40
    bl _putchar
    mov x0, #48
    bl _putchar
    mov x0, #41
    bl _putchar
    mov x0, #58
    bl _putchar
dpd_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_debug_print_rstack:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    sub sp, sp, #32
    adrp x19, :got:return_stack
    ldr x19, [x19, :got_lo12:return_stack]
    add x19, x19, #1, lsl #12
    adrp x0, :got:debug_floor
    ldr x0, [x0, :got_lo12:debug_floor]
    ldr x0, [x0]
    cbz x0, dpr_clip
    cmp x0, x19
    b.hi dpr_clip
    cmp x0, x23
    b.ls dpr_clip
    mov x19, x0
dpr_clip:
    cmp x23, x19
    b.hs dpr_empty
    sub x21, x19, x23
    lsr x21, x21, #3
    adrp x22, :got:throw_handler
    ldr x22, [x22, :got_lo12:throw_handler]
    ldr x22, [x22]
    mov x19, #0
    mov x20, #0
dpr_count:
    cmp x20, x21
    b.hs dpr_counted
    add x0, x23, x20, lsl #3
    cmp x0, x22
    b.ne dpr_one
    add x20, x20, #6
    b dpr_count
dpr_one:
    add x19, x19, #1
    add x20, x20, #1
    b dpr_count
dpr_counted:
    cbz x19, dpr_empty
    mov x0, #40
    bl _putchar
    mov x0, x19
    bl _print_unsigned
    mov x0, #41
    bl _putchar
    mov x0, #58
    bl _putchar
    mov x0, #32
    bl _putchar
    mov x20, #0
    mov x19, #0
dpr_show:
    cmp x20, x21
    b.hs dpr_done
    cmp x19, #4
    b.hs dpr_ellip
    add x0, x23, x20, lsl #3
    cmp x0, x22
    b.ne dpr_show_one
    add x20, x20, #6
    b dpr_show
dpr_show_one:
    ldr x0, [x23, x20, lsl #3]
    bl _print_unsigned
    mov x0, #32
    bl _putchar
    add x20, x20, #1
    add x19, x19, #1
    b dpr_show
dpr_ellip:
    mov x0, #'.'
    bl _putchar
    mov x0, #'.'
    bl _putchar
    mov x0, #'.'
    bl _putchar
    b dpr_done
dpr_empty:
    mov x0, #40
    bl _putchar
    mov x0, #48
    bl _putchar
    mov x0, #41
    bl _putchar
    mov x0, #58
    bl _putchar
dpr_done:
    add sp, sp, #32
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_view_register_path:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    mov x19, x0
    mov x20, x1
    cmp x20, #0
    b.le vrp_fail
    cmp x20, #255
    b.ls vrp_len_ok
    mov x20, #255
vrp_len_ok:
    adrp x21, :got:view_file_n
    ldr x21, [x21, :got_lo12:view_file_n]
    ldr x22, [x21]
    mov x3, #1
vrp_search:
    cmp x3, x22
    b.hi vrp_append
    sub x4, x3, #1
    mov x5, #VIEW_PATH_MAX
    mul x4, x4, x5
    adrp x5, :got:view_paths
    ldr x5, [x5, :got_lo12:view_paths]
    add x5, x5, x4
    ldrb w6, [x5]
    cmp x6, x20
    b.ne vrp_next
    mov x7, #0
vrp_cmp:
    cmp x7, x20
    b.hs vrp_found
    add x8, x5, #1
    ldrb w9, [x8, x7]
    ldrb w10, [x19, x7]
    cmp w9, w10
    b.ne vrp_next
    add x7, x7, #1
    b vrp_cmp
vrp_next:
    add x3, x3, #1
    b vrp_search
vrp_append:
    cmp x22, #VIEW_FILE_MAX
    b.hs vrp_fail
    add x22, x22, #1
    str x22, [x21]
    mov x3, x22
    sub x4, x3, #1
    mov x5, #VIEW_PATH_MAX
    mul x4, x4, x5
    adrp x5, :got:view_paths
    ldr x5, [x5, :got_lo12:view_paths]
    add x5, x5, x4
    strb w20, [x5]
    mov x7, #0
vrp_store:
    cmp x7, x20
    b.hs vrp_found
    ldrb w9, [x19, x7]
    add x8, x5, #1
    strb w9, [x8, x7]
    add x7, x7, #1
    b vrp_store
vrp_found:
    mov x0, x3
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
vrp_fail:
    mov x0, #0
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
_view_line_now:
    adrp x0, :got:view_src_id
    ldr x0, [x0, :got_lo12:view_src_id]
    ldr x0, [x0]
    cbz x0, _vln_none
    adrp x0, :got:source_id
    ldr x0, [x0, :got_lo12:source_id]
    ldr x0, [x0]
    cbz x0, _vln_none
    b _source_line_now
_vln_none:
    mov x0, #0
    ret
_source_line_now:
    adrp x1, :got:source_base
    ldr x1, [x1, :got_lo12:source_base]
    ldr x1, [x1]
    adrp x2, :got:to_in
    ldr x2, [x2, :got_lo12:to_in]
    ldr x2, [x2]
    adrp x4, :got:line_mode
    ldr x4, [x4, :got_lo12:line_mode]
    ldr x4, [x4]
    cbz x4, _source_line_at
    adrp x3, :got:line_origin
    ldr x3, [x3, :got_lo12:line_origin]
    ldr x3, [x3]
    add x4, x1, x2
    sub x2, x4, x3
    mov x1, x3
_source_line_at:
    mov x0, #1
    mov x3, #0
_sla_loop:
    cmp x3, x2
    b.hs _sla_done
    ldrb w4, [x1, x3]
    cmp w4, #10
    b.ne _sla_next
    add x0, x0, #1
_sla_next:
    add x3, x3, #1
    b _sla_loop
_sla_done:
    ret
_view_set_src_from_pending:
    stp x29, x30, [sp, #-16]!
    adrp x0, :got:include_name_len
    ldr x0, [x0, :got_lo12:include_name_len]
    ldr x1, [x0]
    cbz x1, _vset_clear
    adrp x0, :got:include_name_pending
    ldr x0, [x0, :got_lo12:include_name_pending]
    bl _view_register_path
    adrp x1, :got:view_src_id
    ldr x1, [x1, :got_lo12:view_src_id]
    str x0, [x1]
    ldp x29, x30, [sp], #16
    ret
_vset_clear:
    adrp x1, :got:view_src_id
    ldr x1, [x1, :got_lo12:view_src_id]
    str xzr, [x1]
    ldp x29, x30, [sp], #16
    ret
_view_push_src_id:
    adrp x0, :got:view_src_id
    ldr x0, [x0, :got_lo12:view_src_id]
    ldr x1, [x0]
    adrp x2, :got:view_id_sp
    ldr x2, [x2, :got_lo12:view_id_sp]
    ldr x3, [x2]
    cmp x3, #8
    b.hs _vpush_full
    adrp x4, :got:view_id_stack
    ldr x4, [x4, :got_lo12:view_id_stack]
    str x1, [x4, x3, lsl #3]
    add x3, x3, #1
    str x3, [x2]
_vpush_full:
    ret
_view_pop_src_id:
    adrp x2, :got:view_id_sp
    ldr x2, [x2, :got_lo12:view_id_sp]
    ldr x3, [x2]
    cbz x3, _vpop_empty
    sub x3, x3, #1
    str x3, [x2]
    adrp x4, :got:view_id_stack
    ldr x4, [x4, :got_lo12:view_id_stack]
    ldr x1, [x4, x3, lsl #3]
    adrp x0, :got:view_src_id
    ldr x0, [x0, :got_lo12:view_src_id]
    str x1, [x0]
    ret
_vpop_empty:
    adrp x0, :got:view_src_id
    ldr x0, [x0, :got_lo12:view_src_id]
    str xzr, [x0]
    ret
_getchar:
    stp x29, x30, [sp, #-16]!
    adrp x1, :got:key_fn
    ldr x1, [x1, :got_lo12:key_fn]
    ldr x1, [x1]
    cbz x1, getchar_none
    blr x1
    b getchar_out
getchar_none:
    mov x0, #-1
getchar_out:
    ldp x29, x30, [sp], #16
    ret
    .section .rodata,"a",@progbits
    .p2align 3
str_dbg_keys:
    .ascii "[Space/o/Return=over i=into u=out Esc/q=abort g=go h=help]"
    .byte 0
str_dbg_abort:
    .ascii "DEBUG aborted"
    .byte 10
    .byte 0
str_dbg_done:
    .ascii "DEBUG done"
    .byte 10
    .byte 0
str_traverse:
    .ascii "(TRAVERSE)"
    .byte 0
    .data
    .p2align 3
debug_armed:
    .quad 0
tdebug_armed:
    .quad 0
debug_midline:
    .quad 0
debug_field_count:
    .quad 0
debug_field_len:
    .quad 0
debug_help_shown:
    .quad 0
debug_cursor_on:
    .quad 0
debug_need_stacks:
    .quad 0
debug_need_intro:
    .quad 0
debug_line_col:
    .quad 0
debug_stack_anchor:
    .quad 0
debug_busy:
    .quad 0
debug_floor:
    .quad 0
debug_bp_go:
    .quad 0
debug_runto_ip:
    .quad 0
debug_runto_off:
    .quad 0
debug_runto_status:
    .quad 0
debug_break_asap:
    .quad 0
debug_break_min_cfa:
    .quad 0
debug_bp_xts:
    .space 64
debug_bp_en:
    .space 64
debug_over:
    .quad 0
debug_out:
    .quad 0
debug_abort:
    .quad 0
debug_show_xt:
    .quad 0
debug_sync_ok:
    .quad 0
debug_hl_xt:
    .quad 0
debug_wheel_xt:
    .quad 0
debug_pause_xt:
    .quad 0
debug_pause_rsp:
    .quad 0
debug_key_xt:
    .quad 0
debug_key_raw:
    .quad 0
debug_key_mode:
    .quad 0
debug_call_tos:
    .quad 0
debug_view_cfa:
    .quad 0
debug_view_name:
    .space 32
debug_call_depth:
    .quad 0
    .p2align 3
debug_vmsave_stack:
    .space 288
debug_ret_cfa:
    .quad XDBG_CALL_DONE
debug_ret_ipcell:
    .quad debug_ret_cfa
debug_skip_nl:
    .quad 0
debug_xt:
    .quad 0
debug_inline:
    .quad 0
debug_ip:
    .quad 0
debug_cfa:
    .quad 0
debug_body_cells:
    .quad 0
debug_scnt:
    .quad 0
debug_sbuf:
    .space 128
debug_rcnt:
    .quad 0
debug_rbuf:
    .space 128
debug_name:
    .space 32
debug_rlab:
    .space 512
debug_dsave_tos:
    .quad 0
debug_dsave_dsp:
    .quad 0
debug_dsave_n:
    .quad 0
debug_dsave_buf:
    .space 512
    .p2align 3
debug_nest_rstack:
    .space 16384
view_src_id:
    .quad 0
view_file_n:
    .quad 0
view_paths:
    .space 65536
view_id_sp:
    .quad 0
view_id_stack:
    .space 64
include_name_len:
    .quad 0
include_name_pending:
    .space 256

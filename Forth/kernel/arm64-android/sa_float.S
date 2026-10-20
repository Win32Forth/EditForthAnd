/* Generated from Forth/kernel/arm64/sa_float.asm. Do not edit. */
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .text
    .p2align 2
    .extern float_op_hook
    .global _float_op_call
    .global sa_float_bss_depth
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_SA_FLOAT:
    .ascii "(SA-FLOAT)"
    .byte 0
hl_SA_FLOAT:
    .ascii "(SA-FLOAT) ( -- ) stand-alone float runtime block"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_SA_FLOAT:
    .quad nm_SA_FLOAT, hl_SA_FLOAT
    .word 0, 1073741824
    .quad SA_FLOAT, SA_FLOAT_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_SA_FLOAT
    .text
    .p2align 2
SA_FLOAT:
_float_op_call:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adrp x9, sa_float_hook_ptr
    add x9, x9, :lo12:sa_float_hook_ptr
    ldr x9, [x9]
    cbnz x9, _sff_deref
    adrp x9, :got:float_op_hook
    ldr x9, [x9, :got_lo12:float_op_hook]
_sff_deref:
    ldr x9, [x9]
    cbz x9, _sa_float_local
    sub sp, sp, #64
    add x6, sp, #16
    add x7, sp, #24
    add x8, sp, #32
    str xzr, [x6]
    str xzr, [x7]
    str xzr, [x8]
    str x8, [sp]
    blr x9
    ldr x6, [sp, #16]
    ldr x7, [sp, #24]
    ldr x8, [sp, #32]
    add sp, sp, #64
    ldp x29, x30, [sp], #16
    ret
_sa_fdepth_addr:
    adrp x10, sa_float_state_ptr
    add x10, x10, :lo12:sa_float_state_ptr
    ldr x10, [x10]
    cbnz x10, _sfd_ok
    adrp x10, :got:sa_float_bss_depth
    ldr x10, [x10, :got_lo12:sa_float_bss_depth]
_sfd_ok:
    ret
_sa_fpush:
    stp x29, x30, [sp, #-16]!
    bl _sa_fdepth_addr
    ldr x11, [x10]
    cmp x11, #16
    b.hs _sfp_full
    add x12, x10, #16
    str d0, [x12, x11, lsl #3]
    add x11, x11, #1
    str x11, [x10]
_sfp_full:
    ldp x29, x30, [sp], #16
    ret
_sa_fpop:
    stp x29, x30, [sp, #-16]!
    bl _sa_fdepth_addr
    ldr x11, [x10]
    cbz x11, _sfpop_empty
    sub x11, x11, #1
    str x11, [x10]
    add x12, x10, #16
    ldr d0, [x12, x11, lsl #3]
    ldp x29, x30, [sp], #16
    ret
_sfpop_empty:
    fmov d0, xzr
    ldp x29, x30, [sp], #16
    ret
_sa_float_local:
    mov x6, #0
    mov x7, #0
    mov x8, #0
    cmp x0, #1
    b.eq _saf_fdepth
    cmp x0, #2
    b.eq _saf_fdrop
    cmp x0, #3
    b.eq _saf_fdup
    cmp x0, #4
    b.eq _saf_fswap
    cmp x0, #5
    b.eq _saf_fover
    cmp x0, #6
    b.eq _saf_frot
    cmp x0, #7
    b.eq _saf_fplus
    cmp x0, #8
    b.eq _saf_fminus
    cmp x0, #9
    b.eq _saf_fstar
    cmp x0, #10
    b.eq _saf_fslash
    cmp x0, #11
    b.eq _saf_fnegate
    cmp x0, #12
    b.eq _saf_fabs
    cmp x0, #13
    b.eq _saf_fmax
    cmp x0, #14
    b.eq _saf_fmin
    cmp x0, #15
    b.eq _saf_f0eq
    cmp x0, #16
    b.eq _saf_f0lt
    cmp x0, #17
    b.eq _saf_flt
    cmp x0, #18
    b.eq _saf_fgt
    cmp x0, #19
    b.eq _saf_feq
    cmp x0, #20
    b.eq _saf_fne
    cmp x0, #21
    b.eq _saf_ftilde
    cmp x0, #22
    b.eq _saf_fat
    cmp x0, #23
    b.eq _saf_fstore
    cmp x0, #24
    b.eq _saf_sfat
    cmp x0, #25
    b.eq _saf_sfstore
    cmp x0, #26
    b.eq _saf_fat
    cmp x0, #27
    b.eq _saf_fstore
    cmp x0, #28
    b.eq _saf_stf
    cmp x0, #29
    b.eq _saf_fts
    cmp x0, #30
    b.eq _saf_dtf
    cmp x0, #31
    b.eq _saf_ftd
    cmp x0, #36
    b.eq _saf_precision
    cmp x0, #37
    b.eq _saf_setprecision
    cmp x0, #39
    b.eq _saf_floats
    cmp x0, #40
    b.eq _saf_floatplus
    cmp x0, #41
    b.eq _saf_sfloats
    cmp x0, #42
    b.eq _saf_sfloatplus
    cmp x0, #43
    b.eq _saf_floats
    cmp x0, #44
    b.eq _saf_floatplus
    cmp x0, #45
    b.eq _saf_fsqrt
    cmp x0, #70
    b.eq _saf_falign
    cmp x0, #71
    b.eq _saf_sfalign
    cmp x0, #72
    b.eq _saf_falign
    cmp x0, #73
    b.eq _saf_faligned
    cmp x0, #74
    b.eq _saf_sfaligned
    cmp x0, #75
    b.eq _saf_faligned
    cmp x0, #101
    b.eq _saf_fpushbits
    cmp x0, #102
    b.eq _saf_fpopbits
    cmp x0, #103
    b.eq _saf_fdepth
    mov x0, #-1
    ldp x29, x30, [sp], #16
    ret
_saf_ok:
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
_saf_fdepth:
    bl _sa_fdepth_addr
    ldr x6, [x10]
    b _saf_ok
_saf_fdrop:
    bl _sa_fpop
    b _saf_ok
_saf_fdup:
    bl _sa_fpop
    bl _sa_fpush
    bl _sa_fpush
    b _saf_ok
_saf_fswap:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fmov d2, d0
    fmov d0, d1
    bl _sa_fpush
    fmov d0, d2
    bl _sa_fpush
    b _saf_ok
_saf_fover:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fmov d2, d0
    bl _sa_fpush
    fmov d0, d1
    bl _sa_fpush
    fmov d0, d2
    bl _sa_fpush
    b _saf_ok
_saf_frot:
    bl _sa_fpop
    fmov d3, d0
    bl _sa_fpop
    fmov d2, d0
    bl _sa_fpop
    fmov d1, d0
    fmov d0, d2
    bl _sa_fpush
    fmov d0, d3
    bl _sa_fpush
    fmov d0, d1
    bl _sa_fpush
    b _saf_ok
_saf_fplus:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fadd d0, d0, d1
    bl _sa_fpush
    b _saf_ok
_saf_fminus:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fsub d0, d0, d1
    bl _sa_fpush
    b _saf_ok
_saf_fstar:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fmul d0, d0, d1
    bl _sa_fpush
    b _saf_ok
_saf_fslash:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fdiv d0, d0, d1
    bl _sa_fpush
    b _saf_ok
_saf_fnegate:
    bl _sa_fpop
    fneg d0, d0
    bl _sa_fpush
    b _saf_ok
_saf_fabs:
    bl _sa_fpop
    fabs d0, d0
    bl _sa_fpush
    b _saf_ok
_saf_fmax:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fmax d0, d0, d1
    bl _sa_fpush
    b _saf_ok
_saf_fmin:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fmin d0, d0, d1
    bl _sa_fpush
    b _saf_ok
_saf_f0eq:
    bl _sa_fpop
    fcmp d0, #0.0
    csetm x6, eq
    b _saf_ok
_saf_f0lt:
    bl _sa_fpop
    fcmp d0, #0.0
    csetm x6, mi
    b _saf_ok
_saf_flt:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fcmp d0, d1
    csetm x6, mi
    b _saf_ok
_saf_fgt:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fcmp d0, d1
    csetm x6, gt
    b _saf_ok
_saf_feq:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fcmp d0, d1
    csetm x6, eq
    b _saf_ok
_saf_fne:
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fcmp d0, d1
    csetm x6, ne
    b _saf_ok
_saf_ftilde:
    bl _sa_fpop
    fabs d2, d0
    bl _sa_fpop
    fmov d1, d0
    bl _sa_fpop
    fsub d0, d0, d1
    fabs d0, d0
    fcmp d0, d2
    csetm x6, mi
    b _saf_ok
_saf_fat:
    cbz x1, _saf_ok
    ldr d0, [x1]
    bl _sa_fpush
    b _saf_ok
_saf_fstore:
    bl _sa_fpop
    cbz x1, _saf_ok
    str d0, [x1]
    b _saf_ok
_saf_sfat:
    cbz x1, _saf_ok
    ldr s0, [x1]
    fcvt d0, s0
    bl _sa_fpush
    b _saf_ok
_saf_sfstore:
    bl _sa_fpop
    cbz x1, _saf_ok
    fcvt s0, d0
    str s0, [x1]
    b _saf_ok
_saf_stf:
    scvtf d0, x1
    bl _sa_fpush
    b _saf_ok
_saf_fts:
    bl _sa_fpop
    fcvtzs x6, d0
    b _saf_ok
_saf_dtf:
    cmp x2, #0
    b.eq _saf_dtf_lo
    cmn x2, #1
    b.eq _saf_dtf_lo
    scvtf d0, x2
    movz x10, #0
    movk x10, #0x43F0, lsl #48
    fmov d1, x10
    fmul d0, d0, d1
    mov x11, x1
    ucvtf d1, x11
    fadd d0, d0, d1
    bl _sa_fpush
    b _saf_ok
_saf_dtf_lo:
    scvtf d0, x1
    bl _sa_fpush
    b _saf_ok
_saf_ftd:
    bl _sa_fpop
    fcvtzs x6, d0
    fcmp d0, #0.0
    csetm x7, mi
    b _saf_ok
_saf_precision:
    bl _sa_fdepth_addr
    ldr x6, [x10, #8]
    b _saf_ok
_saf_setprecision:
    bl _sa_fdepth_addr
    str x1, [x10, #8]
    b _saf_ok
_saf_floats:
    lsl x6, x1, #3
    b _saf_ok
_saf_floatplus:
    add x6, x1, #8
    b _saf_ok
_saf_sfloats:
    lsl x6, x1, #2
    b _saf_ok
_saf_sfloatplus:
    add x6, x1, #4
    b _saf_ok
_saf_fsqrt:
    bl _sa_fpop
    fsqrt d0, d0
    bl _sa_fpush
    b _saf_ok
_saf_falign:
    add x6, x1, #7
    bic x6, x6, #7
    b _saf_ok
_saf_sfalign:
    add x6, x1, #3
    bic x6, x6, #3
    b _saf_ok
_saf_faligned:
    tst x1, #7
    csetm x6, eq
    b _saf_ok
_saf_sfaligned:
    tst x1, #3
    csetm x6, eq
    b _saf_ok
_saf_fpushbits:
    fmov d0, x1
    bl _sa_fpush
    b _saf_ok
_saf_fpopbits:
    bl _sa_fpop
    fmov x6, d0
    b _saf_ok
    .p2align 3
sa_float_hook_ptr:
    .quad 0
sa_float_zero_cell:
    .quad 0
sa_float_state_ptr:
    .quad 0
sa_float_pool_pad:
    .quad 0
SA_FLOAT_END:
    .data
    .p2align 3
sa_float_bss_depth:
    .quad 0
sa_float_bss_precision:
    .quad 6
sa_float_bss_stack:
    .space 128

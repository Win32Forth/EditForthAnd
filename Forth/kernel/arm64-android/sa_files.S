/* Generated from Forth/kernel/arm64/sa_files.asm. Do not edit. */
    .equ FLAG_EMM, 1073741824
    .equ FLAG_IMM, 2147483648
    .equ FLAG_INLINE, 536870912
    .text
    .p2align 2
    .extern file_op_hook
    .extern sa_win_file_op
    .global _file_op_call
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_SA_FILES:
    .ascii "(SA-FILES)"
    .byte 0
hl_SA_FILES:
    .ascii "(SA-FILES) ( -- ) stand-alone file runtime block"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_SA_FILES:
    .quad nm_SA_FILES, hl_SA_FILES
    .word 0, 1073741824
    .quad SA_FILES, SA_FILES_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_SA_FILES
    .text
    .p2align 2
    .section .bwstr,"aw",@progbits
    .p2align 0
nm_XFILE_OP_CALL:
    .ascii "(FILE-OP-CALL)"
    .byte 0
hl_XFILE_OP_CALL:
    .ascii "(FILE-OP-CALL) ( -- ) file op multiplex"
    .byte 0
    .section .bootword,"aw",@progbits
    .p2align 3
    .p2align 3
row_XFILE_OP_CALL:
    .quad nm_XFILE_OP_CALL, hl_XFILE_OP_CALL
    .word 0, 1073741824
    .quad XFILE_OP_CALL, XFILE_OP_CALL_END
    .section .bootptr,"aw",@progbits
    .p2align 3
    .p2align 3
    .quad row_XFILE_OP_CALL
    .text
    .p2align 2
SA_FILES:
XFILE_OP_CALL:
_file_op_call:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adrp x9, sa_files_hook_ptr
    add x9, x9, :lo12:sa_files_hook_ptr
    ldr x9, [x9]
    cbnz x9, _sfc_have
    adrp x9, :got:file_op_hook
    ldr x9, [x9, :got_lo12:file_op_hook]
_sfc_have:
    ldr x9, [x9]
    cbz x9, _sfc_win
    b _sfc_call
_sfc_win:
    adrp x9, sa_win_file_op_ptr
    add x9, x9, :lo12:sa_win_file_op_ptr
    ldr x9, [x9]
    cbz x9, _sfc_none
_sfc_call:
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
_sfc_none:
    mov x0, #-1
    mov x6, #0
    mov x7, #0
    mov x8, #0
    ldp x29, x30, [sp], #16
    ret
    .data
    .p2align 3
XFILE_OP_CALL_END:
    .p2align 3
sa_win_file_op_ptr:
    .quad sa_win_file_op
sa_files_hook_ptr:
    .quad 0
sa_files_zero_cell:
    .quad 0
sa_files_pool_pad0:
    .quad 0
sa_files_pool_pad1:
    .quad 0
SA_FILES_END:

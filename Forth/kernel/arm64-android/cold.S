/* Generated from Forth/kernel/arm64/cold.asm. Do not edit. */
    .section .rodata,"a",@progbits
    .p2align 3
    .global forth_init_str
    .global forth_init_end
forth_init_str:
    .incbin "kernel1.fth"
    .incbin "kernel2.fth"
    .incbin "vocemit.fth"
    .incbin "app-output.fth"
    .incbin "app-points.fth"
    .incbin "vocsys.fth"
    .incbin "xref.fth"
    .incbin "boot-fix.fth"
    .byte 0
forth_init_end:

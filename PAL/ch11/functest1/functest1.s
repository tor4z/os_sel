    .section .data
precision:
    .byte 0x7f, 0x00

    .section .bss
    .lcomm value, 4

    .section .text
    .globl _start
_start:
    nop
    finit
    fldcw precision

    movl $10, %ebx
    call area


.type area, @function
area:
    fldpi
    imull %ebx, %ebx
    movl %ebx, value
    fild value
    fmulp %st(0), %st(1)
    ret

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

    movl $1, %eax
    movl $0, %ebx
    int $0x80

.type area, @function
area:
    fldpi                   # push pi into FPU stack
    imull %ebx, %ebx
    movl %ebx, value
    fild value
    fmulp %st(0), %st(1)
    ret

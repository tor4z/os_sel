# detect overflow
    .section .text
    .globl _start
_start:
    nop
    xorw %dx, %dx
    movw $680, %ax
    movw $100, %cx
    imulw %cx           # target is stored in dx:ax registers
    jo over             # check is overflow
    movl $1, %eax
    movl $0, %ebx
    int $0x80
over:
    movl $1, %eax
    movl $1, %ebx
    int $0x80

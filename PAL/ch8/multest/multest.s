    .section .data
data1:
    .int 315814
data2:
    .int 165432
result:
    .quad 0
output:
    .asciz "The result is %qd\n"

    .section .text
    .globl _start
_start:
    nop
    movl data1, %eax        # destination operand
    mull data2              # source operand
    movl %eax, result       # lower 4 bytes result
    movl %edx, result+4     # higher 4 bytes result
    # the mul result is stored at EDX:EAX
    pushl %edx
    pushl %eax
    pushl $output
    call printf
    addl $12, %esp

    pushl $0
    call exit

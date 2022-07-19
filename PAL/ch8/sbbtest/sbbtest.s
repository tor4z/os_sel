# 5732348928 - 7252051615
    .section .data
data1:
    # in memory
    # 0xb041869f	0x00000001
    .quad 7252051615
data2:
    # in memory
    # 0x55acb400	0x00000001
    .quad 5732348928
output:
    .asciz "The result is %qd\n"

    .section .text
    .globl _start
_start:
    nop
    movl data1, %ebx
    movl data1+4, %eax
    movl data2, %edx
    movl data2+4, %ecx
    subl %ebx, %edx         # lower 4 bytes
    sbbl %eax, %ecx         # upper 4 bytes with carry
    pushl %ecx              # upper 4 bytes push into the stack first
    pushl %edx              # lower 4 bytes push into the stack later
    pushl $output
    call printf
    addl $12, %esp

    pushl $0
    call exit

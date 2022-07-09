    .section .data
data:
    .int -45

    .section .text
    .globl _start
_start:
    nop
    movl $-345, %ecx    # Set the content of ecx to -345
    movw $0xffb1, %dx   # Set the content of dx to 0xffb1
    movl data, %ebx     # Set the content of ebx to data, which is -45

    movl $1, %eax       # exit
    int $0x80           # linux syscall

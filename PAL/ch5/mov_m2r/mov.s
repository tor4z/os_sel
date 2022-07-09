    .section .data
value:
    .int 1

    .section .text
    .globl _start
_start:
    nop                     # do nothing
    movl value, %ecx        # mov the value in 'value' to ecx
    movl $1, %eax           # exit
    movl $0, %ebx           # exit code
    int $0x80               # linux syscall

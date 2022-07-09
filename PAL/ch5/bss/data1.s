    .section .data
buffer:
    .fill 1000

    .section .text
    .globl _start
_start:
    movl $1, %eax       # exit
    movl $0, %ebx       # exit code
    int $0x80           # linux syscall

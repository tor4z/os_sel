    .section .data
value:
    .int 1

    .section .text
    .globl _start
_start:
    nop
    movl $100, %eax     # move 100 to eax
    movl %eax, value    # move the content in eax to 'value' address

    movl $1, %eax       # exit
    movl $0, %ebx       # exit code
    int $0x80           # linux syscall

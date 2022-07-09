    .section .text
    .globl _start
_start:
    nop
    mov $79, %cx        # Set the content of register cx to 79
    xorl %ebx, %ebx     # Set the content of ebx to 0
    movw %cx, %bx       # normal move
    # use movsx when cx is containing a positive number
    # movsx set correctly filled the eax register
    movsx %cx, %eax     # movsx

    movl $1, %eax       # exit
    movl $0, %ebx       # exit code
    int $0x80           # linux syscall

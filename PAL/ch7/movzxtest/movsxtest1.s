    .section .text
    .globl _start
_start:
    nop
    # -79 = 0xFFFFFFFFFFFFFFB1
    mov $-79, %cx       # Set the content of register cx to -79
    movl $0, %ebx       # Set the content of ebx to 0
    # cx = 0xffb1
    # bx = 0xffb1
    mov %cx, %bx        # normal mvove
    # eax = 0xffffffb1
    movsx %cx, %eax     # move with movsx

    movl $1, %eax       # exit
    movl $0, %ebx       # exit code
    int $0x80           # linux syscall

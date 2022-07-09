    .section .text
    .globl _start
_start:
    nop
    movl $0x12345678, %ebx  # Set the content of ebx to $0x12345678
    bswap %ebx              # performing bytes swap
    # ebx = 0x78563412
    movl $1, %eax           # exit
    int $0x80               # linux syscall

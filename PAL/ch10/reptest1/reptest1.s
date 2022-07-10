    .section .data
value1:
    .ascii "this is a test string.\n"

    .section .bss
    .lcomm output, 23

    .section .text
    .globl _start
_start:
    nop
    leal value1, %esi   # set source address
    leal output, %edi   # set target address
    movl $23, %ecx      # set the repeat times
    cld                 # use forward copy mode
    rep movsb           # repeatly copy the string byte by byte.

    movl $1, %eax
    movl $0, %ebx
    int $0x80

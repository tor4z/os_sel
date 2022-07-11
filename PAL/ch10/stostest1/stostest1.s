    .section .data
space:
    .ascii " "

    .section .bss
    .lcomm buffer, 256

    .section .text
    .globl _start
_start:
    nop
    leal space, %esi    # set source address
    leal buffer, %edi   # set target address
    movl $256, %ecx     # set repeat times

    cld                 # forward mode
    lodsb               # Load a byte of data from the AL register
    rep stosb           # Stores "ecx" byte of data from the AL register

    movl $1, %eax
    movl $0, %ebx
    int $0x80

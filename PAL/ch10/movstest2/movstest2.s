    .section .data
value1:
    .ascii "This is a test string.\n"

    .section .bss
    .lcomm output, 23

    .section .text
    .globl _start
_start:
    nop
    leal value1 + 22, %esi
    leal output + 22, %edi

    # Set DF flag, which making esi and edi regosters are
    # decremented while executing movs instructions
    std
    # Even though the ESI and EDI registers are counting
    # backward, the MOVW and MOVL instructions are getting
    # the memory locations in forward order. 
    movsb                   # move a byte
    movsw                   # move two bytes
    movsl                   # move four bytes

    movl $1, %eax
    movl $0, %ebx
    int $0x80

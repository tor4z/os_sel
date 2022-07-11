    .section .data
string1:
    .asciz "Test"
string2:
    .asciz "Test"

    .section .text
    .globl _start
_start:
    nop
    movl $1, %eax           # exit
    # leal string1, %esi
    # leal string2, %edi
    movl $string1, %esi
    movl $string2, %edi
    cld
    cmpsl                   # compare 4 byte of data
    je equal                # if ZF is setted
    movl $1, %ebx           # jump to equal
    int $0x80
equal:
    movl $0, %ebx
    int $0x80

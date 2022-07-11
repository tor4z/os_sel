    .section .data
string1:
    .asciz "This is a test of the CMPS instructions"
string2:
    .asciz "This is a test of the CMPS Instructions"

    .section .text
    .globl _start
_start:
    nop
    movl $1, %eax       # exit
    leal string1, %esi
    leal string2, %edi
    movl $39, %ecx

    cld                 # forward mode
    repz cmpsb          # repeat if ZF flag is setted
    jz equal            # jump to equal if ZF flag is setted

    movl $1, %ebx
    int $0x80
equal:
    movl $0, %ebx
    int $0x80

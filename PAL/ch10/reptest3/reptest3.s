    .section .data
string1:
    .asciz "This is a test of the convertion program!\n"
length:
    .int 43
divisor:
    .int 4

    .section .bss
    .lcomm buffer, 43

    .section .text
    .globl _start
_start:
    nop
    leal string1, %esi  # source string address
    leal buffer, %edi   # target string address
    movl length, %ecx   # string length
    shrl $2, %ecx       # ecx / 2^2, which is ecx / 4

    cld                 # forward mode
    rep movsl           # copy string by block
    movl length, %ecx   # set string length
    andl $3, %ecx       # compute the modulo of ecx / 4
    rep movsb           # copy the rest chars by byte
    
    movl $1, %eax
    movl $0, %ebx
    int $0x80

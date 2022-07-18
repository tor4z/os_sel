.include "inc.S"


    .section .text
    .global _start
_start:
    movl $A, %ebx
    movl $1, %eax
    int $0x80

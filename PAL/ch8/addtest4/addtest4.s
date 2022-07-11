    .section .data
output:
    .asciz "The result is %d\n"

    .section .text
    .globl _start
_start:
    nop
    movl $-1590876934, %ebx
    movl $-1259230143, %eax
    addl %eax, %ebx             # check ovferflow flag
    jo over                     # detect overflow flag
    pushl %ebx
    pushl $output
    call printf
    addl $8, %esp
    jmp _exit
over:
    pushl $0
    pushl $output
    call printf
    addl $8, %esp
_exit:
    pushl $0
    call exit

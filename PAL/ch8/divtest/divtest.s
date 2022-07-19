    .section .data
dividend:
    .quad 8335
divisor:
    .int 25
quotient:
    .int 0
remainder:
    .int 0
output:
    .asciz "The quotient is %d, the remainder is %d\n"

    .section .text
    .globl _start
_start:
    nop
    movl dividend, %eax     # lower 4 bytes
    movl dividend+4, %edx   # higher 4 bytes
    divl divisor            # divide
    movl %eax, quotient     # the quotient
    movl %edx, remainder    # the remainder

    pushl remainder         # the third parameter
    pushl quotient          # the second parameter
    pushl $output           # fmt
    call printf             # call printf

    add $12, %esp           # restore stack
    pushl $0                # exit code
    call exit               # call exit

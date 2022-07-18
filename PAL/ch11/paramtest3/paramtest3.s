    .section .data
output:
    .asciz "The area is: %f\n"

    .section .bss
    .lcomm result, 4

    .section .text
    .globl _start
_start:
    nop
    finit

    pushl 8(%esp)           # push cli parameter into stack
    call atoi               # convert cli parameter to integer
    addl $4, %esp           # restore stack
    movl %eax, result       # move convert result to (result)
    fldpi                   # push pi into FPU stack
    filds result             # push result into FPU stack
    fmul %st(0), %st(0)     # result^2
    fmul %st(1), %st(0)     # pi * result^2
    fstpl (%esp)            # store st(0) into (esp)
    pushl $output           # push fmt
    call printf             # call printf
    addl $12, %esp

    pushl $0                # exit code
    call exit               # exit

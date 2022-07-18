    .section .data
output1:
    .asciz "There are %d parameters: \n"
output2:
    .asciz "%s\n"

    .section .text
    .globl _start
_start:
    movl (%esp), %ecx   # The number of parameters
    pushl %ecx          # push the number of parameter as the second parameter of printf
    pushl $output1      # push output1 as the first parameter of printf
    call printf         # call printf
    addl $4, %esp       # restore stack pointer, the pointer point to num-parameter now
    popl %ecx           # store the number of parameters and store in ecx register
    movl %esp, %ebp     # set bottom of stack
    addl $4, %ebp       # ebp point to first cli parameter now
loop1:
    pushl %ecx          # store ecx, the cli parameter number
    pushl (%ebp)        # ebp pointer to the clin parameter, and retrieve the value
    pushl $output2      # fmt string
    call printf         # call printf
    addl $8, %esp       # restore stack pointer
    popl %ecx           # retrieve ecx
    addl $4, %ebp       # make ebp point to next cli parameter
    loop loop1          # loop

    pushl $0            # exit code
    call exit           # exit

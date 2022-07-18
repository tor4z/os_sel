    .section .data
output:
    .asciz "%s\n"

    .section .text
    .globl _start
_start:
    movl %esp, %ebp
    addl $12, %ebp      # skip the number of parameterm, the first parameter and null string of parameter section
loop1:
    cmpl $0, (%ebp)     # the end of env variable section is define as a NULL string
    je endit            # end
    pushl (%ebp)        # the second parameter, env
    pushl $output       # the fitst parameter, fmt
    call printf         # call printf
    addl $8, %esp       # restore stack
    addl $4, %ebp       # point to next parameter
    loop loop1          # loop
endit:
    pushl $0            # exit code
    call exit           # exit

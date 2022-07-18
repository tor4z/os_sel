    .section .data
precision:
    .byte 0x7f, 0x00

    .section .bss
    .lcomm result, 4

    .section .text
    .globl _start
_start:
    nop
    finit
    fldcw precision

    pushl $10
    call area
    addl $4, %esp
    movl %eax, result

    pushl $2
    call area
    addl $4, %esp
    movl %eax, result

    pushl $120                  # push the first parameter into the stack
    call area                   # call the function
    addl $4, %esp               # restore the esp, the stack top pointer
    movl %eax, result           # the result is stored in eax register, we move it into memory located in result

    movl $1, %eax
    movl $0, %ebx
    int $0x80

    .type area, @function
area:
    pushl %ebp                  # Save old ebp
    movl %esp, %ebp             # set esp of the current stack bottom
    subl $4, %esp               # reserve stack space for local value
    
    fldpi                       # push pi into the FPU stack
    fild 8(%ebp)                # the first parameter (radius) is stored in (ebp + 8)
    fmul %st(0), %st(0)         # square the radius
    fmulp %st(0), %st(1)        # pi * radius^2
    fstps -4(%ebp)              # store the area result into local variable
    movl -4(%ebp), %eax         # move the area result into eax register, the return value

    movl %ebp, %esp             # restore the esp register
    popl %ebp                   # restore the ebp register
    ret                         # return

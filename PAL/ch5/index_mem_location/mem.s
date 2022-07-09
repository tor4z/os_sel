    .section .data
output:
    .asciz "The value is %d.\n"
values:
    .int 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60

    .section .text
    .globl _start
_start:
    nop
    movl $0, %edi
loop:
    # base_address(offset_address, index, size)
    # base_address + offset_address + index * size
    movl values(, %edi, 4), %eax    # move value in the address into eax
    pushl %eax                      # the second parameter
    pushl $output                   # the first parameter
    call printf                     # call C function

    addl $8, %esp                   # add stack pointer to discard useless parameters
    inc %edi                        # edi++
    cmpl $11, %edi                  # if edi not equal to 11
    jne loop                        # then jump to loop

    movl $1, %eax                   # exit 
    movl $0, %ebx                   # exit code
    int $0x80                       # linux syscall

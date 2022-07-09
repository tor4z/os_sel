    .section .data
values:
    .int 105, 235, 61, 315, 134, 221, 53, 145, 117, 5
output:
    .asciz "The value is %d.\n"

    .section .text
    .globl _start
_start:
    nop
    movl values, %ebx               # Move the first value of values into ebx
    movl $1, %edi                   # Set index to 1
loop:
    movl values(, %edi, 4), %eax    # Move the value of values with index edi into eax
    cmp %ebx, %eax                  # The CMP instruction subtracts the first operand
                                    # from the second and sets the EFLAGS registers
                                    # appropriately
    cmova %eax, %ebx                # Perform move if CF or ZF are setted
    inc %edi                        # index++
    cmp $10, %edi                   # 10 value totally
    jne loop                        # jump to loop

    pushl %ebx                      # The second parameter of printf function
    pushl $output                   # The first parameter of printf function
    call printf                     # Call C printf function
    addl $8, %esp                   # Discard the useless parameter in the stack

    pushl $0                        # exit code
    call exit                       # call C exit

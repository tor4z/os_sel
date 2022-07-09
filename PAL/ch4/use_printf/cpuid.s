# View the CPUID vendor ID string using C libary calls
    .section .data
output:
    .asciz "The processor vendor ID is '%s'\n"

    .section .bss
    # l means local
    .lcomm buffer, 12       # Reserve length (an absolute expression) bytes
                            # for a local common denoted by symbol
    .section .text
    .globl _start
_start:
    xorl %eax, %eax         # set eax to 0
    cpuid                   # perform cpuid

    movl $buffer, %edi      # set the buffer address to edi
    movl %ebx, (%edi)       # copy the 0-3 bytes
    movl %edx, 4(%edi)      # copy the 4-7 bytes
    movl %ecx, 8(%edi)      # copy the 8-11 bytes

    pushl $buffer           # push the second parameter to the stack
    pushl $output           # push the first parameter to the stack
    call printf             # call c-function
    addl $8, %esp           # clear the parameters in the stack

    pushl $0                # push the first parameter into the stack
    call exit               # call exit

    .section .data
output_cpuid:
    .asciz "This processor support the CPUID instruction\n"
output_nocpuid:
    .asciz "This processor does not support the CPUID instruction\n"

    .section .text
    .globl _start
_start:
    nop
    pushfl
    popl %eax
    movl %eax, %edx
    xorl $0x00200000, %eax
    pushl %eax
    popfl
    pushfl
    popl %eax
    xorl %edx, %eax
    # the ID flag in the EFLAGS register(bit 21) is used to
    # determine whether the CPUID instruction is supported by
    # the processor
    testl $0x00200000, %eax     # perform and operation but not store the result
    jnz lb_cpuid
    pushl $output_nocpuid
    call printf
    addl $4, %esp
    jmp lb_exit
lb_cpuid:
    pushl $output_cpuid
    call printf
    addl $4, %esp
lb_exit:
    pushl $0
    call exit

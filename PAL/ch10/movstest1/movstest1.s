    .section .data
value1:
    .ascii "This is a test string.\n"

    .section .bss
    .lcomm output, 33

    .section .text
    .globl _start
_start:
    nop
    # (load effective address) just computes the address of the operand,
    # it does not actually dereference it
    leal value1, %esi   # set the address of value1 to esi
    leal output, %edi   # set the address of output to edi
    movsb               # move a byte from the address of esi to edi
    movsw               # move two byte from the address of esi to edi
    movsl               # move four byte from the address of esi to edi
    # each time movs is executed the esi and edi registers are automatically
    # increased or decreased.
    # If the DF flag is cleared, the esi and edi registers are incremented,
    # and descremented otherwise.
    # cld to clear the DF flag.
    # std to set the DF flag.

    movl $1, %eax
    movl $0, %ebx
    int $0x80

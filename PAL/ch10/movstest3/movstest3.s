    .section .data
value1:
    .ascii "This is a test string.\n"

    .section .bss
    .lcomm output, 23

    .section .text
    .globl _start
_start:
    nop
    leal value1, %esi   # set source address
    leal output, %edi   # set target address
    # loop uses the ecx register. This is easy the remember because
    # the c stands for counter. You however overwrite the ecx register
    # so that will never work!
    movl $23, %ecx
    cld
loop1:
    movsb               # move by byte
    loop loop1          # loop ecx times

    movl $1, %eax
    movl $0, %ebx
    int $0x80

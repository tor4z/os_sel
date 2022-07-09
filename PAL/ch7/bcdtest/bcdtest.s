    .section .data
data1:
    # BCD 1234
    .byte 0x34, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
data2:
    .int 2

    .section .text
    .globl _start
_start:
    nop
    # Remember that the BCD value is converted to the floating-point
    # representation while in the FPU.
    fbld data1
    # st0: 0x40099a40000000000000
    fimul data2
    # st0: 0x40099a40000000000000
    fbstp data1
    # big-endian
    # the value in the memory of data1
    # BCD 2468
    # 0x68    0x24    0x00    0x00    0x00    0x00    0x00    0x00 0x00    0x00

    movl $1, %eax
    movl $0, %ebx
    int $0x80

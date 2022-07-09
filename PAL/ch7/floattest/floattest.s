    .section .data
value1:
    .float 12.34
value2:
    .double 2353.631

    .section .bss
    .lcomm data, 8

    .section .text
    .globl _start
_start:
    nop
    flds value1     # move single-precision floating-point values into and out of the FPU registers
    # st0: 12.340000152587890625 (raw 0x4002c570a40000000000)
    fldl value2     # move double values into and out of the FPU registers
    # st0: 2353.63099999999985812 (raw 0x400a931a189374bc6800)
    # st1: 12.340000152587890625 (raw 0x4002c570a40000000000)
    # (for double precision)
    fstl data       # retrieving the top value on the FPU register stack and placing
                    # the value in a memory location
    # st0: 2353.63099999999985812 (raw 0x400a931a189374bc6800)
    # st1: 12.340000152587890625 (raw 0x4002c570a40000000000)

    # data: 2353.6309999999999
    movl $1, %eax
    movl $0, %ebx
    int $0x80

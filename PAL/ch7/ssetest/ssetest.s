    .section .data
value1:
    .int 1, -1, 0, 135246
value2:
    .quad 1, -1

    .section .text
    .globl _start
_start:
    nop
    movdqu value1, %xmm0
    # big-endian
    # the content of xmm0
    # {
    #     v4_float = {0x0, 0xffffffff, 0x0, 0x0},
    #     v2_double = {0x7fffffffffffffff, 0x0},
    #     v16_int8 = {
    #         0x1, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0x0, 0x0,
    #         0x0, 0x0, 0x4e, 0x10, 0x2, 0x0
    #     },
    #     v8_int16 = {0x1, 0x0, 0xffff, 0xffff, 0x0, 0x0, 0x104e, 0x2},
    #     v4_int32 = {0x1, 0xffffffff, 0x0, 0x2104e},
    #     v2_int64 = {0xffffffff00000001, 0x2104e00000000},
    #     uint128 = 0x2104e00000000ffffffff00000001
    # }
    movdqu value2, %xmm1
    # big-endian
    # the content of xmm0
    # {
    #     v4_float = {0x0, 0x0, 0xffffffff, 0xffffffff},
    #     v2_double = {0x0, 0x7fffffffffffffff},
    #     v16_int8 = {
    #         0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff,
    #         0xff, 0xff, 0xff, 0xff, 0xff
    #     },
    #     v8_int16 = {0x1, 0x0, 0x0, 0x0, 0xffff, 0xffff, 0xffff, 0xffff},
    #     v4_int32 = {0x1, 0x0, 0xffffffff, 0xffffffff},
    #     v2_int64 = {0x1, 0xffffffffffffffff},
    #     uint128 = 0xffffffffffffffff0000000000000001
    # }

    movl $1, %eax
    movl $0, %ebx
    int $0x80

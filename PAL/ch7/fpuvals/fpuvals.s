    .section .text
    .globl _start
_start:
    nop
    fld1        # push 1.0 into the fpu register stack
    fldl2t      # push log_2(10) into the fpu register stack
    fldl2e      # push log_2(e) into the fpu register stack
    fldpi       # push pi into the fpu register stack
    fldlg2      # push log_10(2) into the fpu register stack
    fldln2      # push ln(2) into the fpu register stack
    fldz        # push 0.0 into the fpu register stack

    movl $1, %eax
    movl $0, %ebx
    int $0x80

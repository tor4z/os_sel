# signed integer multiplication
    .section .data
value1:
    .int 10
value2:
    .int -35
value3:
    .int 400

    .section .text
    .globl _start
_start:
    nop
    movl value1, %ebx
    movl value2, %ecx
    imull %ebx, %ecx        # source, destination format
    movl value3, %edx
    imull $2, %edx, %eax    # multiplier, source, destination format

    movl $1, %eax           # exit
    movl $0, %ebx           # exit code
    int $0x80               # interrupt

    .section .text
    .globl _start
_start:
    nop
    # 279 = 0x117
    movl $279, %ecx     # Set the content of register ecx to 279
    movzx %cl, %ebx     # the lower byte if ecx, the cl, is 0x17
                        # the value of ebx is 0x17

    movl $1, %eax       # exit
    int $0x80           # linux syscall

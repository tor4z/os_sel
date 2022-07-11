    .section .data
data:
    .int 40

    .section .text
    .globl _start
_start:
    nop
    xorl %eax, %eax     # set eax to 0
    xorl %ebx, %ebx     # set ebx to 0
    xorl %ecx, %ecx     # set ecx to 0

    movb $20, %al       # set al to 20
    addb $10, %al       # al += 10
    movsx %al, %eax     # move the value of al to eax with sign, eax = 30
    movw $100, %cx      # set cx to 100
    addw %cx, %bx       # bx += cx, bx = 100
    movsx %bx, %ebx     # move from bx to ebx with sign
    movl $100, %edx     # set edx to 100
    addl %edx, %edx     # edx += edx
    addl data, %eax     # eax += 40, eax = 70
    addl %eax, data     # data += eax, data = 110

    movl $1, %eax
    movl $0, %ebx
    int $0x80

    .section .data
string1:
    .asciz "Testing, blabla..."

    .section .text
    .globl _start
_start:
    nop
    leal string1, %edi      # set target string
    movl $0xffff, %ecx      # max length
    movb $0, %al            # set the chart to search

    cld                     # forward mode
    repne scasb             # repeatly scan string
    jne notfound
    subw $0xffff, %cx
    neg %cx                 # $0xffff - cx
    dec %cx                 # ignore the '\0' char

    movl $1, %eax
    movl %ecx, %ebx
    int $0x80
notfound:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

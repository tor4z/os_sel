    .section .data
string1:
    .ascii "This is a test string - a long text string to scan."
string2:
    .ascii "-"
length:
    .int 44

    .section .text
    .globl _start
_start:
    nop
    leal string1, %edi      # set the string
    leal string2, %esi      # set the char to find
    movl length, %ecx       # set max rep times
    lodsb                   # load a byte of data from esi into al
    cld                     # forward
    repne scasb             # rtepeatly compare char in the address of edi with al
    jne notfound            # not find a equal in str
    subw length, %cx        # cx - length, cx store the remain of bytes to compare
    neg %cx                 # get length - cx
    movl $1, %eax
    movl %ecx, %ebx
    int $0x80
notfound:
    movl $1, %eax
    movl $1, %ebx
    int $0x80

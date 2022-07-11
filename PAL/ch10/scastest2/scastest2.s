    .section .data
string1:
    .ascii "This is a test - a long text string to scan."
length:
    .int 11
string2:
    .ascii "test"

    .section .text
    .globl _start
_start:
    nop
    leal string1, %edi      # the string address to be search
    leal string2, %esi      # the source address
    movl length, %ecx       # times to repeat

    lodsl                   # load 4 bytes of data from the address of ESI into EAX
    cld                     # forward mode
    repne scasl             # repeatlly scan
    jne notfound            # no equal found
    subw length, %cx        #
    neg %cx                 # length - cx 

    movl $1, %eax           # exit
    movl %ecx, %ebx         # exit code is the position
    int $0x80
notfound:
    movl $1, %eax           # exit
    movl $0, %ebx           # exit code 0
    int $0x80

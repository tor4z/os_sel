    .section .data
data:
    .int 10

    .section .text
    .globl _start
_start:
    nop
    movl $10, %eax      # Set the content of eax
    movl $5, %ebx       # Set the content of ebx
    cmpxchg %ebx, data  # Compare the value of data with eax,
                        # if data equal to eax, then the data of ebx is load into data
                        # else the value in data is set into ebx register
    # finally the value of data is setted to 5
    movl $1, %eax       # exit
    int $0x80           # linux syscall

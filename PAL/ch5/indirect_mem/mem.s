    .section .data
values:
    .int 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60

    .section .text
    .globl _start
_start:
    nop
    movl values, %eax               # load the first 4 bytes of values into eax
    movl $values, %edi              # set the address of values to edi
    movl $100, 4(%edi)              # set the 4-7 bytes value of values as 100
    movl $1, %edi                   # set edi to 1

    movl values(, %edi, 4), %ebx    # move the second value of values into ebx, which is the exit code
    movl $1, %eax                   # exit
    int $0x80                       # linux syscall
                                    # so the exit code of the program is 100

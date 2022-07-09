# extract the processor vendor ID

    .section .data
output:
    .ascii "The processor vendor ID is 'XXXXXXXXXXXX'\n"

    .section .text
    .globl main
main:
    movl $0, %eax           # CPU vendor ID string
    cpuid                   # perform get the cpu info
    
    movl $output, %edi      # set string addr
    movl %ebx, 28(%edi)     # copy the 0-4 bytes
    movl %edx, 32(%edi)     # copy the 5-8 bytes
    movl %ecx, 36(%edi)     # copy the 9-12 bytes

    movl $4, %eax           # system call value 
    movl $1, %ebx           # file discriptor
    movl $output, %ecx      # start of the string
    movl $42, %edx          # the length of string
    int $0x80               # linux system call to access the console display

    movl $1, %eax           # exit syscall
    movl $0, %ebx           # exitcode
    int $0x80

    .section .data
string1:
    .asciz "This is a TEST, for the conversion program!\n"
length:
    .int 43

    .section .text
    .globl _start
_start:
    nop
    leal string1, %esi  # set source string address
    movl %esi, %edi     # set target string address
    movl length, %ecx   # set the loop times
    cld                 # forward mode
loop1:
    lodsb               # load a byte of data into AL register
    cmpb $'a', %al      # if the value of al less than 'a'
    jl skip             # then skip.
    cmpb $'z', %al      # if the value of al great than 'z'
    jg skip             # then skip.
    subb $0x20, %al     # conver to upper case.
skip:
    stosb               # store the converted char
    loop loop1          # loop
end:
    pushl $string1      # the first parameter of printf
    call printf         # call printf
    addl $4, %esp       # restore stack pointer

    pushl $0            # exit code
    call exit           # call exit

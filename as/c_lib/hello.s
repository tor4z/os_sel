.data
msg:
    .asciz "Printf In Assembly!!"

.text
.globl main

# The %rip register on x86-64 is a special-purpose
# register that always holds the memory address of
# the next instruction to execute in the program's
# code segment. The processor increments %rip
# automatically after each instruction, and control
# flow instructions like branches set the value of
# %rip to change the next instruction. Perhaps
# surprisingly, %rip also shows up when an assembly
# program refers to a global variable. See the
# sidebar under "Addressing modes" below to
# understand how %rip-relative addressing works.

main:
    subq $8, %rsp
    leaq msg(%rip), %rdi
    call puts

    xor %edi, %edi
    call exit

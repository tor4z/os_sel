    .section .data
string1:
    .asciz "test"
string2:
    .asciz "test1"
length1:
    .int 4
length2:
    .int 5

    .section .text
    .globl _start
_start:
    nop
    leal string1, %esi
    leal string2, %edi
    movl length1, %ecx
    movl length2, %eax
    cmpl %eax, %ecx         # compare by eax - ecx
    ja longer               # if eax greater than ecx, then jump
    xchg %ecx, %eax         # exchange, masure ecx less than eax
    # The CMPS instruction subtracts the destination string
    # from the source string, and sets the carry, sign,
    # overflow, zero, parity, and adjust flags in the EFLAGS
    # register appropriately
longer:
    cld                     # forward
    repe cmpsb              # compare by src - dest
    je equal                # dest equal to src
    jg greater              # dest greater than src
less:
    movl $1, %eax
    movl $255, %ebx
    int $0x80
greater:
    movl $1, %eax
    movl $1, %ebx
    int $0x80
equal:
    movl length1, %ecx
    movl length2, %eax
    cmpl %ecx, %eax         # compare by ecx - eax
    jg greater
    jl less

    movl $1, %eax
    movl $0, %ebx
    int $0x80

# Carry flag is carry or borrow out of the Most Significant bit (MSb):

# CF (bit 0) Carry flag — Set if an arithmetic operation
# generates a carry or a borrow out of the mostsignificant
# bit of the result; cleared otherwise. This flag indicates
# an overflow condition for unsigned-integer arithmetic. It
# is also used in multiple-precision arithmetic.

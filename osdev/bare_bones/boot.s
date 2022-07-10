    .set ALIGN, 1 << 0
    .set MEMINFO, 1 << 1
    .set FLAGS, ALIGN | MEMINFO
    .set MAGIC, 0x1badb002
    .set CHUCKSUM, -(MAGIC + FLAGS)

    .section .multiboot
    .align 4
    .long MAGIC
    .long FLAGS
    .long CHUCKSUM

    .section .bss
    .align 16
stack_bottom:
    .skip 16384                         # 16KB
stack_top:

    .section .text
    .global _start
    .type _start, @function
_start:
    movl $stack_top, %esp
    call kernel_main

    cli
fin:
    hlt
    jmp fin

    .size _start, . - _start

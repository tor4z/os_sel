#include <stdio.h>

#define exit0()                     \
    __asm__ __volatile__(           \
        "movl $1, %%eax \n\t"       \
        "xorl %%ebx, %%ebx \n\t"    \
        "int $0x80"                 \
        : /*no output*/             \
        : /*no input*/              \
        : "%eax", "%ebx"            \
    )


int main()
{
    printf("hello world\n");
    exit0();
}

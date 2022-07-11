#include <stdio.h>


int main()
{
    int a;
    a = 1;
    unsigned char b = 0;

    asm volatile(
        "lock\n\t"
        "decl %0\n\t"
        "sete %1"           // set byte if equal 
        : "=m"(a), "=q"(b)  // b is in any of the registers eax, ebx, ecx and edx.
        : "m"(a)
        : "memory"          // the code is changing the contents of memory (a).
    );

    printf("a = %d, b = %d\n", a, b);
    return 0;
}

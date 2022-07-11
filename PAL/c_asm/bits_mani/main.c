#include <stdio.h>


int main()
{
    int a = 0;
    int i = 1;

    asm volatile(
        "btsl %1, %0"
        : "=m"(a)       // data in memory
        : "Ir"(i)       // Ir: i is in a register, and it’s value ranges from 0-31 
        : "cc"          // As the condition codes will be changed, we are adding "cc" to clobberlist.
    );

    printf("a = %d\n", a);

    asm volatile(
        "btrl %1, %0"
        : "=m"(a)
        : "Ir"(i)
        : "cc"
    );

    printf("a = %d\n", a);

    return 0;
}

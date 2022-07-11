#include <stdio.h>


int main()
{
    int a = 10, b = 5;

    asm(
        "addl %%ebx, %%eax"
        : "=a"(a)
        : "a"(a), "b"(b)
    );

    printf("a + b = %d\n", a);
    return 0;
}

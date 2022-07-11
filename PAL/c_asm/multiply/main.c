#include <stdio.h>


int main()
{
    int a, b;
    a = 1;

    asm(
        "leal (%1, %1, 4), %0"
        : "=r"(b)
        : "r"(a)
    );

    printf("b=%d\n", b);
    return 0;
}

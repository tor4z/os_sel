#include <stdio.h>


int main()
{
    int x = 1, y;

    asm(
        "leal (%1, %1, 4), %0"
        : "=r"(y)
        : "0"(x)
    );

    printf("y=%d\n", y);
    return 0;
}

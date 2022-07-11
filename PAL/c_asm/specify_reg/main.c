#include <stdio.h>


int main()
{
    int x = 1;

    asm(
        "leal (%%ecx, %%ecx, 4), %%ecx"
        : "=c"(x)
        : "c"(x)
    );

    printf("x=%d\n", x);
    return 0;
}

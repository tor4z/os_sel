#include <stdio.h>


int main()
{
    int src = 1;
    int dest;
    asm ("mov %1, %0\n\t"
         "add $1, %0"
        : "=r"(dest)
        : "r" (src)
    );

    printf("src=%d\n", src);
    printf("dest=%d\n", dest);
    return 0;
}

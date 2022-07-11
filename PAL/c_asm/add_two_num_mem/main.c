#include <stdio.h>


int main()
{
    int a = 10, b = 5;

    // This is an atomic addition. We can remove the instruction
    // 'lock' to remove the atomicity.
    asm volatile(
        "lock\n\t"
        "addl %1, %0"
        : "=m"(a)
        : "ir"(b), "m"(a)
        // ir: integer and should reside in some register 
    );

    printf("a + b = %d\n", a);
    return 0;
}

#include <stdio.h>


int main()
{
// "r" says to GCC to use any register for storing the operands.
// output operand constraint should have a constraint modifier "=".
// And this modifier says that it is the output operand and is write-
// only.

    int a = 1, b = 0;
    asm(
        "movl %1, %%eax\n\t"
        "movl %%eax, %0"
        : "=r"(b)
        : "r"(a)
        : "%eax"
    );

    printf("b=%d\n", b);
    return 0;
}

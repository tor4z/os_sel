#include <stdio.h>


#define cpy_blk(src, dest, n)           \
    __asm__ __volatile__(               \
        "shrl $2, %%ecx \n\t"           \
        "cld \n\t"                      \
        "rep movsl \n\t"                \
        "andl $3, %%ecx \n\t"           \
        "rep movsb \n\t"                \
        : /*not output*/                \
        : "S"(src), "D"(dest), "c"(n)   \
        : "memory"                      \
    )


int main()
{
    char *src = "Hello world";
    char dest[64];

    cpy_blk(src, dest, 12);

    printf("dest=%s\n", dest);
    return 0;
}

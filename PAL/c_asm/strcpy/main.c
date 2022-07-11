#include <stdio.h>


static inline char *strcpy(char *dest, const char *src)
{
    int d0, d1;

    asm volatile(
        "cpy:\t lodsb \n\t"         // load a byte of data from memory(dsi) to al
        "stosb \n\t"                // store a byte of data from al to memory(edi)
        "testb %%al, %%al \n\t"     // check is the value of al is '\0'
        "jnz cpy \n\t"              // not finished yet.
        : "=&S"(d0), "=&D"(d1)      // output bind to ESI and EDI
        : "0"(src), "1"(dest)       // input map to output
        : "memory", "cc"            // use memory, and may change cc register by testb
    );
    // Constraints "&S", "&D" say that the registers
    // esi and edi are early clobber registers, ie,
    // their contents will change before the completion of the function. 

    return dest;
}


int main()
{
    char *src = "hello world";
    char dest[100];                     // 100 bytes of output buffer

    strcpy(dest, src);
    printf("dest=%s\n", dest);
    return 0;
}

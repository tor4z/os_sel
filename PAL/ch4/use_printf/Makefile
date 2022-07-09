build: cpuid.s
	as --32 -o cpuid.o cpuid.s
	ld -o cpuid.out -dynamic-linker /lib32/ld-linux.so.2\
		-m elf_i386 -lc cpuid.o

clean:
	@-rm -f cpuid.out cpuid.o

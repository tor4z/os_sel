cmov.out: cmov.s
	as --32 -o cmov.o $<
	ld -o $@ --dynamic-linker /lib32/ld-linux.so.2\
		-m elf_i386 -lc cmov.o

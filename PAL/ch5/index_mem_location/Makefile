mem.out: mem.s
	as --32 -o mem.o $<
	ld -o $@ -m elf_i386 -dynamic-linker \
		/lib32/ld-linux.so.2 -lc mem.o

clean:
	@-rm -f mem.o mem.out

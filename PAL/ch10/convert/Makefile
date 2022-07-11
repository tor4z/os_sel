convert.out: convert.s
	as --32 -o convert.o $<
	ld -o $@ -m elf_i386 -lc --dynamic-linker\
		/lib32/ld-linux.so.2 convert.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

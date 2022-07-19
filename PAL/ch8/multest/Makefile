a.out: multest.s
	as --32 -o multest.o $<
	ld -m elf_i386 -dynamic-linker /lib32/ld-linux.so.2 -lc\
		-o $@ multest.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

addtest4.out: addtest4.s
	as --32 -o addtest4.o $<
	ld -m elf_i386 --dynamic-linker /lib32/ld-linux.so.2\
		-lc -o $@ addtest4.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

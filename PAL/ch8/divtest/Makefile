a.out: divtest.s
	as --32 -gstabs $< -o divtest.o
	ld -m elf_i386 -lc --dynamic-linker /lib32/ld-linux.so.2\
		divtest.o -o $@

.PHOMY: clean
clean:
	@-rm -f *.o *.out

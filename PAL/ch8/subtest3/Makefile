a.out: subtest3.s
	as -32 $< -o subtest3.o
	ld -m elf_i386 -lc --dynamic-linker /lib32/ld-linux.so.2\
		subtest3.o -o $@

.PHOMY: clean
clean:
	@-rm -f *.o *.out

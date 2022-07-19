a.out: subtest2.s
	as --32 $< -o subtest2.o
	ld -m elf_i386 subtest2.o -o $@


.PHOMY: clean
clean:
	@-rm -f *.o *.out

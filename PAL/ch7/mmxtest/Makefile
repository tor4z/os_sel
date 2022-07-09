mmxtest.out: mmxtest.s
	as --32 -gstabs -o mmxtest.o $<
	ld -m elf_i386 -o $@ mmxtest.o

clean:
	@-rm -f *.o *.out

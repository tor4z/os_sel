ssetest.out: ssetest.s
	as --32 -gstabs -o ssetest.o $<
	ld -o $@ -m elf_i386 ssetest.o

clean:
	@-rm -f *.o *.out

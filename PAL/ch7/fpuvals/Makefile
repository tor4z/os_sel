fpuvals.out: fpuvals.s
	as -gstabs --32 -o fpuvals.o $<
	ld -o $@ -m elf_i386 fpuvals.o

clean:
	@-rm -f *.o *.out

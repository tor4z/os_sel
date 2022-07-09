floattest.out: floattest.s
	as -gstabs --32 -o floattest.o $<
	ld -o $@ -m elf_i386 floattest.o

clean:
	@-rm -f *.o *.out

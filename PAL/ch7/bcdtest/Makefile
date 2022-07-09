bcdtest.out: bcdtest.s
	as -gstabs --32 -o bcdtest.o $<
	ld -o $@ -m elf_i386 bcdtest.o

clean:
	@-rm -f *.o *.out

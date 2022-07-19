a.out: saltest.s
	as -gstabs --32 $< -o saltest.o
	ld -m elf_i386 saltest.o -o $@

.PHONY: clean
clean:
	@-rm -f *.o *.out

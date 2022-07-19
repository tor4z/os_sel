a.out: cpuidtest.s
	as --32 -gstabs $< -o cpuidtest.o
	ld -m elf_i386 --dynamic-linker /lib32/ld-linux.so.2 -lc\
		cpuidtest.o -o $@

.PHONY: clean
clean:
	@-rm -f *.o *.out

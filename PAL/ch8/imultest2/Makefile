a.out: imultest2.s
	as --32 -gstabs $< -o imultest2.o
	ld -m elf_i386 --dynamic-linker /lib32/ld-linux.so.2 -lc\
		imultest2.o -o $@

.PHONY: clean
clean:
	@-rm -f *.o *.out

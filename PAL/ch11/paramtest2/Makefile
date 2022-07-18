a.out: paramtest2.s
	gcc -gstabs -m32 -c $< -o paramtest2.o
	ld -m elf_i386 --dynamic-linker /lib32/ld-linux.so.2\
		-lc paramtest2.o -o $@


.PHONY: clean
clean:
	@rm -r *.o *.out

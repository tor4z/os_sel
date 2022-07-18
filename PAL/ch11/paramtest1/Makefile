a.out: paramtest1.s
	gcc -m32 -c $< -o paramtest1.o
	ld -m elf_i386 --dynamic-linker /lib32/ld-linux.so.2\
		-lc -o $@ paramtest1.o


.PHONY: clean
clean:
	@-rm -f *.o *.out

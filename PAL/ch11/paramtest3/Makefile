a.out: paramtest3.s
	gcc -c -m32 $< -o paramtest3.o
	ld -m elf_i386 -lc --dynamic-linker /lib32/ld-linux.so.2\
		paramtest3.o -o $@


.PHONY: clean
clean:
	@-rm -f *.o *.out

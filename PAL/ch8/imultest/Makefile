a.out: imultest.s
	as -gstabs --32 $< -o imultest.o
	ld -m elf_i386 --dynamic-linker /lib32/ld-linux.so.2 -lc\
		-o $@ imultest.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

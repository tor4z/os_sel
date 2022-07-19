a.out: sbbtest.s
	as -gstabs --32 $< -o sbbtest.o
	ld -m elf_i386 -lc -dynamic-linker /lib32/ld-linux.so.2\
		sbbtest.o -o $@

.PHONY: clean
clean:
	@-rm -f *.o *.out

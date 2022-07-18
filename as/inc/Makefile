main.out: main.S
	as --32 $< -o main.o
	ld -m elf_i386 main.o -o $@

.PHONY: clean
clean:
	@-rm -f *.o *.out

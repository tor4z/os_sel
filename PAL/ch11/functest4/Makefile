a.out: area.o functest4.o
	ld -m elf_i386 -o $@ $^

area.o: area.s
	as --32 $< -o $@


functest4.o: functest4.s
	as --32 $< -o $@


.PHONY: clean
clean:
	@-rm -f *.o *.out

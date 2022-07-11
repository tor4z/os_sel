functest1.out: functest1.s
	as -gstabs -o functest1.o $<
	ld -o $@ functest1.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

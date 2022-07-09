inttest.out: inttest.s
	as -gstabs -o inttest.o $<
	ld -o $@ inttest.o

clean:
	@-rm -f inttest.o inttest.out

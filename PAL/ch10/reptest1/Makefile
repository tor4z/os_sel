reptest1.out: reptest1.s
	as -gstabs -o reptest1.o $<
	ld -o $@ reptest1.o

clean:
	@-rm -f *.o *.out

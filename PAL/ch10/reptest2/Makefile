reptest2.out: reptest2.s
	as -gstabs -o reptest2.o $<
	ld -o $@ reptest2.o

clean:
	@-rm -f *.o *.out

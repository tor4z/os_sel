stostest1.out: stostest1.s
	as -gstabs $< -o stostest1.o
	ld -o $@ stostest1.o

clean:
	@-rm -f *.o *.out

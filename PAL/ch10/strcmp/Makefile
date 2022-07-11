strcmp.out: strcmp.s
	as -o strcmp.o $<
	ld -o $@ strcmp.o

clean:
	@-rm -f *.o *.out

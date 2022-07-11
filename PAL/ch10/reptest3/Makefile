reptest3.out: reptest3.s
	as -gstabs $< -o reptest3.o
	ld -o $@ reptest3.o

clean:
	@-rm -f *.o *.out

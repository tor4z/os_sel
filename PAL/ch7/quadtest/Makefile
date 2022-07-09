quadtest.out: quadtest.s
	as -gstabs -o quadtest.o $<
	ld -o $@ quadtest.o

clean:
	@-rm -f *.o *.out

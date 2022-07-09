movstest2.out: movstest2.s
	as -gstabs -o movstest2.o $<
	ld -o $@ movstest2.o

clean:
	@-rm -f *.o *.out

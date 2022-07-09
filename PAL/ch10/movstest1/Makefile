movstest1.out: movstest1.s
	as -gstabs -o movstest1.o $<
	ld -o $@ movstest1.o

clean:
	@-rm -f *.o *.out

movstest3.out: movstest3.s
	as -gstabs -o movstest3.o $<
	ld -o $@ movstest3.o

clean:
	@-rm -f *.o *.out

scastest2.out: scastest2.s
	as -gstabs -o scastest2.o $<
	ld -o $@ scastest2.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

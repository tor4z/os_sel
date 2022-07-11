scastest1.out: scastest1.s
	as -o scastest1.o $<
	ld -o $@ scastest1.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

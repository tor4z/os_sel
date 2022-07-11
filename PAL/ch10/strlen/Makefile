strlen.out: strlen.s
	as -o strlen.o $<
	ld -o $@ strlen.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

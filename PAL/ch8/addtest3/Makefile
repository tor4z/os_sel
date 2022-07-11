addtest3.out: addtest3.s
	as -o addtest3.o $<
	ld -o $@ addtest3.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

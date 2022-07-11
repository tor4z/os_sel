addtest1.out: addtest1.s
	as -gstabs -o addtest1.o $<
	ld -o $@ addtest1.o

.PHONY: clean
clean:
	@-rm -f *.out *.o

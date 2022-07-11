cmpstest1.out: cmpstest1.s
	as -o cmpstest1.o $<
	ld -o $@ cmpstest1.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

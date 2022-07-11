cmpstest2.out: cmpstest2.s
	as -o cmpstest2.o $<
	ld -o $@ cmpstest2.o

.PHONY: clean
clean:
	@-rm -f *.o *.out

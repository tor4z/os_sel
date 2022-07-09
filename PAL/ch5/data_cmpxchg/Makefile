cmpxchg.out: cmpxchg.s
	as -gstabs -o cmpxchg.o $<
	ld -o $@ cmpxchg.o

clean:
	@-rm -f cmpxchg.o cmpxchg.out

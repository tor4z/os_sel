mem.out: mem.s
	as -gstabs -o mem.o $<
	ld -o $@ mem.o

clean:
	@-rm -f mem.o mem.out

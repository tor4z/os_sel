bswap.out: bswap.s
	as -gstabs -o bswap.o $<
	ld bswap.o -o $@

clean:
	@-rm -f bswap.o bswap.out

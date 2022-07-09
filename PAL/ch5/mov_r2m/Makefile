mov.out: mov.s
	as -gstabs -o mov.o $<
	ld -o $@ mov.o

clean:
	@-rm -f mov.o mov.out

all: movzx1.out movsx1.out movsx2.out

movzx1.out: movzxtest1.s
	as -gstabs -o movzx1.o $<
	ld -o $@ movzx1.o

movsx1.out: movsxtest1.s
	as -gstabs -o movsx1.o $<
	ld -o $@ movsx1.o

movsx2.out: movsxtest2.s
	as -gstabs -o movsx2.o $<
	ld -o $@ movsx2.o

clean:
	@-rm -f *.o *.out

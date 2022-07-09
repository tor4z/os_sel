build: bss1.out bss2.out data1.out

bss1.out: bss1.s
	as -o bss1.o $<
	ld -o $@ bss1.o

bss2.out: bss2.s
	as -o bss2.o $<
	ld -o $@ bss2.o

data1.out: data1.s
	as -o data1.o $<
	ld -o $@ data1.o

clean:
	@-rm -f bss1.o bss1.out bss2.o bss2.out data1.o data1.out

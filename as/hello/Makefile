all: run clean

.PHONY: run
run: a.out
	@./a.out

.PHONY: a.out
a.out:
	@gcc -c hello.s
	@ld hello.o


.PHONY: clean
clean:
	@-rm -f a.out

all: run clean


.PHONY: a.out
a.out: hello.s
	@gcc $<

.PHONY: run
run: a.out
	@./a.out

.PHONY: clean
clean:
	@-rm -f a.out

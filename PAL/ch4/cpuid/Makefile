# - If the file name ends with ".s"
#   (lowercase 's'), then gcc calls
#   the assembler.
# - If the file name ends with ".S"
#   (uppercase 'S'), then gcc applies
#   the C preprocessor on the source
#   file (i.e. it recognizes directives
#   such as #if and replaces macros),
#   and then calls the assembler on the
#   result.

build: cpuid.s
	as -o cpuid.o cpuid.s
	ld -o cpuid.out cpuid.o

usegcc: cpuid.S
	gcc cpuid.S -no-pie -o cpuid.o
#	ld cpuid.o -o cpuid.out

clean:
	@-rm -f cpuid.out cpuid.o

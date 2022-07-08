addr=0x7c00
OBJDIR=.

CFLAGS := $(CFLAGS) -O1 -fno-builtin -I$(OBJDIR) -MD 
CFLAGS += -fno-omit-frame-pointer
CFLAGS += -Wall -Wno-format -Wno-unused -Werror -gstabs -m32

LDFLAGS=-m elf_i386

all:kernel

kernel:entry.o
	ld $(LDFLAGS) -N -e start -Ttext $(addr) -o $@.out $^
#	ld $(LDFLAGS) -N -e start -o $@.out $^
#	objdump -S $@.out >$@.asm
	cp $@.out $@.out.bak
	objcopy -S -O binary $@.out $@
#	objcopy -S -O binary -j .text $< $@
#	 cp $@.out $@

entry.o:entry.S
	gcc -nostdinc $(CFLAGS) -c -o $@ $<

clean:
	@-rm -f kernel.out kernel.o kernel.d kernel kernel.asm\
		entry.o entry.d

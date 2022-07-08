addr=0x7c00
OBJDIR=.

CFLAGS := $(CFLAGS) -O1 -fno-builtin -I$(OBJDIR) -MD                                                                                        
CFLAGS += -fno-omit-frame-pointer
CFLAGS += -Wall -Wno-format -Wno-unused -Werror -gstabs -m32


LDFLAGS=-m elf_i386


build: kernel
	nasm -o bootloader hello.asm

kernel:entry.S
	gcc -nostdinc $(CFLAGS) -c -o $@ $<

img: build
	dd if=bootloader of=myos.img bs=512 count=1
	dd if=/dev/zero of=myos.img bs=512 seek=1 skip=1 count=2879


copy:
	mkdir -p /tmp/floppy
	mount -o loop myos.img /tmp/floppy -o fat=12
	sleep 1
	cp kernel /tmp/floppy
	sleep 1
	umount /tmp/floppy

run:
	qemu-system-i386 -drive file=myos.img,if=floppy

clean:
	@rm -f bootloader myos.img haribote.bin kernel kernel.d

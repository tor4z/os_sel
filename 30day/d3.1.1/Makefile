CFLAGS := $(CFLAGS) -O1 -fno-builtin -MD -I.
CFLAGS += -fno-omit-frame-pointer
CFLAGS += -Wall -Wno-format -Wno-unused -Werror -gstabs -m32
# LDFLAGS=-m elf_i386

.PHONY: boot.bin
boot.bin: boot.asm
	nasm -o boot.bin boot.asm

.PHONY: kernel.bin
kernel.bin: kernel.S
	gcc -nostdinc $(CFLAGS) -c -o $@ $<

.PHONY: cpy
cpy:
	mkdir -p /tmp/floppy
	mount -o loop a.img /tmp/floppy -o fat=12
	sleep 1
	cp kernel.bin /tmp/floppy
	sleep 1
	umount /tmp/floppy

.PHONY: build
build: kernel.bin a.img

.PHONY: a.img
a.img: boot.bin
	dd if=boot.bin of=a.img bs=512 count=1
	dd if=/dev/zero of=a.img bs=512 count=2879\
	   seek=1 skip=1

.PHONY: run
run:
	@qemu-system-i386 -drive file=a.img,if=floppy

.PHONY: clean
clean:
	@-rm -f boot.bin a.img kernel.bin kernel.d

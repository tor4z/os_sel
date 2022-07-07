.PHONY: boot.bin
boot.bin: hello.asm
	nasm -o boot.bin hello.asm

# A floppy has 1440KB space, which is 2880 sector.
# 512 byte per sector.
.PHONY: a.img
a.img: boot.bin
	dd if=boot.bin of=a.img bs=512 count=1
	dd if=/dev/zero of=a.img bs=512 seek=1 skip=1 count=2879

.PHONY: run
run: a.img
	qemu-system-i386 -drive file=a.img,if=floppy

.PHONY:
clean:
	@-rm -f a.img boot.bin

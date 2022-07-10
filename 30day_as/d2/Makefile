.PHONY: boot.bin
boot.bin: hello.s
	as --32 -o boot.o hello.s
	ld -Ttext 0x7c00 -m elf_i386 boot.o -o boot.out
	objcopy -S -O binary boot.out $@

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
	@-rm -f a.img boot.bin boot.out boot.o

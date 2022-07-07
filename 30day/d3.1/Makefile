.PHONY: boot.bin
boot.bin: boot.asm
	nasm -o boot.bin boot.asm

.PHONY: kernel.bin
kernel.bin: kernel.asm
	nasm -o kernel.bin kernel.asm

.PHONY: cpy_kernel
cpy_kernel: kernel.bin a.img
	@mkdir -p /tmp/floppy
	@mount -o loop a.img /tmp/floppy -o fat=12
	@cp kernel.bin /tmp/floppy
	@umount /tmp/floppy

.PHONY: a.img
a.img: boot.bin
	dd if=boot.bin of=a.img bs=512 count=1
	dd if=/dev/zero of=a.img bs=512 count=2879\
	   seek=1 skip=1

.PHONY: run
run: cpy_kernel
	@qemu-system-i386 -drive file=a.img,if=floppy

.PHONY: clean
clean:
	@-rm -f boot.bin a.img kernel.bin

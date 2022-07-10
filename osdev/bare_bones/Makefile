boot.o: boot.s
	as --32 $< -o $@

kernel.o: kernel.c
	gcc -march=i686 -m32 -c $< -o $@ -std=c99 -ffreestanding -O2 -Wall -Wextra

myos.bin: kernel.o boot.o linker.ld
	gcc -m32 -T linker.ld -o $@ -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

.PHONY: verify
verify: myos.bin
	grub-file --is-x86-multiboot myos.bin
	echo $?

myos.iso: myos.bin grub.cfg
	mkdir -p isodir/boot/grub
	cp myos.bin isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir

.PHONY: run
run: myos.iso
	qemu-system-i386 -cdrom myos.iso

.PHONY: clean
clean:
	@-rm -rf myos.iso myos.bin boot.o kernel.o isodir

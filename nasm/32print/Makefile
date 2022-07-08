boot: boot.asm
	nasm $<

a.img: boot
	dd if=boot of=a.img bs=512 count=1

run: a.img
	qemu-system-i386 -drive file=a.img,if=floppy

bochs: a.img bochsrc
	bochs -f bochsrc

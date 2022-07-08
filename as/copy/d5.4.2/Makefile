all:
	nasm -o bootloader hello.asm
	make -C ./kernel addr=0xc400

img:all
	dd if=bootloader of=myos.img bs=512 count=1
	dd if=/dev/zero of=myos.img bs=512 seek=1 skip=1 count=2879


copy:img
	mkdir -p /tmp/floppy
	mount -o loop myos.img /tmp/floppy -o fat=12
	sleep 1
	cp ./kernel/kernel /tmp/floppy
	sleep 1
	umount /tmp/floppy

run:copy
	qemu-system-i386 -drive file=myos.img,if=floppy

clean:
	@-rm -f bootloader myos.img haribote.bin
	make -C ./kernel clean

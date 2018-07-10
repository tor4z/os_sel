ROMIMAGE	:= /usr/local/share/bochs/BIOS-bochs-latest
VGAROMIMAGE	:= /usr/share/vgabios/vgabios.bin
KEYMAP		:= /usr/local/share/bochs/keymaps/x11-pc-us.map
FLOPPY_PATH	:= /mnt/floppy


.PHONY: build
build: pm1.com b.img bochsrc
	mount -o loop b.img $(FLOPPY_PATH)
	cp pm1.com $(FLOPPY_PATH)
	umount $(FLOPPY_PATH)


pm1.com: pm1.asm pm.inc
	nasm -o $@ pm1.asm


bochsrc: bochsrc.m4
	m4 -D_romimage=$(ROMIMAGE) -D_vgaromimage=$(VGAROMIMAGE) \
	   -D_keymap=$(KEYMAP) $^ > $@


b.img:
	bximage -fd=1.44M -mode=create -q $@
	mkfs.vfat $@


.PHONY: clean
clean:
	rm *.com bochsrc *.log b.img

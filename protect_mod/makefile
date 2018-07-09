ROMIMAGE	:= /usr/local/share/bochs/BIOS-bochs-latest
VGAROMIMAGE	:= /usr/share/vgabios/vgabios.bin
KEYMAP		:= /usr/local/share/bochs/keymaps/x11-pc-us.map


.PHONY: build
build:
	dd if=pm1.bin of=b.img bs=512 count=1 conv=notrunc


pm1.bin: pm1.asm pm.inc
	nasm -o $@ pm1.asm


bochsrc: bochsrc.m4
	m4 -D_romimage=$(ROMIMAGE) -D_vgaromimage=$(VGAROMIMAGE) \
	   -D_keymap=$(KEYMAP) $^ > $@


b.img:
	bximage -fd=1.44M -mode=create -q $@


.PHONY: clean
clean:
	rm *.bin bochsrc *.log

ROMIMAGE	:= /usr/local/share/bochs/BIOS-bochs-latest
VGAROMIMAGE	:= /usr/share/vgabios/vgabios.bin
KEYMAP		:= /usr/local/share/bochs/keymaps/x11-pc-us.map



.PHONY: build
build: boot.bin a.img bochsrc
	dd if=boot.bin of=a.img bs=512 count=1 conv=notrunc


a.img:
	bximage -q -mode=create -fd=1.44M $@


boot.bin: boot.asm
	nasm $^ -o $@


bochsrc: bochsrc.m4
	m4 -D_romimage=$(ROMIMAGE) -D_vgaromimage=$(VGAROMIMAGE) -D_keymap=$(KEYMAP) $^ > $@


.PHONY: clean
clean:
	rm boot.bin a.img *.log bochsrc

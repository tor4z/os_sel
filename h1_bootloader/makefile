.PHONY: build
build: boot.bin a.img
	dd if=boot.bin of=a.img bs=512 count=1 conv=notrunc


a.img:
	bximage -q -mode=create -fd=1.44M $@


boot.bin: boot.asm
	nasm $^ -o $@


.PHONY: clean
clean:
	rm boot.bin a.img *.log

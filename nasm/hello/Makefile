all:
	@nasm -o hello.bin hello.nasm
	@dd if=hello.bin of=a.img bs=512 count=1 conv=notrunc

clean:
	@-rm -f hello.bin bochs_out.txt

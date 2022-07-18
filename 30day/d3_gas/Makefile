CC := gcc
AS := as

BOOT_ENTRY_ADDR := 0x7c00
CFLAGS := -fno-builtin -MD -nostdinc -static -m32
CFLAGS += -fno-omit-frame-pointer -fno-pic
CFLAGS += -Wall -Wno-format -Wno-unused -Werror -gstabs
LDFLAGS := -m elf_i386 -N -e boot_start
ASFLAGS := --32


boot.o: boot.s
	$(AS) $(ASFLAGS) $< -o $@


# .PHONY: build_kernel
# build_kernel:
# 	make -C kernel


# .PHONY: cpy_kernel
# cpy_kernel: build_kernel a.img
# 	mkdir -p /tmp/floppy
# 	mount -o loop a.img /tmp/floppy -o fat=12
# 	cp kernel/kernel.bin /tmp/floppy
# 	umount /tmp/floppy


boot.bin: boot.o
	ld $(LDFLAGS) -Ttext $(BOOT_ENTRY_ADDR) $< -o boot.out
	objcopy -S -O binary boot.out $@


a.img: boot.bin
	dd if=boot.bin of=a.img bs=512 count=1
	dd if=/dev/zero of=a.img bs=512 count=2879\
	   seek=1 skip=1


.PHONY: run
run: a.img
	@qemu-system-i386 -drive file=a.img,if=floppy


.PHONY: clean
clean:
	@-rm -f *.bin *.img *.o *.out *.output *.d
	make -C kernel clean

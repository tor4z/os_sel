override KERNEL := myos.elf

define DEFAULT_VAR = 
	ifeq ($(origin $1), default)
		override $(1) := $(2)
	endif

	ifeq ($(origin $1), undefined)
		override $(1) := $(2)
	endif
endef

$(eval $(call DEFAULT_VAR,CC,cc))

CFLAGS ?= -O2 -g -Wall -Wextra -pipe

LDFLAGS ?=

override INTERNALCFLAGS :=  \
	-I.						\
	-std=gnu11				\
	-ffreestanding			\
	-fno-stack-protector	\
	-fno-stack-check		\
	-fno-pie				\
	-fno-pic				\
	-mabi=sysv				\
	-mno-80387				\
	-mno-mmx				\
	-mno3dnow				\
	-mno-sse				\
	-mno-sse2				\
	-mno-red-zone			\
	-mcmode=kernel			\
	-MMD

override INTERNALLDFLAGS :=		\
	-nostdlib					\
	-static						\
	-Wl,-z,max-page-size=0x1000	\
	-Wl,-T,linker.ld

override CFILES := $(shell find ./ -type f -name '*.c')
override OBJ := $(CFILES: .c=.o)
override HEADER_DEPS := $(CFILES: .c=.d)

.PHONY: all
all: $(KERNEL)

$(KERNEL): $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) $(INTERNALLDFLAGS) -o $@

# -include $(HEADER_DEPS)
%.o: %.c
	$(CC) $(CFLAGS) $(INTERNALCFLAGS) -c $^ -o $@

.PHONY: verify
verify: $(KERNEL)
	grub-file --is-x86-multiboot $<
	echo $?

myos.iso: $(KERNEL) grub.cfg
	mkdir -p isodir/boot/grub
	cp $(KERNEL) isodir/boot
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o $@ isodir

.PHONY: run
run: myos.iso
	qemu-system-x86_64 -cdrom myos.iso

.PHONY: clean
clean:
	rm -rf $(KERNEL) $(OBJ) $(HEADER_DEPS) myos.iso

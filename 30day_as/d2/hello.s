init:
    jmp entry               # short jump (2 bytes)
	nop                     # nop (1 bytes)
	.ascii "bootset ";      # boot sector name (8 bytes)
	.short 512              # sector size (2 bytes)
	.byte 1                 # number of sectors per cluster (1 byte)
	.short 1                # number of reserved sectors (2 bytes)
	.byte 2                 # number of FAT copis (1 byte)
	.short 224              # number of root dir entries (2 bytes)
	.short 2880             # number of sectors in filesystem (2 bytes)
	.byte 0xf0              # media descriptor type (1 byte)
	.short 9                # number of sectors per FAT (2 bytes)
	.short 18               # number of sectors per track (2 bytes)
	.short 2                # number of heads (2 bytes)
	.int 0                  # number of hidden sectors, set to 0 (4 bytes)
	.int 2880               # disk size (4 bytes)
	.byte 0,0,0x29          # ??
	.int 0xffffffff         # ??
	.ascii "Hello Boot "    # disk name (11 bytes)
	.ascii "FAT12   "       # format name (8 bytes)

    .code16
entry:
    movw $0, %ax
    movw %ax, %ss
    movw %ax, %ds
    movw %ax, %es
    movw $0x7c00, %sp
    leaw msg, %si
putloop:
    movb (%si), %al
    addw $1, %si
    cmpb $0, %al
    je fin
    movb $0x0e, %ah
    movw $15, %bx
    int $0x10
    jmp putloop
fin:
    hlt
    jmp fin
msg:
    .byte 0x0a, 0x0a
    .asciz "Hello world!\n"

    .fill 510 - (. - init), 1, 0
    .byte 0x55, 0xaa

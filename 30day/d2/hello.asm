; Bytes   Content
; 0-2     Jump to bootstrap (E.g. eb 3c 90; on i86: JMP 003E NOP.
;         One finds either eb xx 90, or e9 xx xx.
;         The position of the bootstrap varies.)
; 3-10    OEM name/version (E.g. "IBM  3.3", "IBM 20.0", "MSDOS5.0", "MSWIN4.0".
;         Various format utilities leave their own name, like "CH-FOR18".
;         Sometimes just garbage. Microsoft recommends "MSWIN4.1".)
;         /* BIOS Parameter Block starts here */
; 11-12   Number of bytes per sector (512)
;         Must be one of 512, 1024, 2048, 4096.
; 13      Number of sectors per cluster (1)
;         Must be one of 1, 2, 4, 8, 16, 32, 64, 128.
;         A cluster should have at most 32768 bytes. In rare cases 65536 is OK.
; 14-15   Number of reserved sectors (1)
;         FAT12 and FAT16 use 1. FAT32 uses 32.
; 16      Number of FAT copies (2)
; 17-18   Number of root directory entries (224)
;         0 for FAT32. 512 is recommended for FAT16.
; 19-20   Total number of sectors in the filesystem (2880)
;         (in case the partition is not FAT32 and smaller than 32 MB)
; 21      Media descriptor type (f0: 1.4 MB floppy, f8: hard disk; see below)
; 22-23   Number of sectors per FAT (9)
;         0 for FAT32.
; 24-25   Number of sectors per track (12)
; 26-27   Number of heads (2, for a double-sided diskette)
; 28-29   Number of hidden sectors (0)
;         Hidden sectors are sectors preceding the partition.
;         /* BIOS Parameter Block ends here */
; 30-509  Bootstrap
; 510-511 Signature 55 aa
; 
; The signature is found at offset 510-511. This will be the end of the sector
;   only in case the sector size is 512.

    org 0x7c00
    jmp entry               ; short jump (2 bytes)
	nop                     ; nop (1 bytes)
	db "bootset ";          ; boot sector name (8 bytes)
	dw 512                  ; sector size (2 bytes)
	db 1                    ; number of sectors per cluster (1 byte)
	dw 1                    ; number of reserved sectors (2 bytes)
	db 2                    ; number of FAT copis (1 byte)
	dw 224                  ; number of root dir entries (2 bytes)
	dw 2880                 ; number of sectors in filesystem (2 bytes)
	db 0xf0                 ; media descriptor type (1 byte)
	dw 9                    ; number of sectors per FAT (2 bytes)
	dw 18                   ; number of sectors per track (2 bytes)
	dw 2                    ; number of heads (2 bytes)
	dd 0                    ; number of hidden sectors, set to 0 (4 bytes)
	dd 2880                 ; disk size (4 bytes)
	db 0,0,0x29             ; ??
	dd 0xffffffff           ; ??
	db "Hello Boot "        ; disk name (11 bytes)
	db "FAT12   "           ; format name (8 bytes)


entry:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov sp, 0x7c00
    mov si, msg
putloop:
    mov al, [si]
    add si, 1
    cmp al, 0
    je fin
    mov ah, 0x0e
    mov bx, 15
    int 0x10
    jmp putloop
fin:
    hlt
    jmp fin
msg:
    db 0x0a, 0x0a
    db "Hello world!"
    db 0x0a
    db 0

    times 510 - ($ - $$) db 0
    db 0x55, 0xaa

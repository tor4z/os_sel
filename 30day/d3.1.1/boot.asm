CYLINDER equ 10             ; number of cylinder to read

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
    mov es, ax
    mov ds, ax
    mov sp, 0x7c00
    
    call putmsg     ; show init msg and return
readsector:
    mov ax, 0x0820  ; ?? target address
    mov es, ax      ; set es, ES:BX -> data buffer
    mov ch, 0       ; cylinder number
    mov dh, 0       ; header number
    mov cl, 2       ; sector number
readloop:
    mov si, 0       ; counting the number of tries
retry:
    mov ah, 0x02    ; indicate to read sectors into memory
    mov al, 1       ; number of sectors to read
    mov bx, 0       ; data buffer offset, ES:BX -> data buffer
    mov dl, 0x00    ; driver number
    int 0x13        ; perform read
    jnc next        ; carry not set, means success, jump to next
    add si, 1       ; retry_counter++
    cmp si, 5       ; retry_counter >= 5 ??
    jae error       ; jump to error if retry_counter >= 5
    mov ah, 0x00    ; reset disk system
    mov dl, 0x00    ; drive
    int 0x13        ; perform reset
    jmp retry       ; jump to retry
next:
    mov ax, es      ;
    add ax, 0x0020  ; 0x20 = 512 / 16
    mov es, ax      ; increase es by 0x0020
    add cl, 1       ; increace the sector number
    cmp cl, 18      ; if sector below and equal to 18
    jbe readloop    ; jump to readloop to read next sector
    mov cl, 1       ; reset sector number when read next side
    add dh, 1       ; increase head number
    cmp dh, 2       ; if head number below 2
    jb readloop     ; jump to readloop
    mov dh, 0       ; reset head number
    add ch, 1       ; incease cylinder number
    cmp ch, CYLINDER ; if cylinder number below CYLINDER
    jb readloop     ;  jump to readloop
    mov [0x0ff0], ch ; save current cylinder number to [0x0ff0]
    ; jmp success     ; jump
    jmp to_kernel  ; jump


putmsg:
    mov si, msg
putloop:
    mov al, [si]
    add si, 1
    cmp al, 0
    je putover
    mov ah, 0x0e
    mov bx, 10
    int 0x10
    jmp putloop
putover:
    ret

to_kernel:
    ; 0x4400: the kernel in disk
    ; 0x200: boot sector size
    ; 0x4200 = 0x4400 - 0x200
    ; jump into kernel
    jmp 0xc400  ; 0x820 * 0x10 + 0x4200
    ; hlt
    ; jmp fin

error:
    mov si, errormsg
errorloop:
    mov al, [si]
    add si, 1
    cmp al, 0
    je errorover
    mov ah, 0x0e
    mov bx, 10
    int 0x10
    jmp error
errorover:
    hlt
    jmp errorover

success:
    mov si, successmsg
successloop:
    mov al, [si]
    add si, 1
    cmp al, 0
    je successover
    mov ah, 0x0e
    mov bx, 10
    int 0x10
    jmp successloop
successover:
    hlt
    jmp successover

msg:
    db 0x0a
    db 0x0a
    db "Read disk"
    db 0x0a
    db 0

successmsg:
    db 0x0a
    db 0x0a
    db "Read disk success"
    db 0x0a
    db 0

errormsg:
    db 0x0a
    db 0x0a
    db "error read disk"
    db 0x0a
    db 0

    times 510 - ($ - $$) db 0
    db 0x55, 0xaa

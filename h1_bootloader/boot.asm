	org 07c00h		; Load the code to 0x07c00 in memory
	mov ax, cs		; 
	mov ds, ax		; Set the value of es, ds to the value of cs
	mov es, ax		;

	;; Call function
	call DispStr
	;; Infinite loop
	jmp $
	
DispStr:
	;; AL = Write mode, BH = Page Number, BL = Color, CX = String length,
	;; DH = Row, DL = Column, ES:BP = Offset of string
	mov ax, BootMessage
	mov bp, ax		; ES:BP = String Address
	mov cx, 16		; CX = String Length
	mov ax, 01301h		; AH = 13h, AL = 01h (Write mode)
	mov bx, 000ch		; BH = 00h, BL = 0Ch, Set page = 0, color = red
	mov dl, 0		; Set column
	int 10h
	ret

BootMessage:
	db "Hello, OS world!"	; The message to print

	times 510 - ($ - $$) db 0 ; fill 0 in the rest of space
	dw 0xaa55		  ; fill 0xaa55 in the latest 2 byte
	

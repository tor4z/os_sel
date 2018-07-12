;;;==================================
;;; pm1.asm
;;; nasm pm1.asm -0 pm1.o
;;;=================================
	
	%include "pm.inc"	; Include pm
	org 0100h
	jmp LABEL_BEGIN
	
	[SECTION .gdt]
LABEL_GDT:
	;;         Base		Limit			Attribute
	Descriptor 0, 		0, 			0 ; NULL description
LABEL_DESC_CODE32:
	Descriptor 0, 		SegCode32Len - 1, 	DA_C + DA_32 
LABEL_DESC_VIDEO:
	Descriptor 0b8000h, 	0ffffh, 		DA_DRW ; Video memory address

	
GdtLen 		equ 	$ - LABEL_GDT ; Lenght of GDT
GdtPtr 		dw  	GdtLen - 1    ; GDT Limit
		dd	0	      ; GDT Base, to be fill

;; GDT Selector
SelectorCode32	equ LABEL_DESC_CODE32 - LABEL_GDT
SelectorVideo	equ LABEL_DESC_VIDEO - LABEL_GDT

	;; End of [SECTION .gdt]

	
	[SECTION .s16]
	[BITS 16]
LABEL_BEGIN:
	;; Reload data segment register
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0100h

	;; Initialize 32-bit segment description
	xor eax, eax
	mov ax, cs
	shl eax, 4
	add eax, LABEL_SEG_CODE32
	mov word [LABEL_DESC_CODE32 + 2], ax
	shr eax, 16
	mov byte [LABEL_DESC_CODE32 + 4], al
	mov byte [LABEL_DESC_CODE32 + 7], ah

	;; Prepare to load GDTR
	xor eax, eax
	mov ax, ds
	shl eax, 4
	add eax, LABEL_GDT	; Add GDT base to EAX, segment * 16 + offset
	mov dword [GdtPtr + 2], eax ; Set GDT Base to [GdtPr + 2]

	lgdt [GdtPtr]		; Load GDTR
	cli			; Close interrupt

	;; Enable A20
	in al, 92h
	or al, 00000010b
	out 92h, al

	;; Prepare to Switch to protected mode
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	;; Switch to protected mode
	jmp dword SelectorCode32:0

	;; End of [SECTION .s16]


	[SECTION .s32]
	[BITS 32]
LABEL_SEG_CODE32:
	mov ax, SelectorVideo
	mov gs, ax		; Set Video Selector as destination segment

	mov edi, (80 * 11 + 79) * 2 ; line 11 and row 79 in the screen
	mov ah, 0ch		    ; 0000:black background, 1100:red font color
	mov al, 'P'
	mov [gs:edi], ax
	jmp $

SegCode32Len	equ $ - LABEL_SEG_CODE32
	;; End of [SECTION .s32]

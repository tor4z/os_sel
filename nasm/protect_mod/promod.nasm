%include "pro_inc.nasm"

org 07c00h
jmp LB_BEGIN

; [SECTION .gdt]

LB_GDT: Descriptor 0, 0, 0
LB_DESC_CODE32: Descriptor 0, SegCode32Len - 1, DA_C + DA_32
LB_DESC_VIDEO: Descriptor 0B8000h, 0FFFFh, DA_DRW


GdtLen equ $ - LB_GDT
GdtPtr dw GdtLen - 1
       dd 0

SelectorCode32 equ LB_DESC_CODE32 - LB_GDT
SelectorVideo  equ LB_DESC_VIDEO - LB_GDT


SECTION .s16
[BITS 16]
LB_BEGIN:
    mov ax, cs
    mov ds, ax
    mov ss, ax
    mov sp, 0100h

    xor eax, eax
    mov ax, cs
    shl eax, 4
    add eax, LB_SEG_CODE32
    mov word [LB_DESC_CODE32 + 2], ax
    mov eax, 00000010h
    mov byte [LB_DESC_CODE32 + 4], al
    mov byte [LB_DESC_CODE32 + 7], ah

    xor eax, eax
    mov ax, ds
    shl eax, 4
    add eax, LB_GDT
    mov dword [GdtPtr + 2], eax

    lgdt [GdtPtr]

    cli

    in al, 92h
    or al, 00000010b
    out 92h, al

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp dword SelectorCode32:0

SECTION .s32
[BITS 32]
LB_SEG_CODE32:
    mov ax, SelectorVideo
    mov gs, ax

    mov edi, (80 * 11 + 79) * 2
    mov ah, 0ch
    mov al, 'X'
    mov [gs:edi], ax

    jmp $


SegCode32Len equ $ - LB_SEG_CODE32


times 510 - ($-$$) db 0
dw 0xaa55

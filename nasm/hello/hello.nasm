[SECTION .s32]
[BITS 16]
    org 07c00h
    mov ax, cs
    mov ds, ax
    mov es, ax
    call DispStr
    jmp $

DispStr:
    mov ax, BootMsg
    mov bp, ax
    mov cx, 16
    mov ax, 01301h
    mov bx, 000ch
    mov dl, 0
    int 10h
    ret

[SECTION .s32]
[BITS 32]
    mov eax, 16

BootMsg:
    db "Hello World"
    times 510 - ($-$$) db 0
    dw 0xaa55

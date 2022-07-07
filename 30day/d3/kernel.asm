    org 0xc400
printmsg:
    mov si, kmsg
printloop:
    mov al, [si]
    add si, 1
    cmp al, 0
    je fin
    mov ah, 0x0e
    mov bx, 10
    int 0x10
    jmp printloop
fin:
    hlt
    jmp fin

kmsg:
    db 0x0a
    db 0x0a
    db "The kernel."
    db 0x0a
    db 0

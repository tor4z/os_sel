CYLINDER equ 0x0ff0
LEDS     equ 0x0ff1
VMODE    equ 0x0ff2
SCRNX    equ 0x0ff4
SCRNY    equ 0x0ff6
VRAM     equ 0x0ff8

    org 0xc400
    bits 16
setup:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; mov ah, 0x00    ; set video mode
    ; mov al, 0x13    ; VGA graphic mode, 320*200*8 color mode
    ; int 0x10        ; perform set video mode

    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov byte [VMODE], 8
    mov word [SCRNX], 320
    mov word [SCRNY], 200
    mov dword [VRAM], 0x000a0000

    mov ah, 0x02
    int 0x16
    mov [LEDS], al

    mov al, 0xff
    out 0x21, al
    nop
    out 0xa1, al
    cli

    call wait_kb_out
    mov al, 0xd1
    out 0x64, al
    call wait_kb_out
    mov al, 0xdf
    out 0x60, al
    call wait_kb_out

    lgdt [GDTR0]
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    ; Perform a jump instruct immediately after set the protect bit of cr0
    ; set CS register to 0x08 automatically
    jmp dword 0x08:protect_mod

    bits 32
protect_mod:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov ebx, 0xb8000
    mov ecx, 8
printmsg_loop:
    mov al, '!'
    mov ah, 0x0f
    mov [ebx], ax
    add ebx, 2
    sub ecx, 1
    cmp ecx, 0x0
    je printmsg_fin
    jmp printmsg_loop
printmsg_fin:
    hlt
    jmp printmsg_fin

puts:
    mov al, 0x41
    mov ah, 0x0e
    mov bx, 10
    int 0x10    ; only in real mode
    jmp $


wait_user:
    hlt
    jmp wait_user

    bits 16
wait_kb_out:
    in al, 0x64
    test al, 0x02
    jnz wait_kb_out
    ret

db "MAER GDT0 BEGIN"

    align 16
GDT0:
    dw 0x0000, 0x0000, 0x0000, 0x0000   ; null
    ; base=0x0, limit=0xfffff, access=0x92, flag=0xc
    dw 0xffff, 0x0000, 0x9a00, 0x00cf   ; code
    ; base=0x0, limit=0xfffff, access=0x9a, flag=0x4
    dw 0xffff, 0x0000, 0x9200, 0x00cf   ; data
    dw 0x0000, 0x0000, 0x0000, 0x0000   ; task, not used

GDTR0:
    dw 4 * 8 - 1
    dd GDT0

db "MAER END"

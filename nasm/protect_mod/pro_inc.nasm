DA_32 equ 4000h

DA_DPL0 equ 00h
DA_DPL1 equ 20h
DA_DPL2 equ 40h
DA_DPL3 equ 60h

DA_DR equ 90h
DA_DRW equ 92h
SAD_DRWA equ 93h
DA_C equ 98h
DA_CR equ 9Ah
DA_CCO equ 9Ch
DA_CCOR equ 9Eh

DA_LDT equ 82h
DA_TASKGATE equ 85h
DA_386TSS equ 89h
DA_386GATE equ 8Ch
DA_386IGATE equ 8Eh
DA_386TGATE equ 8Fh


SA_RPL0 equ 0
SA_RPL1 equ 1
SA_RPL2 equ 2
SA_RPL3 equ 3

SA_TIG equ 0
SA_TIL equ 4


; base   dd
; limit  dd
; attr   dw
%macro Descriptor 3
              ; 16 bit
    dw %2 & 0FFFFh                          ; segment bound 1
    dw %1 & 0FFFFh                          ; seg base 1
    db (%1 >> 16) & 0FFFFh                  ; seg base 2
    dw ((%2 >> 8) & 0F00h) | (%3 & 0F0FFh)  ; property1 + seg bound 2 + property 2
                    ; 8 bit
    db (%1 >> 24) & 0FFh                    ; seg base 3
%endmacro

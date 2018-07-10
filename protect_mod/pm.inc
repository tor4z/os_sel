;;; Usage Descriptor Base Limit Attr
;;; Base: dd
;;; Limit: dd (low 20 bit available)
;;; Attr: dw (lower 4 bit of height byte are always 0)
;;;

DA_32	equ 4000h
DA_C	equ 98h
DA_DRW	equ 92h

%macro Descriptor 3
       dw %2 & 0ffffh				; Segment base 1
       dw %1 & 0ffffh				; Segment limit 1
       db (%1 >> 16) & 0ffh			; Segment base 2
       dw ((%2 >> 8) & 0f00h) | (%3 & 0f0ffh)	; Attribute 1 + Segment limit 2 + Attribute 2
       db (%1 >> 24) & 0ffh   	      		; Segment base 3
%endmacro
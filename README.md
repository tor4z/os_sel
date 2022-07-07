# OS SEL

### Boot INT

INT 0x10 is used for screen manipulation

```
print a char
AH = 0Eh
AL = character to write
BH = page number, 0
BL = foreground color (graphics modes only)
```

INT 0x13 is for storage (HDD and FDD)

```
== DISK - RESET DISK SYSTEM ==
AH = 00h
DL = drive (if bit 7 is set both hard disks and floppy disks reset)
== Return:
AH = status (see #00234)
CF clear if successful (returned AH=00h)
CF set on error
```

```
== read sectors into memory ==
AH = 02h
AL = number of sectors to read (must be nonzero)
CH = low eight bits of cylinder number
CL = sector number 1-63 (bits 0-5)
high two bits of cylinder (bits 6-7, hard disk only)
DH = head number
DL = drive number (bit 7 set for hard disk)
ES:BX -> data buffer
== return 
CF set on error
if AH = 11h (corrected ECC error), AL = burst length
CF clear if successful
AH = status (see #00234)
AL = number of sectors transferred (only valid if CF set for some
BIOSes)
```

```
== write disk sectors ==
AH = 03h
AL = number of sectors to write (must be nonzero)
CH = low eight bits of cylinder number
CL = sector number 1-63 (bits 0-5)
high two bits of cylinder (bits 6-7, hard disk only)
DH = head number
DL = drive number (bit 7 set for hard disk)
ES:BX -> data buffer
```

```
== VERIFY DISK SECTOR(S) ==
AH = 04h
AL = number of sectors to verify (must be nonzero)
CH = low eight bits of cylinder number
CL = sector number 1-63 (bits 0-5)
high two bits of cylinder (bits 6-7, hard disk only)
DH = head number
DL = drive number (bit 7 set for hard disk)
ES:BX -> data buffer (PC,XT,AT with BIOS prior to 1985/11/15)
```

```
== HARD DISK - SEEK TO CYLINDER ==
AH = 0Ch
CH = low eight bits of cylinder number
CL = sector number (bits 5-0)
high two bits of cylinder number (bits 7-6)
DH = head number
DL = drive number (80h = first, 81h = second hard disk)
```
	
INT 0x16 is for Keyboard control and read:

- AH=0x00 -> GetKey
- AH=0x03 -> Set typematic rate and delay

You can find all these functions here:
[Interrupt Jump Table](http://www.ctyme.com/intr/int.htm)


## Registers

Only BX BP SI DI registers can be use to store address. AX, CX, Dx, SP can not be use to hold address.

```

AX: accumulator
CX: counter
DX: data
BX: base
SP: stack pointer
BP: base pointer
SI: source index
DI: destination index

--segment registers

EX: extra segment
CS: code segment
SS: stack segment
DS: data segment
FS: segment part2
GS: segment part5
```

### Data segment register

System use DS as the default data segment register,
when we write `MOV CX, [1234]`, which is interpreted as
`MOV CX, [DS:1234]`. `MOV AL, [SI]` can be interpreted
as `MOV AL, [DS:SI]`.

Hence, we set DS to 0, before we load or store data
from memory.


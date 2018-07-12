# OS SEL

### Boot INT

INT 0x10 is used for screen manipulation

- AH=0x00 -> set video mode
- AX=0x1003 -> Set Blinking mode
- AH=0x13 -> write string
- AH=0x03 -> get cursor position

INT 0x13 is for storage (HDD and FDD)

- AH=0x42 -> DISK READ
- AH=0x43 -> DISK WRITE
	
INT 0x16 is for Keyboard control and read:

- AH=0x00 -> GetKey
- AH=0x03 -> Set typematic rate and delay

You can find all these functions here:
[Interrupt Jump Table}(http://www.ctyme.com/intr/int.htm)
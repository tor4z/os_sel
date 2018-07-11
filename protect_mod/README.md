# Protected Mode

### Addressing

`Physical Address = Segment * 16 + Offset`


### GDT

The GDT table contains a number of entries called Segment Descriptors.
Each is 8 bytes long and contains information on the starting point of
the segment, the length of the segment, and the access rights of the
segment.

The following NASM-syntax code represents a single GDT entry:

```nasm
struc gdt_entry_struct

        limit_low:   resb 2
        base_low:    resb 2
        base_middle: resb 1
        access:      resb 1
        granularity: resb 1
        base_high:   resb 1

endstruc
```

How to get into protected mode? First, you need a GLOBAL DESCRIPTOR
TABLE (GDT). There is one at the end of this file, at address "gdt:"
The GDT contains 8-byte DESCRIPTORS for each protected-mode segment.
Each descriptor contains a 32-bit segment base address, a 20-bit segment
limit, and 12 bits describing the segment type. The descriptors look
like this:
```
           MSB    bit 6   bit 5   bit 4   bit 3   bit 2   bit 1   LSB
        +-------+-------+-------+-------+-------+-------+-------+-------+
byte 0  | bit 7<---------------- segment limit------------------->bit 0 |
        +-------+-------+-------+-------+-------+-------+-------+-------+

        +-------+-------+-------+-------+-------+-------+-------+-------+
byte 1  |bit 15<---------------- segment limit------------------->bit 8 |
        +-------+-------+-------+-------+-------+-------+-------+-------+

        +-------+-------+-------+-------+-------+-------+-------+-------+
byte 2  | bit 7<---------------- segment base-------------------->bit 0 |
        +-------+-------+-------+-------+-------+-------+-------+-------+

        +-------+-------+-------+-------+-------+-------+-------+-------+
byte 3  |bit 15<---------------- segment base-------------------->bit 8 |
        +-------+-------+-------+-------+-------+-------+-------+-------+

        +-------+-------+-------+-------+-------+-------+-------+-------+
byte 4  |bit 23<---------------- segment base-------------------->bit 16|
        +-------+-------+-------+-------+-------+-------+-------+-------+

        +-------+-------+-------+-------+-------+-------+-------+-------+
byte 5  |   P   |      DPL      | <----------- segment type ----------> |
        +-------+-------+-------+-------+-------+-------+-------+-------+
```
P is the Segment Present bit. It should always be 1.

DPL is the DESCRIPTOR PRIVILEGE LEVEL. For simple code like this, these
two bits should always be zeroes.

Segment Type (again, for simple code like this) is hex 12 for data
segments, hex 1A for code segments.
```
        +-------+-------+-------+-------+-------+-------+-------+-------+
byte 6  |   G   |   B   |   0   | avail | bit 19<-- seg limit--->bit 16 |
        +-------+-------+-------+-------+-------+-------+-------+-------+
```
G is the Limit Granularity. If zero, the segment limit is in bytes
(0 to 1M, in 1-byte increments). If one, the segment limit is in 4K PAGES
(0 to 4G, in 4K increments). For simple code, set this bit to 1, and
set the segment limit to its highest value (FFFFF hex). You now have
segments that are 4G in size! The Intel CPUs can address no more than
4G of memory, so this is like having no segments at all. No wonder
protected mode is popular.

B is the Big bit; also called the D (Default) bit. For code segments,
all instructions will use 32-bit operands and addresses by default
(BITS 32, in NASM syntax, USE32 in Microsoft syntax) if this bit is set.
16-bit protected mode is not very interesting, so set this bit to 1.

None of these notes apply to the NULL descriptor. All of its bytes
should be set to zero.
```
        +-------+-------+-------+-------+-------+-------+-------+-------+
byte 7  |bit 31<---------------- segment base------------------->bit 24 |
        +-------+-------+-------+-------+-------+-------+-------+-------+
```
Build a simple GDT with four descriptors: NULL (all zeroes), linear data
(lets you use 32-bit addresses), code, and data/stack. (An extra
descriptor or two is needed to return to real mode.) For simplicity,
the limits of all descriptors (except NULL and the real-mode descriptors)
are FFFFF hex, the largest possible limit.

In a real-mode .COM file, CS=DS. To make addressing identical in real
mode and protected mode, we set the base of the code and data descriptors
to DS * 16. This number is computed at run-time; the other numbers in
the GDT can be done at assemble-time.


### Fast A20 Gate

```nasm
in al, 0x92
or al, 2
out 0x92, al
```
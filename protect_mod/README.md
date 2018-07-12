# Protected Mode


### Step to entering protected mode

1. Prepare for GDT
2. Load GDTR with lgdt
3. Enable A20
4. Set PE of cr0 to 1
5. Jump and enter protected mode


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
byte 5  |   P   |      DPL      |   S   |<---- segment type --->|   A   |
        +-------+-------+-------+-------+-------+-------+-------+-------+
	  |           |              |        |                     |
	  |           |              |        |   A=0, Segment not accessed
	  |           |              |        |   A=1, Segment has been accessed
	  |  Set the desc. privilege |        +---------------+
	  |  level                   |                        |
	  |                          S=0, System descriptor   |
	  |                          S=1, Code, dtaa or stack |
  P=0, descriptor is undifined.                               |
  P=1, descriptor contain a valid            000 Data, read-only
       base and limit                        001 Data, read/write
       
       	    				     010 Stack read-only
					     011 Stack read/write
					
					     100 Code execute-only
  					     101 Code execute/read
					
					     110 Code execute-only, conforming
					     111 Code execute/read, conforming

http://ece-research.unm.edu/jimp/310/slides/micro_arch2.html
```
P is the Segment Present bit. It should always be 1.
When P is 1 mean segment in the memory, else if P is 0 mean segment
is not in the memory.

DPL is the DESCRIPTOR PRIVILEGE LEVEL. For simple code like this, these
two bits should always be zeroes.
The bigger of DPL value mean the privilege is lower.

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


### GDTR [See also](https://en.wikibooks.org/wiki/X86_Assembly/Global_Descriptor_Table)

The GDT is pointed to by a special register in the x86 chip, the GDT
Register, or simply the GDTR. The GDTR is 48 bits long. The lower
16 bits tell the size of the GDT, and the upper 32 bits tell the location
of the GDT in memory. Here is a layout of the GDTR:
```
0   15 16         47
|LIMIT|----BASE----|
```
LIMIT is the size of the GDT, and BASE is the starting address. LIMIT
is 1 less than the length of the table, so if LIMIT has the value 15,
then the GDT is 16 bytes long.

To load the GDTR, the instruction LGDT is used:
```nasm
lgdt [gdtr]
```
Where gdtr is a pointer to 6 bytes of memory containing the desired GDTR value.
Note that to complete the process of loading a new GDT, the segment registers
need to be reloaded. The CS register must be loaded using a far jump:
```nasm
flush_gdt:
    lgdt [gdtr]
    jmp 0x08:complete_flush	; 0x08 points at the new code selector
 
complete_flush:
    ;; Reload data segment register
    mov ax, 0x10		; 0x10 points at the new data selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    ret
```

### LDT [See also](https://wiki.osdev.org/GDT_Tutorial#What.27s_so_special_about_the_LDT.3F)

Much like the GDT (global descriptor table), the LDT (local descriptor table)
contains descriptors for memory segments description, call gates, etc. The good
thing with the LDT is that each task can have its own LDT and that the processor
will automatically switch to the right LDT when you use hardware task switching.

Since its content may be different in each task, the LDT is not a suitable place
to put system stuff such as TSS or other LDT descriptors: Those are the sole
property of the GDT. Since it is meant to change often, the command used for
loading an LDT is a bit different from the GDT and IDT loading. Rather than
giving directly the LDT's base address and size, those parameters are stored
in a descriptor of the GDT (with proper "LDT" type) and the selector of that
entry is given. 
```
               GDTR (base + limit)
              +-- GDT ------------+
              |                   |
SELECTOR ---> [LDT descriptor     ]----> LDTR (base + limit)
              |                   |     +-- LDT ------------+
              |                   |     |                   |
             ...                 ...   ...                 ...
              +-------------------+     +-------------------+

```


###  Prepare to Switch to protected mode, Set PE to 1

The CR0 register is 32 bits long on the 386 and higher processors. On x86-64
processors in long mode, it (and the other control registers) is 64 bits
long. CR0 has various control flags that modify the basic operation of the
processor.

|Bit 	|Name 	|Full Name                  |Description|
|-------|-------|---------------------------|-----------|
|0 	|PE 	|Protected Mode Enable 	    |If 1, system is in protected mode, else system is in real mode
|1 	|MP 	|Monitor co-processor 	    |Controls interaction of WAIT/FWAIT instructions with TS flag in CR0
|2 	|EM 	|Emulation 	            |If set, no x87 floating point unit present, if clear, x87 FPU present
|3 	|TS 	|Task switched 	            |Allows saving x87 task context upon a task switch only after x87 instruction used
|4 	|ET 	|Extension type 	    |On the 386, it allowed to specify whether the external math coprocessor was an 80287 or 80387
|5 	|NE 	|Numeric error 	            |Enable internal x87 floating point error reporting when set, else enables PC style x87 error detection
|16 	|WP 	|Write protect 	            |When set, the CPU can't write to read-only pages when privilege level is 0
|18 	|AM 	|Alignment mask 	    |Alignment check enabled if AM set, AC flag (in EFLAGS register) set, and privilege level is 3
|29 	|NW 	|Not-write through 	    |Globally enables/disable write-through caching
|30 	|CD 	|Cache disable 	            |Globally enables/disable the memory cache
|31 	|PG 	|Paging 	            |If 1, enable paging and use the CR3 register, else disable paging


```
 31 30 29                   19 18 17 16                  6 5  4  3  2  1  0
+--+--+--+--------------------+--+--+--+------------------+--+--+--+--+--+--+
|PG|CD|NW|                    |AM|  |WP|                  |NE|ET|TS|EM|MP|PE|
+--+--+--+--------------------+--+--+--+------------------+--+--+--+--+--+--+

				cr0 register
```

```nasm
mov eax, cr0
or eax, 1	; Set PE to 1
mov cr0, eax
```

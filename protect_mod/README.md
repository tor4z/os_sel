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

### Fast A20 Gate

```nasm
in al, 0x92
or al, 2
out 0x92, al
```
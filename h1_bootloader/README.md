# BootLoader

### The Bootsector

The first 512 bytes of a disk are known as the bootsector or Master Boot
Record. The boot sector is an area of the disk reserved for booting
purposes. If the bootsector of a disk contains a valid boot sector (the
last word of the sector must contain the signature 0xAA55), then the disk is
treated by the BIOS as bootable.


### INT 01H

List of supported functions [See also](https://en.wikipedia.org/wiki/INT_10H)

### Technical Details

A bootloader runs under certain conditions that the programmer must appreciate
in order to make a successful bootloader. The following pertains to
bootloaders initiated by the PC BIOS:

1. The first sector of a drive contains its boot loader.
2. One sector is 512 bytes — the last two bytes of which must be 0xAA55
(i.e. 0x55 followed by 0xAA), or else the BIOS will treat the drive as
unbootable.
3. If everything is in order, said first sector will be placed at RAM address
0000:7C00, and the BIOS's role is over as it transfers control to 0000:7C00
(that is, it JMPs to that address).
4. The DL register will contain the drive number that is being booted from,
useful if you want to read more data from elsewhere on the drive.
5. The BIOS leaves behind a lot of code, both to handle hardware interrupts
(such as a keypress) and to provide services to the bootloader and OS (such
as keyboard input, disk read, and writing to the screen). You must understand
the purpose of the Interrupt Vector Table (IVT), and be careful not to
interfere with the parts of the BIOS that you depend on. Most operating
systems replace the BIOS code with their own code, but the boot loader can't
use anything but its own code and what the BIOS provides. Useful BIOS services
include int 10h (for displaying text/graphics), int 13h (disk functions) and
int 16h (keyboard input).
6. This means that any code or data that the boot loader needs must either be
included in the first sector (be careful not to accidentally execute data) or
manually loaded from another sector of the disk to somewhere in RAM. Because
the OS is not running yet, most of the RAM will be unused. However, you must
take care not to interfere with the RAM that is required by the BIOS interrupt
handlers and services mentioned above.
7. The OS code itself (or the next bootloader) will need to be loaded into RAM
as well.
8. The BIOS places the stack pointer 512 bytes beyond the end of the boot
sector, meaning that the stack cannot exceed 512 bytes. It may be necessary
to move the stack to a larger area.
9. There are some conventions that need to be respected if the disk is to be
readable under mainstream operating systems. For instance you may wish to
include a BIOS Parameter Block on a floppy disk to render the disk readable
under most PC operating systems.

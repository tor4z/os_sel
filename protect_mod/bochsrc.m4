# Configure flie for Bochs

# How mach the memory the emulated machine will have
megs: 32

# Filename of ROM images
romimage: file=_romimage
vgaromimage: file=_vgaromimage


# What disk image will be use
floppya: 1_44=a.img, status=inserted

# Choose the boot disk
boot: floppy

# Where do we send the log message
log: bochs.log

# Disable the mouse
mouse: enabled=0

# Enable key mapping, using the US keyboard layout as default
keyboard: keymap=_keymap
keyboard: user_shortcut=ctrl-alt-del

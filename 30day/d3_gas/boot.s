    .set CYLINDER, 10

    .code16
    .section .text
    .global boot_start
boot_start:
    jmp entry
    nop
    .ascii "bootset "
    .short 512
    .byte 1
    .short 1
    .byte 2
    .short 224
    .short 2880
    .byte 0xf0
    .short 9
    .short 18
    .short 2
    .int 0
    .byte 0, 0, 0x29
    .int 0xffffffff
    .ascii "Hello Boot "
    .ascii "FAT12   "

entry:
    movw $0, %ax
    movw %ax, %ss
    movw %ax, %es
    movw %ax, %ds
    movw $0x7c00, %sp 

    leaw init_msg, %si
    call print_string

read_sector:
    movw $0x0820, %ax
    movw %ax, %es       # es:bx data buffer address
    movb $0, %ch        # height bit of cylinder number
    movb $0, %dh        # head number
    movb $2, %cl        # sector number (0-5 bits), cylinder number (6-7 bits)
read_loop:
    movw $0, %si        # retry counter
read_retry:
    ###############
    # Read sector #
    ###############
    movb $0x02, %ah     # read sector
    movb $1, %al        # the number of sector to read, we just read one sector once here.
    movw $0, %bx        # data buffer offset
    movb $0x00, %dl     # driver number
    int $0x13           # perform read
    ########################
    # Increase retry times #
    ########################
    jnc read_next
    addw $1, %si        # retry_times++
    cmpw $5, %si        # if retry_times > 5
    jae read_error      # and then jump to error
    #######################
    # Reset sector reader #
    #######################
    xorb %ah, %ah       # reset sector reader (seek 0)
    xorb %dl, %dl       # driver number
    int $0x13           # perform reset
    jmp read_retry
read_next:
    movw %es, %ax
    addw $0x20, %ax
    movw %ax, %es
    addb $1, %cl        # increase the sector number
    cmpb $18, %cl       # max sector number is 18
    jbe read_loop       # if sector number below to sector number, we jump to the begining of sector reader.
    movb $1, %cl        # reset the sector number, anf prepare to read next side
    addb $1, %dh
    cmpb $2, %dh
    jb read_loop
    movb $0, %dh
    addb $1, %ch
    cmpb $CYLINDER, %ch
    jb read_loop
    movb %ch, (0x0ff0)
    jmp prepare_loader

#############################################################
# If we failed to read disk, we print some message and wait #
# user to manipulating the situation.                       #
#############################################################
read_error:
    leaw read_fail_msg, %si
    call print_string
read_error_finished:
    hlt
    jmp read_error_finished

#
# 
#
prepare_loader:
    # jmp 0xc400
    hlt
    jmp prepare_loader
    call jump_to_loader_msg


# @function: print a string
# @parameter: the address of string, stored in si register
# @return: 
    .type print_string, @function
print_string:
    movb (%si), %al
    addw $1, %si
    cmp $0, %al
    je print_string_ret
    movb $0x0e, %ah
    movw $10, %bx
    int $0x10
    jmp print_string 
print_string_ret:
    ret


init_msg:
    .asciz "Init boot\n"
read_success_msg:
    .asciz "Read disk success\n"
read_fail_msg:
    .asciz "Read disk fail\n"
jump_to_loader_msg:
    .asciz "Ready to jump to loader\n"

    #         repeat           size value
    .fill 510 - (. - boot_start), 1, 0       # fill rest space
    .byte 0x55, 0xaa                        # a bootable device *MUST* end with 0x55aa

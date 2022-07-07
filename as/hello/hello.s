.global _start

.text
_start:
    # write(1, msg, 13)
    mov $1, %rax    # syscall 1 is write
    mov $1, %rdi    # stdout
    mov $msg, %rsi  # string address
    mov $len, %rdx  # invoke syscall
    syscall

    mov $60, %rax   # syscall 60 is exit()
    xor %rdi, %rdi  # return 0
    syscall

msg:
    .ascii "Hello world\n"
    len = . - msg

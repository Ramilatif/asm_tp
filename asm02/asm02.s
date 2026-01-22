global _start

%define SYS_read   0
%define SYS_write  1
%define SYS_exit   60

section .rodata
msg:    db "1337", 10
len:    equ $ - msg

section .bss
buf:    resb 128

section .text
_start:
    ; read(0, buf, 128)
    mov     rax, SYS_read                 ; read 
    mov     rdi, 0                        ; stdin
    lea     rsi, [rel buf]                ; &buf (RIP-relative) 
    mov     rdx, 128
    syscall

    cmp     rax, 2
    je      .check2
    cmp     rax, 3
    je      .check3
    jmp     .exit

.check2:
    cmp     byte [rel buf + 0], '4'
    jne     .exit1
    cmp     byte [rel buf + 1], '2'
    jne     .exit1
    jmp     .win

.check3:
    cmp     byte [rel buf + 0], '4'
    jne     .exit1
    cmp     byte [rel buf + 1], '2'
    jne     .exit1
    cmp     byte [rel buf + 2], 10        ; '\n'
    jne     .exit1
    jmp     .win

.win:
    ; write(1, msg, len)
    mov     rax, SYS_write                ; write 
    mov     rdi, 1                        ; stdout
    lea     rsi, [rel msg]
    mov     rdx, len
    syscall

.exit:
    ; exit(0)
    mov     rax, SYS_exit                 ; exit 
    mov     rdi, 0
    syscall

.exit1: 
    mov     rax, SYS_exit
    mov     rdi, 1
    syscall

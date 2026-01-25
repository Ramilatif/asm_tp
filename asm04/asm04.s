global _start
default rel

%define SYS_read   0
%define SYS_exit   60

section .bss
buf:    resb 128

section .text
_start:
    mov     rax, SYS_read
    mov     rdi, 0
    lea     rsi, [buf]
    mov     rdx, 128
    syscall

    test    rax, rax
    jle     .bad2

    xor     rcx, rcx

    xor     r9d, r9d

.loop:
    cmp     rcx, rax
    jae     .end_check

    mov     bl, [buf + rcx]
    cmp     bl, 10
    je      .end_check

    cmp     bl, '0'
    jb      .bad2
    cmp     bl, '9'
    ja      .bad2

    mov     r8b, bl
    mov     r9d, 1

    inc     rcx
    jmp     .loop

.end_check:
    test    r9d, r9d
    jz      .bad2

    cmp     r8b, '0'
    je      .even
    cmp     r8b, '2'
    je      .even
    cmp     r8b, '4'
    je      .even
    cmp     r8b, '6'
    je      .even
    cmp     r8b, '8'
    je      .even

    mov     rdi, 1
    jmp     .exit

.even:
    xor     rdi, rdi

.exit:
    mov     rax, SYS_exit
    syscall

.bad2:
    mov     rdi, 2
    jmp     .exit


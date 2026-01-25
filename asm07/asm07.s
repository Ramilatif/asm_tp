global _start
default rel

%define SYS_read  0
%define SYS_exit  60

section .bss
buf:    resb 64

section .text
_start:
    mov     rax, SYS_read
    mov     rdi, 0
    lea     rsi, [buf]
    mov     rdx, 64
    syscall

    test    rax, rax
    jle     .not_prime

    xor     rcx, rcx
    xor     rbx, rbx

.parse:
    mov     dl, [buf + rcx]
    cmp     dl, 10
    je      .parsed
    cmp     dl, '0'
    jb      .not_prime
    cmp     dl, '9'
    ja      .not_prime
    imul    rbx, rbx, 10
    sub     dl, '0'
    add     rbx, rdx
    inc     rcx
    jmp     .parse

.parsed:
    cmp     rbx, 2
    jb      .not_prime
    cmp     rbx, 2
    je      .prime

    mov     rcx, 2

.test:
    mov     rax, rbx
    xor     rdx, rdx
    div     rcx
    test    rdx, rdx
    je      .not_prime
    inc     rcx
    mov     rax, rcx
    mul     rcx
    cmp     rax, rbx
    jbe     .test

.prime:
    mov     rax, SYS_exit
    xor     rdi, rdi
    syscall

.not_prime:
    mov     rax, SYS_exit
    mov     rdi, 1
    syscall


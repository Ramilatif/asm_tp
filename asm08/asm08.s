global _start
default rel

%define SYS_write 1
%define SYS_exit  60

section .bss
outbuf: resb 64

section .text
_start:
    mov     rbx, rsp
    mov     rax, [rbx]
    cmp     rax, 2
    jne     .exit0

    mov     rsi, [rbx + 16]
    xor     rax, rax

.parse:
    mov     dl, [rsi]
    test    dl, dl
    je      .parsed
    sub     dl, '0'
    cmp     dl, 9
    ja      .exit0
    imul    rax, rax, 10
    add     rax, rdx
    inc     rsi
    jmp     .parse

.parsed:
    cmp     rax, 1
    jbe     .print_zero

    dec     rax
    mov     rcx, rax
    inc     rax
    imul    rax, rcx
    shr     rax, 1
    jmp     .print

.print_zero:
    xor     rax, rax

.print:
    lea     rdi, [outbuf + 63]
    mov     byte [rdi], 10
    dec     rdi
    xor     rcx, rcx

    test    rax, rax
    jne     .conv
    mov     byte [rdi], '0'
    dec     rdi
    inc     rcx
    jmp     .write

.conv:
    xor     rdx, rdx
    mov     r8, 10
    div     r8
    add     dl, '0'
    mov     [rdi], dl
    dec     rdi
    inc     rcx
    test    rax, rax
    jne     .conv

.write:
    lea     rsi, [rdi + 1]
    mov     rdx, rcx
    inc     rdx
    mov     rax, SYS_write
    mov     rdi, 1
    syscall

.exit0:
    mov     rax, SYS_exit
    xor     rdi, rdi
    syscall


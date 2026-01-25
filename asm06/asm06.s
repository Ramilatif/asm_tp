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
    cmp     rax, 3
    jne     .exit0

    mov     rsi, [rbx + 16]
    call    atoi_u64
    mov     r8, rax

    mov     rsi, [rbx + 24]
    call    atoi_u64

    add     rax, r8

    lea     rdi, [outbuf + 63]
    mov     byte [rdi], 10
    dec     rdi
    xor     rcx, rcx

    test    rax, rax
    jne     .conv_loop
    mov     byte [rdi], '0'
    dec     rdi
    inc     rcx
    jmp     .print

.conv_loop:
    xor     rdx, rdx
    mov     r9, 10
    div     r9
    add     dl, '0'
    mov     [rdi], dl
    dec     rdi
    inc     rcx
    test    rax, rax
    jne     .conv_loop

.print:
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

atoi_u64:
    xor     rax, rax
.a_loop:
    mov     dl, [rsi]
    test    dl, dl
    je      .a_done
    sub     dl, '0'
    cmp     dl, 9
    ja      .a_done
    imul    rax, rax, 10
    movzx   rdx, dl
    add     rax, rdx
    inc     rsi
    jmp     .a_loop
.a_done:
    ret


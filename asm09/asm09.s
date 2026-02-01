global _start
default rel

%define SYS_write 1
%define SYS_exit  60

section .bss
outbuf: resb 128

section .text
_start:
    mov     rbx, rsp
    mov     rax, [rbx]
    cmp     rax, 2
    je      .hex_mode
    cmp     rax, 3
    je      .maybe_bin
    jmp     .exit0

.hex_mode:
    mov     rsi, [rbx + 16]
    mov     r8d, 16
    jmp     .parse

.maybe_bin:
    mov     rsi, [rbx + 16]
    cmp     byte [rsi + 0], '-'
    jne     .exit0
    cmp     byte [rsi + 1], 'b'
    jne     .exit0
    cmp     byte [rsi + 2], 0
    jne     .exit0
    mov     rsi, [rbx + 24]
    mov     r8d, 2

.parse:
    call    atoi_u64
    mov     r9, rax

    lea     rdi, [outbuf + 127]
    xor     rcx, rcx

    test    r9, r9
    jne     .conv_loop
    mov     byte [rdi], '0'
    inc     rcx
    jmp     .do_write

.conv_loop:
    mov     rax, r9
    xor     rdx, rdx
    movzx   r10, r8b
    div     r10
    mov     r9, rax
    mov     al, dl
    cmp     r8d, 16
    jne     .digit01
    cmp     al, 9
    jbe     .digit09
    sub     al, 10
    add     al, 'A'
    jmp     .store
.digit09:
    add     al, '0'
    jmp     .store
.digit01:
    add     al, '0'
.store:
    mov     [rdi], al
    dec     rdi
    inc     rcx
    test    r9, r9
    jne     .conv_loop
    inc     rdi

.do_write:
    mov     rax, SYS_write
    mov     rsi, rdi
    mov     rdx, rcx
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


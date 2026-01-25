global _start
default rel

%define SYS_write 1
%define SYS_exit  60

section .text
_start:
    mov     rbx, rsp
    mov     rax, [rbx]

    cmp     rax, 2
    jl      .exit0

    mov     rdi, [rbx + 16]

    xor     rdx, rdx

.len_loop:
    cmp     byte [rdi + rdx], 0
    je      .do_write
    inc     rdx
    jmp     .len_loop

.do_write:
    mov     rax, SYS_write
    mov     rsi, rdi
    mov     rdi, 1
    syscall

.exit0:
    mov     rax, SYS_exit
    xor     rdi, rdi
    syscall

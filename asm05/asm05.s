global _start
default rel

%define SYS_write 1    ; x86-64 Linux syscall numbers: write=1, exit=60
%define SYS_exit  60

section .text
_start:
    ; At process entry, stack is:
    ; [rsp] = argc
    ; [rsp+8] = argv[0]
    ; [rsp+16] = argv[1]
    ; ... (SysV ABI x86-64)
    mov     rbx, rsp
    mov     rax, [rbx]          ; argc

    cmp     rax, 2
    jl      .exit0              ; if argc < 2, nothing to print

    mov     rdi, [rbx + 16]     ; rdi = argv[1] pointer (char*)

    ; Compute strlen(argv[1]) into rdx
    xor     rdx, rdx            ; len = 0
.len_loop:
    cmp     byte [rdi + rdx], 0 ; stop at NUL terminator
    je      .do_write
    inc     rdx
    jmp     .len_loop

.do_write:
    ; write(1, argv[1], len)
    mov     rax, SYS_write      ; write syscall
    mov     rsi, rdi            ; buf = argv[1]
    mov     rdi, 1              ; fd = stdout
    syscall

.exit0:
    ; exit(0)
    mov     rax, SYS_exit
    xor     rdi, rdi
    syscall

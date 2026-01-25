global _start
default rel
section .rodata
msg:    db "1337", 10
len:    equ $ - msg

section .text
_start:

        mov     rbx, rsp
        
        mov     rax, [rbx]
        cmp     rax, 2
        jne     .exit1

        
        mov     rsi, [rbx + 16]
        

        cmp     byte [rsi + 0], '4'
        jne     .exit1
        cmp     byte [rsi + 1], '2'
        jne     .exit1
        cmp     byte [rsi + 2], 0
        jne     .exit1
        jmp     .win


.exit:
    mov     rax, 60
    mov     rdi, 0             ; SYS_exit
    syscall

.exit1:
    mov     rax, 60
    mov     rdi, 1             ; SYS_exit
    syscall

.win:
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel msg]
    mov     rdx, len
    syscall
    jmp     .exit

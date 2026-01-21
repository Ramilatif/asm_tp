global _start

section .rodata
msg:    db "1337", 10          ; 10 = '\n'
len:    equ $ - msg            ; taille en octets

section .text
_start:
    ; write(1, msg, len)
    mov     rax, 1             ; SYS_write 
    mov     rdi, 1             ; fd = stdout
    mov     rsi, msg     ; adresse de msg (RIP-relative) 
    mov     rdx, len
    syscall                    ; invoke kernel 

    ; exit(0)
    mov     rax, 60            ; SYS_exit 
    xor     rdi, rdi           ; status = 0
    syscall


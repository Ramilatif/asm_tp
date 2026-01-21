global _start

section .text
_start:
    mov     rax, 60     ; SYS_exit 
    mov     rdi, 0     ; status
    syscall             ; instruction syscall 

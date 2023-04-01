BITS 32

section .text
    extern printk

    push dword 1

    string: dd "tes", 0
    mov eax, string
    push eax

    call printk
    jmp $

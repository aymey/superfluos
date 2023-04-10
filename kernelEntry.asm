BITS 32

section .text
    extern printk
    extern kprintf
    extern test

    ; call test

    ; push dword 1
    string: db "%", 0
    mov eax, string
    push eax

    call kprintf


    jmp $

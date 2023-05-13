BITS 32

section .text
    ; extern printk
    ; extern kprintf
    extern test

    ; push dword 1
    ; string: db "aabcaaaaaaaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabaaaaaaaaaaaa_3", 0
    ; mov eax, string
    ; push eax

    ; call kprintf
    call test

    jmp $

BITS 32

; jmp $

[extern main] ; TODO: compiler underscore?
call main

; we already loaded a temporary gdt from the bootloader to switch to protected mode but this offers more flexabiltiy
global gdt_flush
[extern gp]

gdt_flush:
    lgdt [gp]
    mov ax, 0x10 ; 0x10: offset of data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x08:flush2 ; 0x08: offset of code segment

flush2:
    ret


jmp $

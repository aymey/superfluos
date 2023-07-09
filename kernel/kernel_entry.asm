BITS 32
ORG 0x7C00

; [extern main] ; TODO: compiler underscore?
; call main

; we already loaded a temporary gdt from the bootloader to switch to protected mode but this offers more flexabiltiy
global gdt_flush
[extern gp]
[extern gdt_install]

call gdt_install

gdt_flush:
    lgdt [gp]
    mov ax, 0x10 ; 0x10: offset of data segment
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    jmp 0x08:flush2 ; 0x08: offset of code segment

flush2:
    ret

jmp $

BITS 32

; we already loaded a temporary gdt from the bootloader to switch to protected mode but this offers more flexabiltiy
global gdt_flush
[extern gdtp]
[extern gdt_install]

call gdt_install

gdt_flush:
    lgdt [gdtp]
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

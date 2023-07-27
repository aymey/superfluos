; ^bootloader/ for make directory (..)
%include "boot/magic.inc"

[ORG MBR_OFFSET]
BITS 16

KERNEL_LOCATION equ 0x1000

read_kernel:
    mov ah, 0x0
    mov al, 0x3
    int 0x10

    xor ax, ax
    mov es, ax
    mov ds, ax
    mov bp, 0x8000
    mov sp, bp

    mov bx, KERNEL_LOCATION

    mov ah, 0x02
    mov al, 0x20
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    int 0x13

    jmp protected_mode_setup

protected_mode_setup:
    CODE_SEG equ code_descriptor - GDT_start
    DATA_SEG equ data_descriptor - GDT_start

    cli
    lgdt [GDT_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:protected_mode

%include "boot/gdt.asm"

mbr_boot_sector_magic:
    times (MBR_SIZE-2)-($-$$) db 0
    dw MBR_MAGIC

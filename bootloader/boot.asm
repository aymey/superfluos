[ORG 0x7C00]
BITS 16
global _start

_start:
    KERNEL_LOCATION equ 0x1000
    BOOT_DISK equ 0

    call read_kernel

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
    mov al, 20
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


GDT_start:
    null_descriptor:
        dd 0x0
        dd 0x0

    code_descriptor:
        dw 0xFFFF
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0

    data_descriptor:
        dw 0xFFFF
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0
GDT_end:

GDT_descriptor:
    dw GDT_end - GDT_start - 1
    dd GDT_start

BITS 32
protected_mode:
    ; mov al, 'p'
    ; mov ah, 0xf2
    ; mov ah, 0b01111111
    ; mov ah, 0b00100110
    ; mov [0xb8000], ax
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    jmp KERNEL_LOCATION

times 510-($-$$) db 0
dw 0xAA55

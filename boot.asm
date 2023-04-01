[ORG 0x7C00]
BITS 16
start:
    KERNELLOCATION equ 0x1000

    BOOTDISK equ 0
    mov [BOOTDISK], dl

    call readKernel

    jmp $

readKernel:
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov bp, 0x8000
    mov sp, bp

    mov bx, KERNELLOCATION
    mov dh, 2


    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    mov dl, [BOOTDISK]
    int 0x13

    mov ah, 0x0
    mov al, 0x3
    int 0x10

    jmp protectedModeSetup

    jmp $


protectedModeSetup:
    CODESEG equ codeDescriptor - GDTStart
    DATASEG equ dataDescriptor - GDTStart

    cli
    lgdt [GDTDescriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODESEG:protectedMode

    jmp $


GDTStart:
    nullDescriptor:
        dd 0x0
        dd 0x0

    codeDescriptor:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0

    dataDescriptor:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0
GDTEnd:

GDTDescriptor:
    dw GDTEnd - GDTStart - 1
    dd GDTStart

BITS 32
protectedMode:
    ; mov al, 'p'
    ; mov ah, 0xf2
    ; mov ah, 0b01111111
    ; mov ah, 0b00100110
    ; mov [0xb8000], ax
    mov ax, DATASEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    jmp KERNELLOCATION

times 510-($-$$) db 0
dw 0xAA55

ORG 0x7C00
BITS 16

start:
    ; call readDisk
    cli
    lgdt [GDTDescriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODESEG:protectedMode

    jmp $

readDisk:
    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    ; mov dl, 0
    ; mov ax, 0
    ; mov es, ax
    mov bx, 0x7E00
    int 0x13

    mov ah, 0Eh
    mov al, [0x7E00]
    int 0x10

GDTStart:
    nullDescriptor:
        dd 0
        dd 0
    codeDescriptor:
        dw 0xffff
        dw 0
        db 0

        db 0b10011010
        db 0b11001111

        db 0

    dataDescriptor:
        dw 0xffff
        dw 0
        db 0

        db 0b10010010
        db 0b11001111

        db 0
GDTEnd:

GDTDescriptor:
    dw GDTEnd - GDTStart - 1
    dd GDTStart

    CODESEG equ codeDescriptor - GDTStart
    DATASEG equ dataDescriptor - GDTStart

[BITS 32]
protectedMode:
    mov al, 'A'
    mov ah, 0x0f
    mov [0xb8000], ax

times 510-($-$$) db 0
dw 0xAA55

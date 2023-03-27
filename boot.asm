ORG 0x7C00
BITS 16

start:
    call readDisk
    call printPress

    jmp $

readDisk:
    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov ax, 0x7C00
    mov es, ax
    mov bx, 0x7E00
    int 0x13

    mov ah, 0Eh
    mov al, [0x7E00]
    int 0x10

printPress:
    mov ah, 0
    int 0x16

    mov ah, 0Eh
    int 0x10
    call printPress

times 510-($-$$) db 0
dw 0xAA55

times 512 db 'A'

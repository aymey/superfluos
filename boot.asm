ORG 0x7C00
BITS 16

start:
    ; mov si, message
    call printPress

    jmp $

printPress:
    mov ah, 0
    int 0x16

    mov ah, 0Eh
    int 0x10
    call printPress

times 510-($-$$) db 0
dw 0xAA55

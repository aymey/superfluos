BITS 32

[extern putc]
[extern set_text_colour]
[extern clear_screen]

; set text colour to blue
mov eax, 1
times 2 push eax ; 2 for each parameter
call set_text_colour
pop eax

mov ebx, 80

mov eax, 'o'
push eax
times 80 call putc

loop:
    jmp redraw
    ; call putc



    end:
        jmp approx_sleep


; update the screen frame with 'physics' and stuff
redraw:
    call clear_screen

    mov ecx, ebx
    add ebx, 80

    mov eax, 0
    times 2 push eax
    call set_text_colour
    pop eax

    mov eax, 'o'
    push eax
    .loop:
        call putc
        loop .loop
    pop eax

    mov eax, 1
    times 2 push eax
    call set_text_colour
    pop eax

    mov eax, 'o'
    push eax
    times 80 call putc
    pop eax

    jmp end




; update timer uses qemu 'emulated clock speed' (dont exactly know how qemu works, prob not this). not general
approx_sleep:
mov eax, 105000000
    .cycle:
        dec eax
        jz loop
        jmp .cycle

jmp $

BITS 32

[extern fault_handler]

; ISR Exception numbers
global isr0
global isr1
global isr2
global isr3
global isr4
global isr5
global isr6
global isr7
global isr8
global isr9
global isr10
global isr11
global isr12
global isr13
global isr14
global isr15
global isr16
global isr17
global isr18
global isr19
global isr20
global isr21
global isr22
global isr23
global isr24
global isr25
global isr26
global isr27
global isr28
global isr29
global isr30
global isr31

; 0, isr0:  Divide By Zero Exception
isr0:
    cli
    push byte 0 ; ISR stub (error code to push, default is 0)
    push byte 0 ; ISR numb (Exception entry number)
    jmp isr_common_stub

; 1, isr1:  Debug Exception
isr1:
    cli
    push byte 0
    push byte 1
    jmp isr_common_stub


; 2, isr2:  Non Maskable Interrupt Exception
isr2:
    cli
    push byte 0
    push byte 2
    jmp isr_common_stub

; 3, isr3:  Breakpoint Exception
isr3:
    cli
    push byte 0
    push byte 3
    jmp isr_common_stub

; 4, isr4:  Into Detected Overflow Exception
isr4:
    cli
    push byte 0
    push byte 4
    jmp isr_common_stub

; 5, isr5:  Out of Bounds Exception
isr5:
    cli
    push byte 0
    push byte 5
    jmp isr_common_stub

; 6, isr6:  Invalid Opcode Exception
isr6:
    cli
    push byte 0
    push byte 6
    jmp isr_common_stub

; 7, isr7:  No Coprocessor Exception
isr7:
    cli
    push byte 0
    push byte 7
    jmp isr_common_stub

; 8, isr8:  Double Fault Exception
isr8:
    cli
    push byte 8 ; ISR stub is already going to be pushed as ISR Exception 8 pushes an Error Code for us
    jmp isr_common_stub

; 9, isr9:  Coprocessor Segment Overrun Exception
isr9:
    cli
    push byte 0
    push byte 9
    jmp isr_common_stub

; 10, isr10:  Bad TTS Exception
isr10:
    cli
    push byte 10
    jmp isr_common_stub

; 11, isr11:  Segment Not Present Exception
isr11:
    cli
    push byte 11
    jmp isr_common_stub

; 12, isr12:  Stack Fault Exception
isr12:
    cli
    push byte 12
    jmp isr_common_stub

; 13, isr13:  General Protection Fault Exception
isr13:
    cli
    push byte 13
    jmp isr_common_stub

; 14, isr14:  Page Fault Exception
isr14:
    cli
    push byte 14
    jmp isr_common_stub

; 15, isr15:  Unknown Interrupt Exception
isr15:
    cli
    push byte 0
    push byte 15
    jmp isr_common_stub

; 16, isr16:  Coprocessor Fault Exception
isr16:
    cli
    push byte 0
    push byte 16
    jmp isr_common_stub

; 17, isr17:  Alignment Check Exception (486+)
isr17:
    cli
    push byte 0
    push byte 17
    jmp isr_common_stub

; 18, isr18:  Machine Check Exception (Pentium/586+)
isr18:
    cli
    push byte 0
    push byte 18
    jmp isr_common_stub

; 19, isr19:  Reserved Exception
isr19:
    cli
    push byte 0
    push byte 19
    jmp isr_common_stub

; 20, isr20:  Reserved Exception
isr20:
    cli
    push byte 0
    push byte 20
    jmp isr_common_stub

; 21, isr21:  Reserved Exception
isr21:
    cli
    push byte 0
    push byte 21
    jmp isr_common_stub

; 22, isr22:  Reserved Exception
isr22:
    cli
    push byte 0
    push byte 22
    jmp isr_common_stub

; 23, isr23:  Reserved Exception
isr23:
    cli
    push byte 0
    push byte 23
    jmp isr_common_stub

; 24, isr24:  Reserved Exception
isr24:
    cli
    push byte 0
    push byte 24
    jmp isr_common_stub

; 25, isr25:  Reserved Exception
isr25:
    cli
    push byte 0
    push byte 25
    jmp isr_common_stub

; 26, isr26:  Reserved Exception
isr26:
    cli
    push byte 0
    push byte 26
    jmp isr_common_stub

; 27, isr27:  Reserved Exception
isr27:
    cli
    push byte 0
    push byte 27
    jmp isr_common_stub

; 28, isr28:  Reserved Exception
isr28:
    cli
    push byte 0
    push byte 28
    jmp isr_common_stub

; 29, isr29:  Reserved Exception
isr29:
    cli
    push byte 0
    push byte 29
    jmp isr_common_stub

; 30, isr30:  Reserved Exception
isr30:
    cli
    push byte 0
    push byte 30
    jmp isr_common_stub

; 31, isr31:  Reserved Exception
isr31:
    cli
    push byte 0
    push byte 31
    jmp isr_common_stub

; common ISR stub: saves processor state -> sets up for kernel mode segments -> calls fault handler -> restores stack frame
isr_common_stub:
    pusha
    push ds
    push es
    push fs
    push gs
    mov ax, 0x10 ; Load kernel Data Segment descriptor
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov eax, esp
    push eax
    mov eax, fault_handler
    call eax ; preserves `eip`

    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8 ; Cleans up the pushed error code and pushed ISR number

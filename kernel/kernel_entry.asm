BITS 32

; TODO: should do gdt stuff here

[extern idt_install]
call idt_install

[extern isr_install]
call isr_install

[extern main] ; TODO: compiler underscore?
call main

jmp $

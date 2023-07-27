BITS 32

[extern main] ; TODO: compiler underscore?

[extern idt_install]
[extern idt_load]

; TODO: should do gdt stuff here

call idt_install
call idt_load

call main

jmp $

; BITS 32

; global idt_load
; [extern idtp]
; [extern idt_install]

; call idt_install

; idt_load:
;   lidt [idtp]
;   ret

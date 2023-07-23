BITS 32

[extern main] ; TODO: compiler underscore?

global idt_load
[extern idtp]
[extern idt_install]

call idt_install

idt_load:
  lidt [idtp]
  ; ret

call main

jmp $

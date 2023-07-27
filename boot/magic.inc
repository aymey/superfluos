use16

; Master Boot Record magic values

; memory offset after interrupts
MBR_OFFSET  equ 0x7C00

; byte size of boot sector
MBR_SIZE    equ 512

; denotes end of boot sector
MBR_MAGIC   equ 0xAA55

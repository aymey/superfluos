ASM = nasm
CC = /usr/local/i386elfgcc/bin/i386-elf-gcc

# COMPILER = gcc -fno-pie
CFLAGS = -Wall -c -ffreestanding -fno-builtin -fno-builtin-function -nostdinc -static -fomit-frame-pointer -m32 -I ./include
# TODO: make better for debug stuff than temp flags. maybe debug targets instead
TEMP_CFLAGS = -g
TEMP_ASMFLAGS = -F dwarf -g
LD = /usr/local/i386elfgcc/bin/i386-elf-ld

KERNEL_LOCATION = ./kernel
BOOT_LOCATION = ./boot


all: boot.bin kernel.bin combine

boot.bin: $(BOOT_LOCATION)/* # $(BOOT_LOCATION)/boot.asm $(BOOT_LOCATION)/gdt.asm $(BOOT_LOCATION)/magic.inc
		$(ASM) $(BOOT_LOCATION)/boot.asm -f bin -g -o boot.bin

kernel.bin: $(KERNEL_LOCATION)/*
		$(CC) $(CFLAGS) $(TEMP_FLAGS) $(KERNEL_LOCATION)/main.c -o main.o # what std lib flags do i need? diff between -fno-builtin and -fnobuiltin-function? -ffreestanding "implies -fnobuiltin(-function)" - manual? include headers '-I'?
		$(CC) $(CFLAGS) $(TEMP_FLAGS) $(KERNEL_LOCATION)/display.c -o display.o
		$(CC) $(CFLAGS) $(TEMP_FLAGS) $(KERNEL_LOCATION)/idt.c -o idt.o
		$(ASM) $(KERNEL_LOCATION)/idt.asm -f elf $(TEMP_ASMFLAGS) -o idt_e.o
		$(CC) $(CFLAGS) $(TEMP_FLAGS) $(KERNEL_LOCATION)/isr.c -o isr.o
		$(ASM) $(KERNEL_LOCATION)/isr.asm -f elf $(TEMP_ASMFLAGS) -o isr_e.o
		$(ASM) $(KERNEL_LOCATION)/kernel_entry.asm -f elf $(TEMP_ASMFLAGS) -o kernel_entry.o

		${LD} -T link.ld kernel_entry.o main.o display.o idt.o idt_e.o isr.o isr_e.o -o kernel.bin # TODO better way to cleanup link files

combine:
	cat boot.bin kernel.bin > os.bin

clean:
	rm -rf *.bin *.o

.PHONY: all clean combine

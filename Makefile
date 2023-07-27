ASM = nasm
CC = /usr/local/i386elfgcc/bin/i386-elf-gcc
# COMPILER = gcc -fno-pie
CFLAGS = -Wall -ffreestanding -fno-builtin -fno-builtin-function -nostdinc -static -fomit-frame-pointer -m32
TEMP_FLAGS = -g -c
LINKER = /usr/local/i386elfgcc/bin/i386-elf-ld

KERNEL_LOCATION = ./kernel
BOOT_LOCATION = ./boot


all: boot.bin kernel.bin

boot.bin: $(BOOT_LOCATION)/* # $(BOOT_LOCATION)/boot.asm $(BOOT_LOCATION)/gdt.asm $(BOOT_LOCATION)/magic.inc
		$(ASM) $(BOOTLOADER_LOCATION)/boot.asm -f bin -o boot.bin

kernel.bin: $(KERNEL_LOCATION)/*
		$(CC) $(CFLAGS) -g -c $(KERNEL_LOCATION)/main.c -o main.o # what std lib flags do i need? diff between -fno-builtin and -fnobuiltin-function? -ffreestanding "implies -fnobuiltin(-function)" - manual? include headers '-I'?
		$(CC) $(CFLAGS) -g -c $(KERNEL_LOCATION)/display.c -o display.o
		$(CC) $(CFLAGS) -g -c $(KERNEL_LOCATION)/idt.c -o idt.o
		$(ASM) $(KERNEL_LOCATION)/idt.asm -f elf -o idt_e.o
		$(ASM) $(KERNEL_LOCATION)/kernel_entry.asm -f elf -o kernel_entry.o

		${LINKER} -o kernel.bin -Ttext 0x1000 kernel_entry.o display.o idt.o idt_e.o main.o --oformat binary

combine:
	cat boot.bin kernel.bin > os.bin

clean:
	rm -rf *.bin *.o

.PHONY: all clean combine

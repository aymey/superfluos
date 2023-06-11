ASM = nasm
COMPILER = /usr/local/i386elfgcc/bin/i386-elf-gcc
COMPILER_FLAGS = -Wall -ffreestanding -fno-builtin -fno-builtin-function -nostdinc -static -fomit-frame-pointer -m32
# COMPILER = gcc -fno-pie
LINKER = /usr/local/i386elfgcc/bin/i386-elf-ld

KERNEL_LOCATION = ./kernel
BOOTLOADER_LOCATION = ./bootloader

os: */*.asm */*.c
	$(COMPILER) $(COMPILER_FLAGS) -g -c $(KERNEL_LOCATION)/main.c -o main.o # what std lib flags do i need? diff between -fno-builtin and -fnobuiltin-function? -ffreestanding "implies -fnobuiltin(-function)" - manual? include headers '-I'?
	$(COMPILER) $(COMPILER_FLAGS) -g -c $(KERNEL_LOCATION)/display.c -o display.o
	$(COMPILER) $(COMPILER_FLAGS) -g -c $(KERNEL_LOCATION)/gdt.c -o gdt.o
	#
	$(ASM) $(KERNEL_LOCATION)/kernel_entry.asm -f elf -o kernel_entry.o
	$(ASM) $(BOOTLOADER_LOCATION)/boot.asm -f bin -o boot.bin
	${LINKER} -o kernel.bin -Ttext 0x1000 kernel_entry.o display.o gdt.o main.o --oformat binary
	#
	cat boot.bin kernel.bin > os.bin

clean:
	rm -rf *.bin *.o

ASM = nasm
COMPILER = /usr/local/i386elfgcc/bin/i386-elf-gcc
LINKER = /usr/local/i386elfgcc/bin/i386-elf-ld

KERNEL_LOCATION = ./kernel
BOOTLOADER_LOCATION = ./bootloader

os: */*.asm */*.c
	$(COMPILER) -Wall -ffreestanding -fno-builtin -fno-builtin-function -nostdinc -fomit-frame-pointer -m32 -g -c $(KERNEL_LOCATION)/main.c -o main.o # what std lib flags do i need? diff between -fno-builtin and -fnobuiltin-function? -ffreestanding "implies -fnobuiltin(-function)"? include headers '-I'?
	$(ASM) $(KERNEL_LOCATION)/kernel_entry.asm -f elf -o kernel_entry.o
	${LINKER} -o kernel.bin -Ttext 0x1000 kernel_entry.o main.o --oformat binary
	$(ASM) $(BOOTLOADER_LOCATION)/boot.asm -f bin -o boot.bin
	$(ASM) $(BOOTLOADER_LOCATION)/10240.asm -f bin -o 10240.bin
	cat boot.bin kernel.bin 10240.bin > os.bin

clean:
	rm -rf *.bin *.o

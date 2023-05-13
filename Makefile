ASM = nasm
KERNEL_LOCATION = kernel
BOOTLOADER_LOCATION = bootloader

os: */*.asm */*.c
	/usr/local/i386elfgcc/bin/i386-elf-gcc -ffreestanding -m32 -g -c $(KERNEL_LOCATION)/kernel.c -o kernel.o
	$(ASM) $(KERNEL_LOCATION)/kernel_entry.asm -f elf -o kernel_entry.o
	/usr/local/i386elfgcc/bin/i386-elf-ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
	$(ASM) $(BOOTLOADER_LOCATION)/boot.asm -f bin -o boot.bin
	$(ASM) $(BOOTLOADER_LOCATION)/10240.asm -f bin -o 10240.bin
	cat boot.bin kernel.bin 10240.bin > os.bin

clean:
	rm -rf *.bin *.o

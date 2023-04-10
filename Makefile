ASM = nasm

os: *.asm *.c
	/usr/local/i386elfgcc/bin/i386-elf-gcc -ffreestanding -m32 -g -c kernel.c -o kernel.o
	$(ASM) kernelEntry.asm -f elf -o kernelEntry.o
	/usr/local/i386elfgcc/bin/i386-elf-ld -o kernel.bin -Ttext 0x1000 kernelEntry.o kernel.o --oformat binary
	$(ASM) boot.asm -f bin -o boot.bin
	$(ASM) 10240.asm -f bin -o 10240.bin
	cat boot.bin kernel.bin 10240.bin > os.bin

clean:
	rm -rf *.bin *.o

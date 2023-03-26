ASM = nasm

boot.bin: boot.asm
	$(ASM) boot.asm -f bin -o boot.bin

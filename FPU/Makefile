all: FPUhandler

FPUhandler: FPUhandler.s
	as  FPUhandler.s --gstabs -o FPUhandler.o --32
	ld FPUhandler.o -o FPUhandler -m elf_i386

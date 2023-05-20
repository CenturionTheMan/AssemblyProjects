all: add sub mul

add: add.s
	as  add.s --gstabs -o add.o --32
	ld add.o -o add -m elf_i386

sub: sub.s
	as sub.s --gstabs -o sub.o --32
	ld sub.o -o sub -m elf_i386


mul: mul.s
	as mul.s --gstabs -o mul.o --32
	ld mul.o -o mul -m elf_i386


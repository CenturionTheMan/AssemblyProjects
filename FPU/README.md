# FPU in Assembly

This assembly code demonstrates how to use the Floating-Point Unit (FPU) in assembly language.

The code contains examples that generate all possible exceptions and store them in ST's (FPU stack) registers. Additionally, it includes predefined masks for manipulating the FPU control word.

## Usage

1. Compile the code using the provided Makefile: 'make'
2. Open the program in gdb: 'gdb FPUhandler'
3. Run program: 'run'
4. Use GDB to inspect the FPU state: 'info float'


## License

This code is released under the MIT License.

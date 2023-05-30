# Integral

This repository contains assembly language code for calculating the definite integral of a function using the rectangle method.

## Files

- `integral.s`: This file contains the assembly code for the integral calculation algorithm. It defines variables and subroutines to perform the necessary calculations.
- `integralCaller.c`: This file is a C program that calls the assembly function to calculate the integral. It provides example usage and demonstrates how to pass arguments to the assembly code.
- `Makefile`: This file is a Makefile that compiles the assembly and C code into an executable program named "integral".

## Usage

To use the program, follow these steps:

1. Make sure you have a development environment set up for assembly language programming.
2. Clone or download this repository to your local machine.
3. Open a terminal or command prompt and navigate to the repository directory.
4. Run the `make` command to compile the assembly and C code and generate the executable program.
5. Run the generated `integral` executable to calculate the integral.
6. The program will display the result of the integral on the console.

Note: You can modify the values of the variables in the `integralCaller.c` file to customize the integral calculation. The `upperBound`, `lowerBound`, `iterationsAmount`, and `round_type` variables control the bounds of integration, the number of intervals, and the rounding type for the calculation.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the code in this repository as per the terms of the license.


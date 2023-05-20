# SIMD vs SISD Performance Comparison

This code performs tests to compare the performance of SIMD (Single Instruction, Multiple Data) and SISD (Single Instruction, Single Data) operations. It measures the execution time of addition, subtraction, multiplication, and division operations on a set of random numbers.

## Prerequisites

- C++ compiler that supports SIMD instructions

## Usage

1. Compile the code using a C++ compiler (Makefile included).
2. Run the executable generated.

## SIMD Operations

The code includes SIMD operations (`SIMDadd`, `SIMDsub`, `SIMDmul`, `SIMDdiv`) that perform addition, subtraction, multiplication, and division of `Vector4` structures using SIMD instructions.

### SIMD Function Signatures

- `Vector4 SIMDadd(Vector4 v1, Vector4 v2, long& timeTaken)`: Performs SIMD addition of two `Vector4` instances.
- `Vector4 SIMDsub(Vector4 v1, Vector4 v2, long& timeTaken)`: Performs SIMD subtraction of two `Vector4` instances.
- `Vector4 SIMDmul(Vector4 v1, Vector4 v2, long& timeTaken)`: Performs SIMD multiplication of two `Vector4` instances.
- `Vector4 SIMDdiv(Vector4 v1, Vector4 v2, long& timeTaken)`: Performs SIMD division of two `Vector4` instances.

## SISD Operations

The code also includes SISD operations (`SISDadd`, `SISDsub`, `SISDmul`, `SISDdiv`) that perform addition, subtraction, multiplication, and division of individual floating-point numbers using SISD instructions.

### SISD Function Signatures

- `float SISDadd(float f1, float f2, long& timeTaken)`: Performs SISD addition of two floats.
- `float SISDsub(float f1, float f2, long& timeTaken)`: Performs SISD subtraction of two floats.
- `float SISDmul(float f1, float f2, long& timeTaken)`: Performs SISD multiplication of two floats.
- `float SISDdiv(float f1, float f2, long& timeTaken)`: Performs SISD division of two floats.

## Testing

The code includes functions for performing tests on a specified number of elements with a given number of repetitions and a range of random numbers. It compares the average execution times of SIMD and SISD operations for addition, subtraction, multiplication, and division.

### Test Functions

- `std::string PerformTestsSIMD(int numbersAmount, int repsAmount, float maxNumberInVector, float minNumberInVector)`: Performs SIMD tests and returns the test results as a string.
- `std::string PerformTestsSISD(int numbersAmount, int repsAmount, float maxNumberInVector, float minNumberInVector)`: Performs SISD tests and returns the test results as a string.

## Results

The code performs tests on different numbers of elements (2048, 4096, 8192) and prints the average execution times for SIMD and SISD operations. The results are displayed on the console and saved to file.

## License

This code is released under the MIT License.

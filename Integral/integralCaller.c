#include <stdio.h>

double integral(double, double, int, int);  // Function prototype for the integral function

int main()
{
    double upperBound = 1; // Declare and initialize the upper bound of the integral
    double lowerBound = 0; // Declare and initialize the lower bound of the integral
    int iterationsAmount = 1000; // Declare and initialize the number of iterations for the integral
    
    // 0-to nearest | 1-round up | 2-round down | 3-cut (truncation)
    int round_type = 1; // Declare and initialize the rounding type for the integral
    
    double result = integral(upperBound, lowerBound, iterationsAmount, round_type); // Call the integral function with the provided arguments
    
    printf("Integral result: %f\n", result);  // Print the value of 'result' as the integral result
    
    return 0;
}

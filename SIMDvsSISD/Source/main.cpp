#include <iostream>
#include <sstream>
#include <random>
#include <chrono>
#include <limits>
#include <fstream>
#include <iomanip>

struct Vector4
{
    float x, y, z, w;

    Vector4() {}

    Vector4(float x, float y, float z, float w)
    {
        this->x = x;
        this->y = y;
        this->z = z;
        this->w = w;
    }

    std::string ToString()
    {
        std::stringstream stream;
        stream   << std::setfill(' ') << std::setw(5) << std::fixed << std::setprecision(2) << x << " | "
                 << std::setfill(' ') << std::setw(5) << std::fixed << std::setprecision(2) << y << " | " 
                 << std::setfill(' ') << std::setw(5) << std::fixed << std::setprecision(2) << z << " | " 
                 << std::setfill(' ') << std::setw(5) << std::fixed << std::setprecision(2) << w << std::endl;
        return stream.str();
    }
};

#pragma region SIMD

/// @brief Performs SIMD addition of two Vector4 
/// @param v1 
/// @param v2 
/// @param timeTaken execution time of the operation. Note: The elapsed time will be added to this parameter.
/// @return operation result
Vector4 SIMDadd(Vector4 v1 ,Vector4 v2, long &timeTaken)
{
    Vector4 result;
    
    auto start = std::chrono::high_resolution_clock::now();
    asm volatile (
        "movups %1, %%xmm0\n"
        "movups %2, %%xmm1\n"
        "addps %%xmm1, %%xmm0\n"
        "movups %%xmm0, %0"
        : "=m" (result)
        : "m" (v1), "m" (v2)
        : "xmm1", "xmm0"
    );
    auto stop = std::chrono::high_resolution_clock::now();
    timeTaken += std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();

    return result;
}

/// @brief Performs SIMD subtraction of two Vector4 
/// @param v1 
/// @param v2 
/// @param timeTaken execution time of the operation. Note: The elapsed time will be added to this parameter.
/// @return operation result
Vector4 SIMDsub(Vector4 v1 ,Vector4 v2, long &timeTaken)
{
    Vector4 result;

    auto start = std::chrono::high_resolution_clock::now();
    asm volatile (
        "movups %1, %%xmm0\n"
        "movups %2, %%xmm1\n"
        "subps %%xmm1, %%xmm0\n"
        "movups %%xmm0, %0"
        : "=m" (result)
        : "m" (v1), "m" (v2)
        : "xmm1", "xmm0"
    );
    auto stop = std::chrono::high_resolution_clock::now();
    timeTaken += std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();

    return result;
}

/// @brief Performs SIMD multiplication of two Vector4 
/// @param v1 
/// @param v2 
/// @param timeTaken execution time of the operation. Note: The elapsed time will be added to this parameter.
/// @return operation result
Vector4 SIMDmul(Vector4 v1 ,Vector4 v2, long &timeTaken)
{
    Vector4 result;

    auto start = std::chrono::high_resolution_clock::now();
    asm volatile (
        "movups %1, %%xmm0\n"
        "movups %2, %%xmm1\n"
        "mulps %%xmm1, %%xmm0\n"
        "movups %%xmm0, %0"
        : "=m" (result)
        : "m" (v1), "m" (v2)
        : "xmm1", "xmm0"
    );
    auto stop = std::chrono::high_resolution_clock::now();
    timeTaken += std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();

    return result;
}

/// @brief Performs SIMD division of two Vector4 
/// @param v1 
/// @param v2 
/// @param timeTaken execution time of the operation. Note: The elapsed time will be added to this parameter.
/// @return operation result
Vector4 SIMDdiv(Vector4 v1 ,Vector4 v2, long &timeTaken)
{
    Vector4 result;

    auto start = std::chrono::high_resolution_clock::now();
    asm volatile (
        "movups %1, %%xmm0\n"
        "movups %2, %%xmm1\n"
        "divps %%xmm1, %%xmm0\n"
        "movups %%xmm0, %0"
        : "=m" (result)
        : "m" (v1), "m" (v2)
        : "xmm1", "xmm0"
    );
    auto stop = std::chrono::high_resolution_clock::now();
    timeTaken += std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();

    return result;
}

#pragma endregion SIMD

#pragma region SISD

/// @brief Performs SISD addition of two floats
/// @param f1
/// @param f2 
/// @param timeTaken execution time of the operation. Note: The elapsed time will be added to this parameter.
/// @return operation result
float SISDadd (float f1, float f2, long &timeTaken)
{
    float result;

    auto start = std::chrono::high_resolution_clock::now();
    asm volatile (
        "flds %1\n"
        "fadds %2\n"
        "fstps %0\n"
        : "=m" (result)
        : "m" (f1), "m" (f2)
    );
    auto stop = std::chrono::high_resolution_clock::now();
    timeTaken += std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();

    return result;
}

/// @brief Performs SISD subtraction of two floats
/// @param f1
/// @param f2 
/// @param timeTaken execution time of the operation. Note: The elapsed time will be added to this parameter.
/// @return operation result
float SISDsub (float f1, float f2, long &timeTaken)
{
    float result;

    auto start = std::chrono::high_resolution_clock::now();
    asm volatile (
        "flds %1\n"
        "fsubs %2\n"
        "fstps %0\n"
        : "=m" (result)
        : "m" (f1), "m" (f2)
    );
    auto stop = std::chrono::high_resolution_clock::now();
    timeTaken += std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();

    return result;
}

/// @brief Performs SISD multiplication of two floats
/// @param f1
/// @param f2 
/// @param timeTaken execution time of the operation. Note: The elapsed time will be added to this parameter.
/// @return operation result
float SISDmul (float f1, float f2, long &timeTaken)
{
    float result;

    auto start = std::chrono::high_resolution_clock::now();
    asm volatile (
        "flds %1\n"
        "fmuls %2\n"
        "fstps %0\n"
        : "=m" (result)
        : "m" (f1), "m" (f2)
    );
    auto stop = std::chrono::high_resolution_clock::now();
    timeTaken += std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();

    return result;
}

/// @brief Performs SISD division of two floats
/// @param f1
/// @param f2 
/// @param timeTaken execution time of the operation. Note: The elapsed time will be added to this parameter.
/// @return operation result
float SISDdiv (float f1, float f2, long &timeTaken)
{
    float result;

    auto start = std::chrono::high_resolution_clock::now();
    asm volatile(
        "flds %1\n"
        "fdivs %2\n"
        "fstps %0\n"
        : "=m" (result)
        : "m" (f1), "m" (f2)
    );
    auto stop = std::chrono::high_resolution_clock::now();
    timeTaken += std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();


    return result;
}

#pragma endregion SISD

/// @brief This function generates a random Vector4 instance with each component being a random float within the specified range.
/// @param min min float in vector
/// @param max max float in vector
/// @return random vector
Vector4 GenerateRandomVector4(float min, float max)
{
    std::random_device rd;
    std::default_random_engine engine(rd());
    std::uniform_real_distribution<float> dist(min, max);
    
    Vector4 result = Vector4(dist(engine),dist(engine),dist(engine),dist(engine));

    return result;
}

/// @brief This function generates a random float within the specified range.
/// @param min min size
/// @param max max size
/// @return random float
float GenerateRandomFloat(float min, float max)
{
    std::random_device rd;
    std::default_random_engine engine(rd());
    std::uniform_real_distribution<float> dist(min, max);
    return dist(engine);
}

/// @brief Performs SIMD tests on a specified number of elements with a given number of repetitions and range of random numbers.
/// @param numbersAmount The number of elements in the test.
/// @param repsAmount The number of repetitions of the test.
/// @param maxNumberInVector The maximum value of random numbers in the vector.
/// @param minNumberInVector The minimum value of random numbers in the vector.
/// @return A string containing the test results.
std::string PerformTestsSIMD(int numbersAmount, int repsAmount, float maxNumberInVector, float minNumberInVector)
{
    long addTime = 0;
    long subTime = 0;
    long mulTime = 0;
    long divTime = 0;

    for (int i = 0; i < repsAmount; i++)
    {
        for (int j = 0; j < numbersAmount/4/2; j++)
        {
            Vector4 v1 = GenerateRandomVector4(minNumberInVector, maxNumberInVector);
            Vector4 v2 = GenerateRandomVector4(minNumberInVector, maxNumberInVector);

            SIMDadd(v1, v2, addTime);
            SIMDsub(v1, v2, subTime);
            SIMDmul(v1, v2, mulTime);
            SIMDdiv(v1, v2, divTime);
        }
    }
    
    addTime /= repsAmount;
    subTime /= repsAmount;
    mulTime /= repsAmount;
    divTime /= repsAmount;

    std::stringstream result;
    result  << "Typ obliczen: SIMD\n" 
            << "Liczba liczb: " << numbersAmount << "\n"
            << "Sredni czas [ns]:\n" 
            << "+ " << addTime << "\n"
            << "- " << subTime << "\n"
            << "* " << mulTime << "\n"
            << "/ " << divTime << "\n";

    return result.str();
}

/// @brief Performs SISD tests on a specified number of elements with a given number of repetitions and range of random numbers.
/// @param numbersAmount The number of elements in the test.
/// @param repsAmount The number of repetitions of the test.
/// @param maxNumberInVector The maximum value of random numbers in the vector.
/// @param minNumberInVector The minimum value of random numbers in the vector.
/// @return A string containing the test results.
std::string PerformTestsSISD(int numbersAmount, int repsAmount, float maxNumberInVector, float minNumberInVector)
{
    long addTime = 0;
    long subTime = 0;
    long mulTime = 0;
    long divTime = 0;

    for (int i = 0; i < repsAmount; i++)
    {
        for (int j = 0; j < numbersAmount/2; j++)
        {
            float f1 = GenerateRandomFloat(minNumberInVector, maxNumberInVector);
            float f2 = GenerateRandomFloat(minNumberInVector, maxNumberInVector);

            SISDadd(f1, f2, addTime);
            SISDsub(f1, f2, subTime);
            SISDmul(f1, f2, mulTime);
            SISDdiv(f1, f2, divTime);
        }
    }
    
    addTime /= repsAmount;
    subTime /= repsAmount;
    mulTime /= repsAmount;
    divTime /= repsAmount;

    std::stringstream result;
    result  << "Typ obliczen: SISD\n" 
            << "Liczba liczb: " << numbersAmount << "\n"
            << "Sredni czas [ns]:\n" 
            << "+ " << addTime << "\n"
            << "- " << subTime << "\n"
            << "* " << mulTime << "\n"
            << "/ " << divTime << "\n";

    return result.str();
}

/// @brief Writes the specified file content to a file at the given path.
/// @param path The path of the file to write.
/// @param fileContent The content to write to the file.
void WriteToFile(std::string path, std::string fileContent)
{
    std::ofstream out(path);
    out << fileContent;
    out.close();
}

void TestOperations()
{
    long time;

    Vector4 v1 = Vector4(1.5,2.5,3.5,4.5);
    Vector4 v2 = Vector4(5,32.2,10,9.5);
    std::cout << "v1: " << v1.ToString();
    std::cout << "v2: " << v2.ToString();
    std::cout 
            << "SIMD\n" 
            << "ADD: " << SIMDadd(v1, v2, time).ToString()
            << "SUB: " << SIMDsub(v1, v2, time).ToString()
            << "MUL: " << SIMDmul(v1, v2, time).ToString()
            << "DIV: " << SIMDdiv(v1, v2, time).ToString() << std::endl;


    float f1 = 0.5;
    float f2 = 2.1;
    std::cout << "f1: " << f1 << std::endl;
    std::cout << "f2: " << f2 << std::endl;
    std::cout 
            << "SISD\n" 
            << "ADD: " << SISDadd(f1, f2, time) << std::endl
            << "SUB: " << SISDsub(f1, f2, time) << std::endl
            << "MUL: " << SISDmul(f1, f2, time) << std::endl
            << "DIV: " << SISDdiv(f1, f2, time) << std::endl;
}

/// @brief The main function that performs the tests and writes the results to files. 
int main()
{
    TestOperations();
    return 0;

    int repsPerTest = 10;
    float min = std::numeric_limits<float>::min();
    float max = std::numeric_limits<float>::max();

    std::string resultSISD_2048 = PerformTestsSISD(2048, repsPerTest, min, max);
    std::string resultSISD_4096 = PerformTestsSISD(4096, repsPerTest, min, max);
    std::string resultSISD_8192 = PerformTestsSISD(8192, repsPerTest, min, max);

    std::cout << resultSISD_2048 << std::endl;
    std::cout << resultSISD_4096 << std::endl;
    std::cout << resultSISD_8192 << std::endl;

    std::string resultSIMD_2048 = PerformTestsSIMD(2048, repsPerTest, min, max);
    std::string resultSIMD_4096 = PerformTestsSIMD(4096, repsPerTest, min, max);
    std::string resultSIMD_8192 = PerformTestsSIMD(8192, repsPerTest, min, max);

    std::cout << resultSIMD_2048 << std::endl;
    std::cout << resultSIMD_4096 << std::endl;
    std::cout << resultSIMD_8192 << std::endl;

    WriteToFile("result_SISD.txt", resultSISD_2048 + "\n" + resultSISD_4096 + "\n" + resultSISD_8192);
    WriteToFile("result_SIMD.txt", resultSIMD_2048 + "\n" + resultSIMD_4096 + "\n" + resultSIMD_8192);

    return 0;
}
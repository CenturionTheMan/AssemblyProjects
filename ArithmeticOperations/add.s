# The program adds two numbers, assuming that their lengths are the same.
#Result int gdb: x /5x $esp

.section .data
number1: #First number
    .long 0x10304008, 0x701100FF, 0x45100020, 0x08570030
    number1_len = (.-number1)
    liczba1_amount = number1_len/4; # Number of 32-bit numbers in number1

number2: #Second number
    .long 0xf040500C, 0x00220026, 0xF21000CB, 0x04520031
    number2_len = (.-number2)
    liczba2_amount = number2_len/4; #Number of 32-bit numbers in number2

# INTERMEDIATE RESULTS FOR THESE VALUES:
# 1|00709014|70330126|372000EB|0CA90061

.section .text
.global _start

# Declarations of constants
SYSEXIT = 1
EXIT_SUCCESS = 0
INTERUPT = 0x80

# Entry point
_start:
    clc
    jmp F_MAIN_ADD

F_MAIN_ADD:
    #esi - register used as an index
    movl $liczba1_amount, %esi

    LOOP_BEG:
        decl %esi

        # Addition with carry of sub-numbers
        movl number1(,%esi,4), %eax
        adcl number2(,%esi,4), %eax

        # Result on stack
        pushl %eax

        # Check if it's the end of the number and there is no carry
        pushf
        cmpl $0, %esi
        je F_ADD_IF_OVERFLOW_EQUAL
        popf
        
        # Otherwise, go back to the beginning of the loop
        jmp LOOP_BEG 

F_ADD_IF_OVERFLOW_EQUAL:
    # If there is no carry, finish
    popf
    jnc F_END

    # Reset the index
    xor %eax, %eax
    # Add the carry if present
    movl $1, %eax
    pushl %eax
    
    # Invoke the interrupt block
    jmp F_END

# End the program
F_END:
    hlt
    movl $SYSEXIT, %eax
    movl $EXIT_SUCCESS, %ebx
    int $INTERUPT
   

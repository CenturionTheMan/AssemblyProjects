# The program subtracts two numbers, assuming they are of equal length.
# Result in gdb: - x /5x $esp
.section .data
number1: # First number (minuend)
    .long 0x10000000, 0x7000000F, 0x10000000, 0x02510000
    number1_len = (.-number1) # Number of bytes occupied by number1
    number1_amount = number1_len/4; # Number of 4-byte numbers in number1

number2: # Second number (subtrahend)
    .long 0xf0000000, 0x50000000, 0xF0000000, 0x01400000
    number2_len = (.-number2) # Number of bytes occupied by number2
    number2_amount = number2_len/4; # Number of 4-byte numbers in number2

# INTERMEDIATE RESULTS FOR THESE VALUES:
# ffffffff | (taken) 20000000 | 2000000e | (taken) 20000000 | 1110000

.section .text
.global _start

# Constant Declarations
SYSEXIT = 1
EXIT_SUCCESS = 0
INTERUPT = 0x80

# Entry point
_start:
    clc
    jmp F_MAIN_ADD

F_MAIN_ADD:
    # esi - Indexer for number1 and number2 variables
    movl $number1_amount, %esi

    LOOP_BEG:
        # Decrease the index
        decl %esi
        # Subtraction with borrow of sub-numbers
        movl number1(,%esi,4), %eax
    C1:
        sbbl number2(,%esi,4), %eax
        pushl %eax
    STACK_UPDATE:

        # Check if it's the end of the number and there is no borrow
        pushf
        cmpl $0, %esi
        je SUB_IF_OVERFLOW_EQUAL
        popf
        # Otherwise, go back to the beginning of the loop
        jmp LOOP_BEG 

SUB_IF_OVERFLOW_EQUAL:
    # If there is no borrow, finish
    popf
    jnc END
    # Reset the index
    xor %eax, %eax
    # Add the borrow if present
    movl $0xffffffff, %eax
    # Store the result at index 0 in the variable 'result'
    OVERFLOW:
    pushl %eax
    # Invoke the interrupt block
    jmp END

# End the program
END:
    hlt
    movl $SYSEXIT, %eax
    movl $EXIT_SUCCESS, %ebx
    int $INTERUPT

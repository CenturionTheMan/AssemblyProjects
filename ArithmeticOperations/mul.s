# Program multiplies two numbers

# show result int gdb: print /x (long[7]) result

.section .data
# Examples
# 1) 0x000000a0, 0x10000001 X 0x00000900, 0x10020000 = 5a09a 02402900 10020000
# 2) 0xab5329fe, 0x97eaf79e, 0x803610a2, 0x014f2379 X 0x987de98a, 0x65f7e9a3, 0x012f4e8a = 660DA4D5 FBCEC56E 83192B2D 109E0533 45204D6B 19619770 CDAEFD3A

number1: # First number
    .long 0xab5329fe, 0x97eaf79e, 0x803610a2, 0x014f2379
    number1_len = (.-number1) # Number of bytes occupied by number1
    number1_amount = number1_len/4; # Number of 4-byte numbers in number1

number2: # Second number
    .long 0x987de98a, 0x65f7e9a3, 0x012f4e8a
    number2_len = (.-number2) # Number of bytes occupied by number2
    number2_amount = number2_len/4; # Number of 4-byte numbers in number2

.section .bss
result:
    .space number1_len + number2_len

.section .text
.global _start

# Constant Declarations
SYSEXIT = 1
EXIT_SUCCESS = 0
INTERUPT = 0x80

# Entry point
# esi - Outside index
# edi - Inside index

_start:
    # Outside index edx - eax
    movl $number2_amount, %esi

LOOP_OUT:
    cmpl $0, %esi
    je END
    decl %esi
    # Inside index
    movl $number1_amount, %edi
    LOOP_IN:
        cmpl $0, %edi
        je LOOP_OUT
        decl %edi
        movl number2(,%esi,4), %eax
        movl number1(,%edi,4), %edx
        clc 
        mull %edx
        jmp YOUNGER_ADD

# Counter ecx addition
YOUNGER_ADD:
    movl %esi, %ecx
    addl %edi, %ecx
    incl %ecx
    temp:
    adcl %eax, result(,%ecx,4)
OLDER_ADD:
    decl %ecx
    adcl %edx, result(,%ecx,4)
    jc ADD_UNTIL_NO_CARRY
    jnc LOOP_IN

ADD_UNTIL_NO_CARRY:
    decl %ecx
    addl $1, result(,%ecx,4)
    jc ADD_UNTIL_NO_CARRY
    jnc LOOP_IN

# End
END:
    hlt
    movl $SYSEXIT, %eax
    movl $EXIT_SUCCESS, %ebx
    int $INTERUPT

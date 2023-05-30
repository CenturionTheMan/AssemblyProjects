.data

# f(x) = integral(x^2 + 7)

x_b: .double 0              # Lower bound of integration
x_e: .double 0              # Upper bound of integration
n: .double 0                # Number of intervals

dx: .double 0               # Delta x (interval width)
delta_x: .double 0          # Temporary variable for calculating dx
seven: .double 7.0          # Constant value 7.0

x_i: .double 0              # Current x value within an interval
f_i: .double 0              # Value of f(x) at x_i
current_index: .double 0    # Current index within the loop
sum_f: .double 0            # Accumulated sum of f_i values
result: .double 0           # Final result of the integral


ctrm_to_zero: .int 0b1111000011111111  # Mask for setting FPU control word to round to nearest and single precision (and)
ctrm_double:  .int 0b0000001000000000  # Mask for setting FPU control word to double precision (or)
ctrm_ldouble: .int 0b0000001100000000  # Mask for setting FPU control word to long double precision (or)
ctrm_down:    .int 0b0000010000000000  # Mask for setting FPU control word to round down (or)
ctrm_up:      .int 0b0000100000000000  # Mask for setting FPU control word to round up (or)
ctrm_cut:     .int 0b0000110000000000  # Mask for setting FPU control word to truncation (or)

ctrw: .int 0b1111111111000000  # FPU control word holder

.text

.global integral

integral:
    finit                   # Initialize the FPU (Floating-Point Unit) to prepare for floating-point operations

    call BASE_CW            # Call the BASE_CW subroutine to set the FPU control word for rounding mode

    call DOUBLE_P_CW        # Call the DOUBLE_P_CW subroutine to set the FPU control word for double precision

    # The %rsi register contains rounding type, check it and set
    cmpq $1, %rsi           # Compare the value in %rsi with 1 (rounding type for round up)
    je UP_R_CW              # If the comparison is true, jump to UP_R_CW label

    cmpq $2, %rsi           # Compare the value in %rsi with 2 (rounding type for round down)
    je DOWN_R_CW            # If the comparison is true, jump to DOWN_R_CW label

    cmpq $3, %rsi           # Compare the value in %rsi with 3 (rounding type for truncation)
    je CUT_R_CW             # If the comparison is true, jump to CUT_R_CW label


calculations:
    movsd %xmm0, x_e           # Initialize upper bound to given argument (upperBound)
    movsd %xmm1, x_b           # Initialize lower bound to given argument (lowerBound)
    mov %rdi, %rcx             # Initialize loop counter to given argument (iterationsAmount)

    cvtsi2sd %rdi, %xmm3       # Move the value from %rdi (iterationsAmount) to %xmm3 (convert int to double)
    movsd %xmm3, n             # Move the value of %xmm3 to n

    # Calculating dx
    fldl x_e                   # Load x_e into the FPU stack
    fsubl x_b                  # Subtract x_b from x_e
    fstl delta_x               # Store the result in delta_x
    fdivl n                    # Divide delta_x by n
    fstpl dx                   # Store the result in dx

calculating_rectangles:
    mov %rcx, current_index    # Move current_index to %rcx register for manipulation

    # Calculating x_i
    fldl current_index         # Load current_index into the FPU stack
    fdivl n                    # Divide current_index by n
    fmull delta_x              # Multiply the result by delta_x
    faddl x_b                  # Add x_b to the result
    fstpl x_i                  # Store the result in x_i

    # Calculating f_i
    fldl x_i                   # Load x_i into the FPU stack
    fmull x_i                  # Multiply x_i by itself
    faddl seven                # Add seven to the result

    # Adding f_i to sum_f
    faddl sum_f                # Add f_i to sum_f
    fstpl sum_f                # Store the result in sum_f

    dec %rcx                   # Decrement the loop counter
    cmp $0, %rcx               # Compare the loop counter with 0
    jne calculating_rectangles # If the loop counter is not 0, jump to calculating_rectangles

    fldl sum_f                 # Load sum_f into the FPU stack
    fmull dx                   # Multiply sum_f by dx
    fstpl result               # Store the result in result

    movsd result, %xmm0        # Move the double-precision floating-point value to xmm0 register

    ret



# float + round to closest
BASE_CW:
    fnstcw ctrw       # Store the current FPU control word
    movw ctrw, %bx    # Move the control word to bx register for manipulation
    and ctrm_to_zero, %bx   # Apply the mask to set rounding mode to round to nearest
    movw %bx, ctrw    # Move the modified control word back to ctrw
    fldcw ctrw        # Load the modified control word into FPU control register
    ret

DOUBLE_P_CW:
    fnstcw ctrw       # Store the current FPU control word
    movw ctrw, %bx    # Move the control word to bx register for manipulation
    xor ctrm_double, %bx   # Apply the mask to set rounding mode to round to double precision
    movw %bx, ctrw    # Move the modified control word back to ctrw
    fldcw ctrw        # Load the modified control word into FPU control register
    ret

LDOUBLE_P_CW:
    fnstcw ctrw       # Store the current FPU control word
    movw ctrw, %bx    # Move the control word to bx register for manipulation
    xor ctrm_ldouble, %bx  # Apply the mask to set rounding mode to round to long double precision
    movw %bx, ctrw    # Move the modified control word back to ctrw
    fldcw ctrw        # Load the modified control word into FPU control register
    ret

DOWN_R_CW:
    fnstcw ctrw       # Store the current FPU control word
    movw ctrw, %bx    # Move the control word to bx register for manipulation
    xor ctrm_down, %bx     # Apply the mask to set rounding mode to round down
    movw %bx, ctrw    # Move the modified control word back to ctrw
    fldcw ctrw        # Load the modified control word into FPU control register
    jmp calculations

UP_R_CW:
    fnstcw ctrw       # Store the current FPU control word
    movw ctrw, %bx    # Move the control word to bx register for manipulation
    xor ctrm_up, %bx       # Apply the mask to set rounding mode to round up
    movw %bx, ctrw    # Move the modified control word back to ctrw
    fldcw ctrw        # Load the modified control word into FPU control register
    jmp calculations

CUT_R_CW:
    fstcw ctrw        # Store the current FPU control word
    movw ctrw, %bx    # Move the control word to bx register for manipulation
    xor ctrm_cut, %bx      # Apply the mask to set rounding mode to truncation
    movw %bx, ctrw    # Move the modified control word back to ctrw
    fldcw ctrw        # Load the modified control word into FPU control register
    jmp calculations

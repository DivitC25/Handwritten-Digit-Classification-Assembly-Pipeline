.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi t0 x0 1
    add t1 x0 x0
    
loop_start:
    bge a1 t0 loop_continue
    li a0 36
    j exit
    
loop_continue:
    bge t1 a1 loop_end
    
    mv t2 t1
    slli t2 t2 2
    add t2 t2 a0
    lw t3 0(t2)
    
    blt t3 x0 else
    addi t1 t1 1
    j loop_continue
    
    else:
        sw x0 0(t2)
        addi t1 t1 1
        j loop_continue

loop_end:
    # Epilogue
    jr ra

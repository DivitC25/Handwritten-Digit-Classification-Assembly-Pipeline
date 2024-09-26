.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    add t0 x0 x0
    addi t1 x0 1
    add t3 x0 x0
    add t5 x0 x0
loop_start:
    bge a1 t1 loop_continue
    li a0 36
    j exit
loop_continue:
    bge t0 a1 loop_end
    mv t2 t0
    slli t2 t2 2
    add t2 t2 a0
    lw t4 0(t2)
    
    blt t3 t4 replace_max
    addi t0 t0 1
    j loop_continue
    
    replace_max:
        mv t3 t4
        mv t5 t0
        addi t0 t0 1
        j loop_continue

loop_end:
    # Epilogue
    mv a0 t5
    jr ra

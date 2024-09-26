.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    add t0 x0 x0
    add t1 x0 x0
    addi t2 x0 1
    add t3 x0 x0
    add t4 x0 x0
    
    bge a2 t2 condition_two
    li a0 36
    j exit
    
    condition_two:
        bge a3 t2 condition_three
        li a0 37
        j exit
    condition_three:
        bge a4 t2 loop_start
        li a0 37
        j exit
        
loop_start:
    bge t4 a2 loop_end
    
    mv a5 t0
    slli a5 a5 2
    add a5 a5 a0
    lw a5 0(a5)
    
    mv a6 t1
    slli a6 a6 2
    add a6 a6 a1
    lw a6 0(a6)
    
    mul a7 a5 a6
    add t3 t3 a7
    add t0 t0 a3
    add t1 t1 a4
    addi t4 t4 1
    
    j loop_start
    
loop_end:
    mv a0 t3
    jr ra

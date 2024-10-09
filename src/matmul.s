.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================

matmul:
    # Error checks
    li t0 1 
    blt a1 t0 error_outcome
    blt a2 t0 error_outcome
    blt a4 t0 error_outcome
    blt a5 t0 error_outcome
    bne a2 a4 error_outcome
    
    addi sp sp -16
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)

    mv t0 a6
    mv t1 x0
    mv t2 x0
    mv s0 a0
    mv s1 a3
    mv s2 x0
    mv s3 x0

outer_loop_start:
    bge t1 a1 outer_loop_end
    mv t2 x0
    mv s1 a3
inner_loop_start:
    bge t2 a5 inner_loop_end

    addi sp sp -44
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw a3 12(sp)
    sw a4 16(sp)
    sw a5 20(sp)
    sw a6 24(sp)
    sw t0 28(sp)
    sw t1 32(sp)
    sw t2 36(sp)
    sw ra 40(sp)
    
    mv a0 s0
    mv a1 s1
    mv a2 a4
    li a3 1
    mv a4 a5
    jal dot
    mv s2 a0

    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)
    lw a3 12(sp)
    lw a4 16(sp)
    lw a5 20(sp)
    lw a6 24(sp)
    lw t0 28(sp)
    lw t1 32(sp)
    lw t2 36(sp)
    lw ra 40(sp)
    
    addi sp sp 44
    sw s2 0(t0)
    addi t0 t0 4
    addi t2 t2 1
    slli s3 t2 2
    add s1 a3 s3
    
    j inner_loop_start

inner_loop_end:
    addi t1 t1 1
    slli s3 a2 2
    add s0 s0 s3
    j outer_loop_start

outer_loop_end:
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    addi sp sp 16
    jr ra
    
error_outcome:
    li a0 38
    j exit


.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0 5
    bne t0 a0 error_argc

    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)

    lw s0 4(a1)
    lw s1 8(a1)
    lw s2 12(a1)
    lw s3 16(a1)

    addi sp sp -8
    sw a2 0(sp)
    sw ra 4(sp)

    li a0 8
    jal malloc
    beq x0 a0 error_malloc

    mv s4 a0
    mv a1 a0
    addi a0 a0 4
    mv a2 a0
    mv a0 s0
    jal read_matrix
    mv s5 a0

    li a0 8
    jal malloc
    beq x0 a0 error_malloc

    mv s6 a0
    mv a1 a0
    addi a0 a0 4
    mv a2 a0
    mv a0 s1
    jal read_matrix
    mv s7 a0

    li a0 8
    jal malloc
    beq x0 a0 error_malloc

    mv s8 a0
    mv a1 a0
    addi a0 a0 4
    mv a2 a0
    mv a0 s2
    jal read_matrix
    mv s9 a0

    # Compute h = matmul(m0 input)
    lw t0 0(s4)
    lw t1 4(s8)
    mul s10 t0 t1
    slli a0 s10 2
    jal malloc
    beq x0 a0 error_malloc

    mv s11 a0
    mv a0 s5
    lw a1 0(s4)
    lw a2 4(s4)
    mv a3 s9
    lw a4 0(s8)
    lw a5 4(s8)
    mv a6 s11
    jal matmul

    # Compute h = relu(h)
    mv a0 s11
    mv a1 s10
    jal relu

    # Compute o = matmul(m1 h)
    lw t0 0(s6)
    lw t1 4(s8)
    mul s10 t0 t1
    slli a0 s10 2
    jal malloc
    beq x0 a0 error_malloc

    mv s3 a0   
    mv a0 s7
    lw a1 0(s6)
    lw a2 4(s6)
    mv a3 s11
    lw a4 0(s4)
    lw a5 4(s8)
    mv a6 s3
    jal matmul

    # Write output matrix o
    mv a0 s3
    mv a1 s3
    lw a2 0(s6)
    lw a3 4(s8)
    jal write_matrix

    # Compute and return argmax(o)
    mv a0 s3
    mv a1 s10
    jal argmax
    mv s3 a0

    # Free heap
    mv a0 s4
    jal free
    mv a0 s6
    jal free
    mv a0 s8
    jal free
    mv a0 s10
    jal free
    mv a0 s11
    jal free
    mv a0 s3
    jal free

    lw a2 0(sp)
    addi sp sp 4
    bne x0 a2 end
    mv a0 s3
    jal print_int
    li a0 '\n'
    jal print_char

end:
    mv a0 s3
    lw ra 0(sp)
    addi sp sp 4
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    addi sp sp 48
    jr ra

error_malloc:
    li a0 26
    j exit

error_argc:
    li a0 31
    j exit
.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -28
    sw s0 24(sp)
    sw s1 20(sp)
    sw s2 16(sp)
    sw ra 12(sp)
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    mv s1 x0
    li a1 0
    jal fopen
    
    #Error Handling
    li t0 -1
    beq a0 t0 error_open
    
    #fread error handling
    mv s0 a0
    li a2 4
    lw a1 4(sp)
    jal fread
    
    #case 1
    li t0 4
    bne a0 t0 error_fread
    
    li a2 4
    lw a1 0(sp)
    mv a0 s0
    jal fread
    
    #case 2
    li t0 4
    bne a0 t0 error_fread
    
    #malloc error handling
    lw t0 4(sp)
    lw t1 0(sp)
    lw t0 0(t0)
    lw t1 0(t1)
    mul a0 t0 t1
    mv s1 a0
    slli a0 a0 4
    jal malloc
    beq a0 x0 error_malloc
    
    mv s2 a0
    add t0 s2 x0
    add t1 x0 x0


loop_start:
    bge t1 s1 loop_end
    mv a0 s0
    mv a1 t0
    li a2 4
    
    addi sp sp -8
    sw t0 4(sp)
    sw t1 0(sp)
    jal fread
    lw t0 4(sp)
    lw t1 0(sp)
    addi sp sp 8
    
    addi t0 t0 4
    addi t1 t1 1
    j loop_start
    # Epilogue

loop_end:

    mv a0 s0
    jal fclose
    
    #fclose error handling
    li t0 -1
    beq a0 t0 error_close
    
    lw ra 12(sp)
    lw a0 8(sp)
    lw a1 4(sp)
    lw a2 0(sp)
    mv a0 s2
    lw s0 24(sp)
    lw s1 20(sp)
    lw s2 16(sp)
    addi sp sp 28
    jr ra
    
error_open:
    li a0 27
    j exit

error_fread:
    li a0 29
    j exit
    
error_malloc:
    li a0 26
    j exit
    
error_close:
    li a0 28
    j exit
    

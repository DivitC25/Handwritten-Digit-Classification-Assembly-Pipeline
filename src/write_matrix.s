.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    addi sp sp -16
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    addi sp sp -20
    sw ra 0(sp)
    sw a0 4(sp)
    sw a1 8(sp)
    sw a2 12(sp)
    sw a3 16(sp)
    
    mv s1 a1   
    mv s2 a2
    mv s3 a3
    
    li a1 1 
    jal fopen
    li t0 -1
    beq t0 a0 error_open
    mv s0 a0  
  
    addi a1 sp 12 
    li a2 1
    li a3 4
    jal fwrite
    li t0 1    
    bne t0 a0 error_write
    mv a0 s0
    addi a1 sp 16
    li a2 1
    li a3 4
    jal fwrite
    li t0 1    
    bne t0 a0 error_write
    mv a0 s0
    mul t0 s2 s3
    mv a1 s1
    mv a2 t0
    li a3 4
    jal fwrite
    mul t0 s2 s3     
    bne t0 a0 error_write

    mv a0 s0
    jal fclose
    li t0 -1
    beq a0 t0 error_close
    
    lw ra 0(sp)
    lw a0 4(sp)
    lw a1 8(sp)
    lw a2 12(sp)
    lw a3 16(sp)
    lw s0 20(sp)
    lw s1 24(sp)
    lw s2 28(sp)
    lw s3 32(sp)
    addi sp sp 36
    
    jr ra
    
error_open:
    li a0 27
    j exit
    
error_close:
    li a0 28
    j exit
    
error_write:
    li a0 30
    j exit

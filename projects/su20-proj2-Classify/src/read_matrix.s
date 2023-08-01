.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
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
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
    addi sp sp -4
    sw ra 0(sp)
    # Prologue
    # jal print_int
    # li a1 '\n'
    # jal print_char


	mv t0 a0 # filepath
    addi sp sp -8
    sw a1 0(sp) # the addr to set rows
    sw a2 4(sp) # the addr to set cols

    li a0 8 # alloc 8 bytes
    jal malloc
    beq a0 x0 malloc_error
    mv t3 a0 # the addr buf
    # li a0 8
    addi sp sp -4
    sw t3 0(sp) # need to free

    mv a1 t0 # filepath
    li a2 0 # read
    
    # jal print_str
    jal fopen
    blt a0 x0 fopen_error

    mv a1 a0 # fd
    mv a2 t3 # buf
    li a3 8
    jal fread
    bne a0 a3 fread_error
    mv t4 a1
    lw t1 0(a2) # rows
    lw t2 4(a2) # cols
    lw a0 0(sp)
    jal free
    addi sp sp 4
    
    lw a4 0(sp) 
    lw a5 4(sp)
    addi sp sp 8
    sw t1 0(a4)
    sw t2 0(a5)

    
    mul a3 t1 t2 # rows*cols
    slli a3 a3 2
    mv a0 a3 # alloc rows*cols*4 bytes
    jal malloc
    beq a0 x0 malloc_error
    mv t3 a0 # the addr buf
    # addi sp sp -8
    # sw a3 0(sp)
    # sw t3 4(sp) # need to free
    mv a1 t4
    mv a2 t3 # buf
    jal fread
    bne a0 a3 fread_error

    jal fclose
    bne a0 x0 fclose_error
    
    # Epilogue
    mv a0 a2


    # lw a1 0(a4)
    # jal print_int
    # li a1 ' '
    # jal print_char

    # lw a1 0(a5)
    # jal print_int
    # li a1 '\n'
    # jal print_char

    mv a1 a4
    mv a2 a5
    lw ra 0(sp)
    addi sp sp 4
    ret

malloc_error:
    li a1 48
    j exit2

fopen_error:
    li a1 50
    j exit2

fread_error:
    li a1 51
    j exit2

fclose_error:
    li a1 52
    j exit2
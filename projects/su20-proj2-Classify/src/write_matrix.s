.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
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
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:
    # mv a0 a1
    # li a1 10
    # li a2 1
    # jal print_int_array

    addi sp sp -4
    sw ra 0(sp)
    # Prologue
    mv t0 a0 # filepath
    mv t1 a1 # int*
    mv t2 a2 # rows
    mv t3 a3 # cols


    mv a1 t0 
    li a2 1
    jal fopen
    blt a0 x0 fopen_error

    # mv a1 a0 
    # jal print_int

    mv t0 a0 # fd
    addi sp sp -8
    sw t2 0(sp)
    sw t3 4(sp)

    # li a1 'i'
    # jal print_char
    # li a1 '\n'
    # jal print_char

    # jal print_int
    li a0 8
    jal malloc
    sw t2 0(a0)
    sw t3 4(a0)
    addi sp sp -4
    sw a0 0(sp)

    # li a1 2
    # li a2 1
    # jal print_int_array

    mv a1 t0
    mv a2 a0
    li a3 2
    li a4 4
    jal fwrite
    bne a0 a3 fwrite_error

    lw a0 0(sp)
    addi sp sp 4
    jal free

    # li a1 'j'
    # jal print_char
    # li a1 '\n'
    # jal print_char

    lw t2 0(sp)
    lw t3 4(sp)
    addi sp sp 8
    mv a1 t0
    mv a2 t1
    mul a3 t2 t3
    li a4 4
    jal fwrite
    bne a0 a3 fwrite_error

    jal fclose
    bne a0 x0 fclose_error

    # li a1 'j'
    # jal print_char
    # li a1 '\n'
    # jal print_char


    lw ra 0(sp)
    addi sp sp 4

    # li a1 'k'
    # jal print_char
    # li a1 '\n'
    # jal print_char
    ret

fopen_error:
    li a1 53
    j exit2

fwrite_error:
    li a1 54
    j exit2

fclose_error:
    li a1 55
    j exit2
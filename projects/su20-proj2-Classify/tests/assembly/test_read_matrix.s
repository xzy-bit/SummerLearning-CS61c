.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
#file_path: .asciiz "./inputs/test_read_matrix/test_input.bin"
file_path: .asciiz "./outputs/test_write_matrix/student_write_outputs.bin"

row: .word 0
col: .word 0
.text
main:
    # Read matrix into memory
    la a0 file_path

    la a1 row


    la a2 col
    
    
    jal read_matrix
    # Print out elements of matrix
    lw t0 0(a1)
    lw t1 0(a2)
    mv a1 t0
    mv a2 t1
    jal print_int_array


    # Terminate the program
    j exit
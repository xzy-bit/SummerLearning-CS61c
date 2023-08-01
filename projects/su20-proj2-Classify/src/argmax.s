.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    # li a1 10
    # li a2 1
    # jal print_int_array

    beq a1, x0, argmax_exit
    addi sp, sp, -4
    sw ra, 0(sp)
    # Prologue
    
loop_start:
    addi t0, x0, 0 # i=0
    mv t1 a1
    addi t2, a0, 0 # int *
    slli t1, t1, 2
    lw t3, 0(t2) # vector[0]
    addi t2, t2, 4
    addi t0 t0 4

loop_continue:
    # mv a1 t0
    # jal print_int
    # li a1 ' '
    # jal print_char
    # mv a1 t1 
    # jal print_int
    # li a1 ' '
    # jal print_char
    beq t0, t1, loop_end
    lw t4, 0(t2)
    auipc ra, 0
    addi ra, ra, 12
    # mv a1 t4
    # jal print_int
    # li a1 ' '
    # jal print_char
    bgt t4, t3, argmax_deal # if t0 <= t1 then target

    # mv a1 t3
    # jal print_int
    # li a1 ' '
    # jal print_char

    addi t2, t2, 4
    addi t0, t0, 4
    j loop_continue

argmax_deal:
    mv t3 t4
    srli a0, t0, 2
    jr ra

loop_end:
    lw ra, 0(sp)
    addi sp, sp, 4
    # Epilogue
    ret

argmax_exit:
    addi a0, x0, 7
    ret
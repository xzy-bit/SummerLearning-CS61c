.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    beq a1, x0, relu_exit
    addi sp, sp, -4
    sw ra, 0(sp)
    # Prologue

loop_start:
    addi t0, x0, 0 # i
    addi t1, a1, 0 # num of elements
    addi t2, a0, 0 # int *

    # mv a0 t2
    # li a1 1
    # li a2 3
    # jal print_int_array

    slli t1, t1, 2

loop_continue:
    beq t0 t1 loop_end
    lw t3, 0(t2)
    auipc ra, 0
    addi ra, ra, 12
    blt t3, x0, relu_deal # if t0 <= t1 then target
    addi t2, t2, 4
    addi t0, t0, 4
    j loop_continue

relu_deal:
    sw x0, 0(t2)
    jr ra

loop_end:
    lw ra, 0(sp)
    addi sp, sp, 4
    # Epilogue
	ret
relu_exit:
    addi a0, x0, 8
    ret

.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    beq a1, x0, dot_exit
    addi sp, sp, -4
    sw ra, 0(sp)
    # Prologue

loop_start:
    addi t0, a0, 0 # v0
    addi t1, a1, 0 # v1
    addi t2, x0, 0 # i
    addi a0, x0, 0 # output

loop_continue:
    beq t2, a2, loop_end
    mul t3, t2, a3 # i*s1
    mul t4, t2, a4 # i*s2
    slli t3, t3, 2
    slli t4, t4, 2
    add t3, t3, t0
    add t4, t4, t1
    lw t3, 0(t3)
    lw t4, 0(t4)
    mul t3, t3, t4
    add a0, a0, t3
    addi t2, t2, 1
    j loop_continue

loop_end:
    lw ra, 0(sp)
    addi sp, sp, 4
    # Epilogue
    ret

dot_exit:
    addi a0, x0, 6
    ret
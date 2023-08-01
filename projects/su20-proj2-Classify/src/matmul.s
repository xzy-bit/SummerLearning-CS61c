
.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    ble a0 x0 matmul_exit_2
    ble a2 x0 matmul_exit_2
    ble a4 x0 matmul_exit_3
    ble a5 x0 matmul_exit_3
    bne a2 a4 matmul_exit_4
    # Error checks
    addi sp sp -4
    sw ra 0(sp)
    # Prologue

outer_loop_start:
    addi t0 x0 0 # count = 0
    addi t1 x0 0 # i = 0

inner_loop_start:
    addi t2 x0 0 # j = 0

outer_loop_continue:
    jal ra inner_loop_continue
    addi t1 t1 1 # i++
    addi t2 x0 0 # j = 0
    beq t1 a1 outer_loop_end

inner_loop_continue:
    beq t2 a5 inner_loop_end
    mul t3 a2 t1 # c1*i
    slli t3 t3 2 
    slli t2 t2 2 # j>>2
    slli t0 t0 2 # count>>2
    add t4 a6 t0
    addi sp sp -40
    sw ra 0(sp)
    sw a0 4(sp)
    sw a1 8(sp)
    # sw a2 8(sp)
    sw a3 12(sp)
    sw a4 16(sp)
    sw t0 20(sp)
    sw t1 24(sp)
    sw t2 28(sp)
    sw t3 32(sp)
    sw t4 36(sp)
    add a0 a0 t3 # v0
    add a1 a3 t2 # v1
    addi a3 x0 1 # s1
    add a4 x0 a5 # s2
    jal ra dot
    lw t4 36(sp)
    sw a0 0(t4) # h[count] = value 
    lw ra 0(sp)
    lw a0 4(sp)
    lw a1 8(sp)
    # sw a2 8(sp)
    lw a3 12(sp)
    lw a4 16(sp)
    lw t0 20(sp)
    lw t1 24(sp)
    lw t2 28(sp)
    lw t3 32(sp)
    addi sp sp 40
    srli t2 t2 2 # j<<2
    addi t2 t2 1 # j++
    srli t0 t0 2 # count<<2
    addi t0 t0 1 # count++
    j inner_loop_continue
    
inner_loop_end:
    jr ra


outer_loop_end:
    lw ra 0(sp)
    addi sp sp 4
    # Epilogue
    ret

matmul_exit_2:
    addi a0 a0 2
    ret

matmul_exit_3:
    addi a0 a0 3
    ret

matmul_exit_4:
    addi a0 a0 4
    ret
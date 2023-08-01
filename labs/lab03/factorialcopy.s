.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi t1, a0, 0
    beq t1, x0, exit
    addi sp, sp, -8
    sw ra, 0(sp)
    sw t1, 4(sp)
    addi a0, a0, -1
    jal factorial
    lw ra, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    mul a0, a0, t1
    jr ra
    
exit:
    addi a0, x0, 1
    jr ra 

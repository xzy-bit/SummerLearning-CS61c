.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0 5
    bne a0 t0 invalid_input

    addi sp sp -4
    sw ra 0(sp)


    lw t1 4(a1) # m0
    lw t2 8(a1) # m1
    lw t3 12(a1) # input
    lw t4 16(a1) # output

    addi sp sp -16
    sw t1 0(sp)
    sw t2 4(sp)
    sw t3 8(sp)
    sw t4 12(sp)

    mv s5 a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    li a0 24 # 4*6 bytes
    jal malloc
    beq a0 x0 malloc_error
    mv s0 a0 # rows and cols
    
    # Load pretrained m0
    lw a0 0(sp)
    addi a1 s0 0
    addi a2 s0 4
    jal read_matrix
    mv s1 a0 # m0

    # li a1 'a'
    # jal print_char
    # li a1 '\n'
    # jal print_char


    # Load pretrained m1
    lw a0 4(sp)
    addi a1 s0 8
    addi a2 s0 12
    jal read_matrix
    mv s2 a0 # m1

    # li a1 'b'
    # jal print_char
    # li a1 '\n'
    # jal print_char


    # Load input matrix
    lw a0 8(sp)
    addi a1 s0 16
    addi a2 s0 20
    jal read_matrix
    mv s3 a0 # input

    # li a1 'c'
    # jal print_char
    # li a1 '\n'
    # jal print_char

    # mv a0 s0
    # li a1 1
    # li a2 6
    # jal print_int_array

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    mv t0 s0
    lw a1 0(t0) # m0 r
    lw a2 4(t0) # m0 c
    
    lw a4 16(t0) # r2
    lw a5 20(t0) # c2

    addi sp sp -8
    sw a1 0(sp) # m0 r
    sw a5 4(sp) # c2
    mul a0 a1 a5
    slli a0 a0 2
    jal malloc
    beq a0 x0 malloc_error
    

    lw a1 0(sp)
    mv a6 a0 # d of m0*input
    mv a0 s1 
    mv a3 s3
    jal matmul

    # mv a0 a6
    # li a1 1
    # li a2 3
    # jal print_int_array

    # li a1 'd'
    # jal print_char
    # li a1 '\n'
    # jal print_char

    lw a1 0(sp) # m0 r
    lw a5 4(sp) # c2
    addi sp sp 4
    mul a1 a1 a5 # elements
    sw a1 0(sp)
    mv a0 a6
    jal relu

    # li a1 'e'
    # jal print_char
    # li a1 '\n'
    # jal print_char

    # mv a0 a6
    # li a1 1
    # li a2 3
    # jal print_int_array

    mv a3 a6
    addi sp sp -4 # need to free
    sw a3 0(sp)

    lw a0 8(s0)
    slli a0 a0 2

    jal malloc
    beq a0 x0 malloc_error

    # li a1 'f'
    # jal print_char
    # li a1 '\n'
    # jal print_char
    

    # mv a0 s2
    # li a1 3
    # li a2 3
    # jal print_int_array

    # mv a0 s0
    # li a1 3
    # li a2 2
    # jal print_int_array


    lw a1 8(s0) # m1 r
    lw a2 12(s0) # m1 c
    lw a4 0(s0)
    li a5 1
    
    mv a6 a0
    mv a0 s2
    jal matmul #m1 * ReLU(m0 * input)

    # li a1 'g'
    # jal print_char
    # li a1 '\n'
    # jal print_char
    
    
    lw a0 0(sp)
    addi sp sp 4
    sw a6 0(sp) # save the addr of d
    jal free

    # lw a0 0(sp)
    # li a1 10
    # li a2 1
    # jal print_int_array


    # li a1 'h'
    # jal print_char
    # li a1 '\n'
    # jal print_char

    

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    

    # lw a0 0(sp)
    # li a1 1
    # li a2 3
    # jal print_int_array

    lw a0 16(sp)
    lw a1 0(sp)    
    lw a2 8(s0)
    li a3 1
    jal write_matrix

    # li a1 'i'
    # jal print_char
    # li a1 '\n'
    # jal print_char



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    

    # li a1 3
    # li a2 1
    # jal print_int_array
    lw a0 0(sp)
    lw a1 8(s0)
    jal argmax

    mv t0 a0
    mv a0 s0
    jal free

    lw a0 0(sp)
    jal free
    addi sp sp 20



    # Print classification
    bne s5 x0 classify_exit
    mv a1 t0
    jal print_int
    


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char


    lw ra 0(sp)
    addi sp sp 4
    ret

invalid_input:
    mv a1 a0
    jal print_int
    li a1 '\n'
    jal print_char
    li a1 49
    j exit2    

malloc_error:
    li a1 48
    j exit2

classify_exit:
    lw ra 0(sp)
    addi sp sp 4
    ret
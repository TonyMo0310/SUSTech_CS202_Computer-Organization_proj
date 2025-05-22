.data
    A: .word 0
    B: .word 0
    C: .word 0

.text
    la t1, A
    la t2, B
    la t6, C

main_loop:
    li a7, 5
    ecall
    
    li t0, 0
    beq a0, t0, case0
    li t0, 1
    beq a0, t0, case1 
    li t0, 2
    beq a0, t0, case2 
    li t0, 3
    beq a0, t0, case3
    li t0, 4
    beq a0, t0, case4
    li t0, 5
    beq a0, t0, case5
    li t0, 6
    beq a0, t0, case6
    li t0, 7
    beq a0, t0, case7
        
    jal x0, main_loop

case0:
    li a7, 5
    ecall
    sw a0, 0(t1)  # 存储到 A
    li a7, 1
    ecall
    
    li a7, 5
    ecall
    sw a0, 0(t2)  # 存储到 B
    li a7, 1
    ecall
    
    jal x0, main_loop

case1:
    li a7, 5
    ecall
    sb a0, 0(t1) 
    lb a0, 0(t1)
    li a7, 1
    ecall
    jal x0, main_loop

case2:
    li a7, 5
    ecall
    sb a0, 0(t2) 
    lbu a0, 0(t2)
    li a7, 1
    ecall
    jal x0, main_loop

case3:
    lw t3, 0(t1)
    lw t4, 0(t2)
    beq t3, t4, case3_eq
    li a0, 0
    jal x0, case3_show
case3_eq:
    li a0, 255
case3_show:
    li a7, 1
    ecall
    jal x0, main_loop

case4:
    lw t3, 0(t1)
    lw t4, 0(t2)
    blt t3, t4, case4_lt
    li a0, 0
    jal x0, case4_show
case4_lt:
    li a0, 255
case4_show:
    li a7, 1
    ecall
    jal x0, main_loop

case5:
    lw t3, 0(t1)
    lw t4, 0(t2)
    bltu t3, t4, case5_ltu
    li a0, 0
    jal x0, case5_show
case5_ltu:
    li a0, 255
case5_show:
    li a7, 1
    ecall
    jal x0, main_loop

case6:
    lw t3, 0(t1)
    lw t4, 0(t2)
    slt t5, t3, t4
    sw t5, 0(t6)
    lw a0, 0(t6)
    li a7, 1
    ecall
    jal x0, main_loop

case7:
    lw t3, 0(t1)
    lw t4, 0(t2)
    sltu t5, t3, t4
    sw t5, 0(t6)
    lw a0, 0(t6)
    li a7, 1
    ecall
    jal x0, main_loop
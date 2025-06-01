 	.text
	.globl main
    
main:
	addi s0,zero,-1024	#s0用于长期保存输入IO地址
	lw t0,(s0)
	srli t0,t0,8	#获取样例编号
	sw t0,(s0)	#显示当前样例编号（方便debug）
	#跳转对应案例
	li t1,0
	beq t0,t1,case0
	li t1,1
	beq t0,t1,case1
	li t1,2
	beq t0,t1,case2
	li t1,3
	beq t0,t1,case3
	li t1,4
	beq t0,t1,case4
	li t1,5
	beq t0,t1,case5
	li t1,6
	beq t0,t1,case6
	li t1,7
	beq t0,t1,case7
	j main	#异常情况直接重新选择
case0:
    	lw a0,(s0)
   	 # 输入在a0的低8位，输出到a1并返回给a0
    	mv a1, zero       # 结果初始为零
    	li t0, 0          # 循环计数器初始化
    	li s1,8
    
case0_loop_start:           # 开始循环处理每个bit

    	srl t4, a0, t0     # 提取当前位（t0指向的位）
    	andi t4, t4, 1     # 只取最低位
    
    	li t5, 7            # 计算目标移位量：原位i → 目标位(7 - i)
    	sub t5, t5, t0      # t5 = 7 - 当前循环计数器值
    
    	sll t6, t4, t5     # 将当前bit移动到对应位置
    	or a1, a1, t6       # 累加到结果寄存器

    	addi t0, t0, 1      # 增加循环计数器
    	blt t0, s1, case0_loop_start   # 循环直到处理完所有8位
    
    	mv a0, a1           # 将最终结果返回到a0
    	sw a0,(s0)
    	j main
case1:
	lw a0,(s0)	#提取数据
	andi a0,a0,0xFF	
	
	srli t0,a0,7	#取第8位
	andi t1,a0,1	#取第1位
	bne t1,t0,case1_no	#判断
	
	srli t0,a0,6
	andi t0,t0,1	#取第7位
	srli t1,a0,1
	andi t1,t1,1	#取第2位
	bne t1,t0,case1_no	#判断
	
	srli t0,a0,5
	andi t0,t0,1	#取第6位
	srli t1,a0,2
	andi t1,t1,1	#取第3位
	bne t1,t0,case1_no	#判断
	
	srli t0,a0,4
	andi t0,t0,1	#取第5位
	srli t1,a0,3
	andi t1,t1,1	#取第4位
	bne t1,t0,case1_no	#判断
	li t0,1
	sw t0,(s0)	#输出1，代表是回文
	j main
	case1_no:
	sw zero,(s0)	#输出0，代表不是回文
	j main
	
case2:
	lw a0,(s0)	#提取数据
	andi a0,a0,0xFF	
	addi t0,zero,1000 #第一个浮点数存储地址
	sw a0,(t0)	#存储浮点数
	
	srli t0,a0,7	#提取符号位
	srli t1,a0,4	#提取指数位
	andi t1,t1,7	#抹去符号位
	li t2,7
	andi t3,a0,0xF	#提取尾数位
	beq t1,t2,case2_s_1	#指数为7特殊情况，NAN或INF
	ori t3,t3,16	#加上隐藏的1
	li t4,7
	sub t4,t4,t1	#偏移尾数位数
	srl t3,t3,t4	#偏移
	beq t0,zero,case2_skip_1
	sub t3,zero,t3	#处理负数
	case2_skip_1:
	sw t3,(s0)	#从IO输出
	
	j case2_n
	case2_s_1:
	beq t3,zero,case2_inf_1	#尾数为0为INF
	#NAN
	li t0,100	#用127表示NAN
	sw t0,(s0)
	j case2_n
	case2_inf_1:
	li t0,127	#用127表示INF
	sw t0,(s0)
	case2_n:
	
	#处理第二个数
	
	lw a0,(s0)	#提取数据
	andi a0,a0,0xFF	
	addi t0,zero,1004 #第二个浮点数存储地址
	sw a0,(t0)	#存储浮点数
	
	srli t0,a0,7	#提取符号位
	srli t1,a0,4	#提取指数位
	andi t1,t1,7	#抹去符号位
	li t2,7
	andi t3,a0,0xF	#提取尾数位
	beq t1,t2,case2_s_2	#指数为7特殊情况，NAN或INF
	ori t3,t3,16	#加上隐藏的1
	li t4,7
	sub t4,t4,t1	#偏移尾数位数
	srl t3,t3,t4	#偏移
	beq t0,zero,case2_skip_2
	sub t3,zero,t3	#处理负数
	case2_skip_2:
	sw t3,(s0)	#从IO输出
	
	j main
	case2_s_2:
	beq t3,zero,case2_inf_2	#尾数为0为INF
	#NAN
	li t0,127	#用127表示NAN
	sw t0,(s0)
	j main
	case2_inf_2:
	li t0,127	#用127表示INF
	sw t0,(s0)
	j main
case3:
	addi t0,zero,1000	#第一个浮点数地址
	lw s1,(t0)	#取第一个浮点数
	addi t1,zero,1004	#第二个浮点数地址
	lw s2,(t1)	#取第二个浮点数
	
	li t1,7
	srli t0,s1,4	#第一个数
	andi t2,t0,7	#取指数位 t2
	beq  t2,t1,case3_s	#NaN或无穷
	
	#处理第一个数
	andi t4,s1,0xF	#取尾数
	beq t2,zero,case3_skip_1	#非规范数或0，跳过补1和移位
	
	ori t4,t4,0x10	#补1
	addi t0,t2,-1
	sll t4,t4,t0	#移位得到 ..XX.XXXX * 2^-2,
	case3_skip_1:
	srli t0,s1,7	#取符号位
	beq t0,zero,case3_skip_2
	sub t4,zero,t4	#负数取反
	case3_skip_2:
	
	srli t0,s2,4	#第二个数
	andi t3,t0,7	#取指数位 t3
	beq  t3,t1,case3_s	#NaN或无穷
	#处理第二个数
	andi t5,s2,0xF	#取尾数
	beq t3,zero,case3_skip_3	#非规范数或0，跳过补1和移位
	
	ori t5,t5,0x10	#补1
	addi t0,t3,-1
	sll t5,t5,t0	#移位得到 ...XX.XXXX * 2^-2,
	case3_skip_3:
	srli t0,s2,7	#取符号位
	beq t0,zero,case3_skip_4
	sub t5,zero,t5	#负数取反
	case3_skip_4:
	
	add t0,t4,t5 	#两数相加，得到XX.XXXXXX的形式
	srli t0,t0,6	#移位去掉小数位
	sw t0,(s0)	#输出答案至IO
	j main	#返回
	
	case3_s:
	li t0,127
	sw t0,(s0)	#NAN或无穷，输出127
	j main
case4:
	lw a0,(s0)	#传入数据
	andi a0,a0,0xFF
	li t6,19	#除数
	slli t0,a0,4	#移位做被除数
	
	srli t2,t0,7	#取最高位
	beq t2,zero,case4_skip1
	slli t1,t6,3
	xor t0,t0,t1
	case4_skip1:
	
	srli t2,t0,6	#取最高位
	beq t2,zero,case4_skip2
	slli t1,t6,2
	xor t0,t0,t1
	case4_skip2:
	
	srli t2,t0,5	#取最高位
	beq t2,zero,case4_skip3
	slli t1,t6,1
	xor t0,t0,t1
	case4_skip3:
	
	srli t2,t0,4	#取最高位
	beq t2,zero,case4_skip4
	mv t1,t6
	xor t0,t0,t1
	case4_skip4:
	
	
	andi t0,t0,0xF	#抹去其他位数
	slli t1,a0,4
	or a0,t1,t0	#拼合数据
	sw a0,(s0)	#输出至IO
	j main	#返回
	
case5:
	lw a0,(s0)	#传入数据
	andi a0,a0,0xFF
	mv t3,a0	#转移原数据
	andi t5,a0,0xF	#存校验码到t5
	srli a0,a0,4	#存原数据到a0
	li t6,19	#除数
	slli t0,a0,4	#移位做被除数
	
	srli t2,t0,7	#取最高位
	beq t2,zero,case5_skip1
	slli t1,t6,3
	xor t0,t0,t1
	case5_skip1:
	
	srli t2,t0,6	#取最高位
	beq t2,zero,case5_skip2
	slli t1,t6,2
	xor t0,t0,t1
	case5_skip2:
	
	srli t2,t0,5	#取最高位
	beq t2,zero,case5_skip3
	slli t1,t6,1
	xor t0,t0,t1
	case5_skip3:
	
	srli t2,t0,4	#取最高位
	beq t2,zero,case5_skip4
	mv t1,t6
	xor t0,t0,t1
	case5_skip4:
	
	
	andi t0,t0,0xF	#抹去其他位数
	slli t1,a0,4
	or a0,t1,t0	#拼合数据
	beq a0,t3,case5_yes
	sw zero,(s0) #不通过，返回0
	j main
	case5_yes:
	li t0,1
	sw t0,(s0)	#通过返回1
	j main	#返回
	
case6:
	lui t0,0xABCDE	#随便拿个数测试 :)
	sw t0,(s0)
	j main
case7:
	li t1,0	#测试寄存器
	jal t0,case7_test
	addi t1,t1,2	#按理不应该被执行
	lw t0,(s0)	#只是当中断用
	sw t1,(s0)	#应该输出和上一次输出一样的数
	lw t0,(s0)	#只是当中断用
	sw t2,(s0)	#输出jarl保存的地址
	j main	#润
	
case7_test:
	lw t1,(s0)
	andi t1,t1,0xFF
	addi t1,t1,1	#加个1，测试用
	sw t1,(s0)
	jalr t2,t0,4
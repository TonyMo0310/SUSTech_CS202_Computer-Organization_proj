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
	lw t0,(s0)
	sw t0,(s0)
	lw t0,(s0)
	sw t0,(s0)
	j main #返回
case1:
	li t0,1000	#内存地址 存放case1数据
	lw t1,(s0)
	li t3,255
	and t1,t3,t1
	sw t1,(s0)	#[7:0]
	lw t2,(s0)
	and t2,t2,t3
	slli t2,t2,8
	or t1,t2,t1 
	sw t1,(s0)	#[15:0]
	lw t2,(s0)
	and t2,t2,t3
	slli t2,t2,16
	or t1,t2,t1 
	sw t1,(s0)	#[23:0]
	lw t2,(s0)
	and t2,t2,t3
	slli t2,t2,24
	or t1,t2,t1 
	sw t1,(s0)	#[31:0]
	sw t1,(t0)	#保存最终数据
	lw zero,(s0)	#仅用作中断
	lb t1,(t0)	#取数据
	sw t1,(s0)	#展示
	j main	#返回
case2:
	li t0,1004	#内存地址 存放case2数据
	lw t1,(s0)
	li t3,255
	and t1,t3,t1
	sw t1,(s0)	#[7:0]
	lw t2,(s0)
	and t2,t2,t3
	slli t2,t2,8
	or t1,t2,t1 
	sw t1,(s0)	#[15:0]
	lw t2,(s0)
	and t2,t2,t3
	slli t2,t2,16
	or t1,t2,t1 
	sw t1,(s0)	#[23:0]
	lw t2,(s0)
	and t2,t2,t3
	slli t2,t2,24
	or t1,t2,t1 
	sw t1,(s0)	#[31:0]
	sw t1,(t0)	#保存最终数据
	lw zero,(s0)	#用作中断
	lbu t1,(t0)	#取数据
	sw t1,(s0)	#展示
	j main	#返回
case3:
	li t0,1000 #case1地址
	lw t0,(t0) #case1数据
	li t1,1004 #case2地址
	lw t1,(t1) #case2数据
	beq t0,t1,case3_yes
	#分支不成立
	li t0,0	#全0
	sw t0,(s0)
	j main
	case3_yes:#分支成立
	li t0,255	#全1
	sw t0,(s0)
	j main
case4:
	li t0,1000 #case1地址
	lw t0,(t0) #case1数据
	li t1,1004 #case2地址
	lw t1,(t1) #case2数据
	blt t0,t1,case4_yes
	#分支不成立
	li t0,0	#全0
	sw t0,(s0)
	j main
	case4_yes:#分支成立
	li t0,255	#全1
	sw t0,(s0)
	j main
case5:
	li t0,1000 #case1地址
	lw t0,(t0) #case1数据
	li t1,1004 #case2地址
	lw t1,(t1) #case2数据
	bltu t0,t1,case4_yes
	#分支不成立
	li t0,0	#全0
	sw t0,(s0)	#取数据
	j main
	case5_yes:#分支成立
	li t0,255	#全1
	sw t0,(s0)
	j main
case6:
	li t0,1000 #case1地址
	lw t0,(t0) #case1数据
	li t1,1004 #case2地址
	lw t1,(t1) #case2数据
	slt t0,t0,t1
	sw t0,(s0)
	j main
case7:
	li t0,1000 #case1地址
	lw t0,(t0) #case1数据
	li t1,1004 #case2地址
	lw t1,(t1) #case2数据
	sltu t0,t0,t1
	sw t0,(s0)
	j main
	

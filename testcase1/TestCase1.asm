 	.text
	.globl main
    
main:
	addi s0,zero,-1024	#s0���ڳ��ڱ�������IO��ַ
	lw t0,(s0)
	srli t0,t0,8	#��ȡ�������
	sw t0,(s0)	#��ʾ��ǰ������ţ�����debug��
	#��ת��Ӧ����
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
	j main	#�쳣���ֱ������ѡ��
case0:
	lw t0,(s0)
	sw t0,(s0)
	lw t0,(s0)
	sw t0,(s0)
	j main #����
case1:
	li t0,1000	#�ڴ��ַ ���case1����
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
	sw t1,(t0)	#������������
	lw zero,(s0)	#�������ж�
	lb t1,(t0)	#ȡ����
	sw t1,(s0)	#չʾ
	j main	#����
case2:
	li t0,1004	#�ڴ��ַ ���case2����
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
	sw t1,(t0)	#������������
	lw zero,(s0)	#�����ж�
	lbu t1,(t0)	#ȡ����
	sw t1,(s0)	#չʾ
	j main	#����
case3:
	li t0,1000 #case1��ַ
	lw t0,(t0) #case1����
	li t1,1004 #case2��ַ
	lw t1,(t1) #case2����
	beq t0,t1,case3_yes
	#��֧������
	li t0,0	#ȫ0
	sw t0,(s0)
	j main
	case3_yes:#��֧����
	li t0,255	#ȫ1
	sw t0,(s0)
	j main
case4:
	li t0,1000 #case1��ַ
	lw t0,(t0) #case1����
	li t1,1004 #case2��ַ
	lw t1,(t1) #case2����
	blt t0,t1,case4_yes
	#��֧������
	li t0,0	#ȫ0
	sw t0,(s0)
	j main
	case4_yes:#��֧����
	li t0,255	#ȫ1
	sw t0,(s0)
	j main
case5:
	li t0,1000 #case1��ַ
	lw t0,(t0) #case1����
	li t1,1004 #case2��ַ
	lw t1,(t1) #case2����
	bltu t0,t1,case4_yes
	#��֧������
	li t0,0	#ȫ0
	sw t0,(s0)	#ȡ����
	j main
	case5_yes:#��֧����
	li t0,255	#ȫ1
	sw t0,(s0)
	j main
case6:
	li t0,1000 #case1��ַ
	lw t0,(t0) #case1����
	li t1,1004 #case2��ַ
	lw t1,(t1) #case2����
	slt t0,t0,t1
	sw t0,(s0)
	j main
case7:
	li t0,1000 #case1��ַ
	lw t0,(t0) #case1����
	li t1,1004 #case2��ַ
	lw t1,(t1) #case2����
	sltu t0,t0,t1
	sw t0,(s0)
	j main
	

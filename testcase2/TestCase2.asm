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
    	lw a0,(s0)
   	 # ������a0�ĵ�8λ�������a1�����ظ�a0
    	mv a1, zero       # �����ʼΪ��
    	li t0, 0          # ѭ����������ʼ��
    	li s1,8
    
case0_loop_start:           # ��ʼѭ������ÿ��bit

    	srl t4, a0, t0     # ��ȡ��ǰλ��t0ָ���λ��
    	andi t4, t4, 1     # ֻȡ���λ
    
    	li t5, 7            # ����Ŀ����λ����ԭλi �� Ŀ��λ(7 - i)
    	sub t5, t5, t0      # t5 = 7 - ��ǰѭ��������ֵ
    
    	sll t6, t4, t5     # ����ǰbit�ƶ�����Ӧλ��
    	or a1, a1, t6       # �ۼӵ�����Ĵ���

    	addi t0, t0, 1      # ����ѭ��������
    	blt t0, s1, case0_loop_start   # ѭ��ֱ������������8λ
    
    	mv a0, a1           # �����ս�����ص�a0
    	sw a0,(s0)
    	j main
case1:
	lw a0,(s0)	#��ȡ����
	andi a0,a0,0xFF	
	
	srli t0,a0,7	#ȡ��8λ
	andi t1,a0,1	#ȡ��1λ
	bne t1,t0,case1_no	#�ж�
	
	srli t0,a0,6
	andi t0,t0,1	#ȡ��7λ
	srli t1,a0,1
	andi t1,t1,1	#ȡ��2λ
	bne t1,t0,case1_no	#�ж�
	
	srli t0,a0,5
	andi t0,t0,1	#ȡ��6λ
	srli t1,a0,2
	andi t1,t1,1	#ȡ��3λ
	bne t1,t0,case1_no	#�ж�
	
	srli t0,a0,4
	andi t0,t0,1	#ȡ��5λ
	srli t1,a0,3
	andi t1,t1,1	#ȡ��4λ
	bne t1,t0,case1_no	#�ж�
	li t0,1
	sw t0,(s0)	#���1�������ǻ���
	j main
	case1_no:
	sw zero,(s0)	#���0�������ǻ���
	j main
	
case2:
	lw a0,(s0)	#��ȡ����
	andi a0,a0,0xFF	
	addi t0,zero,1000 #��һ���������洢��ַ
	sw a0,(t0)	#�洢������
	
	srli t0,a0,7	#��ȡ����λ
	srli t1,a0,4	#��ȡָ��λ
	andi t1,t1,7	#Ĩȥ����λ
	li t2,7
	andi t3,a0,0xF	#��ȡβ��λ
	beq t1,t2,case2_s_1	#ָ��Ϊ7���������NAN��INF
	ori t3,t3,16	#�������ص�1
	li t4,7
	sub t4,t4,t1	#ƫ��β��λ��
	srl t3,t3,t4	#ƫ��
	beq t0,zero,case2_skip_1
	sub t3,zero,t3	#������
	case2_skip_1:
	sw t3,(s0)	#��IO���
	
	j case2_n
	case2_s_1:
	beq t3,zero,case2_inf_1	#β��Ϊ0ΪINF
	#NAN
	li t0,100	#��127��ʾNAN
	sw t0,(s0)
	j case2_n
	case2_inf_1:
	li t0,127	#��127��ʾINF
	sw t0,(s0)
	case2_n:
	
	#����ڶ�����
	
	lw a0,(s0)	#��ȡ����
	andi a0,a0,0xFF	
	addi t0,zero,1004 #�ڶ����������洢��ַ
	sw a0,(t0)	#�洢������
	
	srli t0,a0,7	#��ȡ����λ
	srli t1,a0,4	#��ȡָ��λ
	andi t1,t1,7	#Ĩȥ����λ
	li t2,7
	andi t3,a0,0xF	#��ȡβ��λ
	beq t1,t2,case2_s_2	#ָ��Ϊ7���������NAN��INF
	ori t3,t3,16	#�������ص�1
	li t4,7
	sub t4,t4,t1	#ƫ��β��λ��
	srl t3,t3,t4	#ƫ��
	beq t0,zero,case2_skip_2
	sub t3,zero,t3	#������
	case2_skip_2:
	sw t3,(s0)	#��IO���
	
	j main
	case2_s_2:
	beq t3,zero,case2_inf_2	#β��Ϊ0ΪINF
	#NAN
	li t0,127	#��127��ʾNAN
	sw t0,(s0)
	j main
	case2_inf_2:
	li t0,127	#��127��ʾINF
	sw t0,(s0)
	j main
case3:
	addi t0,zero,1000	#��һ����������ַ
	lw s1,(t0)	#ȡ��һ��������
	addi t1,zero,1004	#�ڶ�����������ַ
	lw s2,(t1)	#ȡ�ڶ���������
	
	li t1,7
	srli t0,s1,4	#��һ����
	andi t2,t0,7	#ȡָ��λ t2
	beq  t2,t1,case3_s	#NaN������
	
	#�����һ����
	andi t4,s1,0xF	#ȡβ��
	beq t2,zero,case3_skip_1	#�ǹ淶����0��������1����λ
	
	ori t4,t4,0x10	#��1
	addi t0,t2,-1
	sll t4,t4,t0	#��λ�õ� ..XX.XXXX * 2^-2,
	case3_skip_1:
	srli t0,s1,7	#ȡ����λ
	beq t0,zero,case3_skip_2
	sub t4,zero,t4	#����ȡ��
	case3_skip_2:
	
	srli t0,s2,4	#�ڶ�����
	andi t3,t0,7	#ȡָ��λ t3
	beq  t3,t1,case3_s	#NaN������
	#����ڶ�����
	andi t5,s2,0xF	#ȡβ��
	beq t3,zero,case3_skip_3	#�ǹ淶����0��������1����λ
	
	ori t5,t5,0x10	#��1
	addi t0,t3,-1
	sll t5,t5,t0	#��λ�õ� ...XX.XXXX * 2^-2,
	case3_skip_3:
	srli t0,s2,7	#ȡ����λ
	beq t0,zero,case3_skip_4
	sub t5,zero,t5	#����ȡ��
	case3_skip_4:
	
	add t0,t4,t5 	#������ӣ��õ�XX.XXXXXX����ʽ
	srli t0,t0,6	#��λȥ��С��λ
	sw t0,(s0)	#�������IO
	j main	#����
	
	case3_s:
	li t0,127
	sw t0,(s0)	#NAN��������127
	j main
case4:
	lw a0,(s0)	#��������
	andi a0,a0,0xFF
	li t6,19	#����
	slli t0,a0,4	#��λ��������
	
	srli t2,t0,7	#ȡ���λ
	beq t2,zero,case4_skip1
	slli t1,t6,3
	xor t0,t0,t1
	case4_skip1:
	
	srli t2,t0,6	#ȡ���λ
	beq t2,zero,case4_skip2
	slli t1,t6,2
	xor t0,t0,t1
	case4_skip2:
	
	srli t2,t0,5	#ȡ���λ
	beq t2,zero,case4_skip3
	slli t1,t6,1
	xor t0,t0,t1
	case4_skip3:
	
	srli t2,t0,4	#ȡ���λ
	beq t2,zero,case4_skip4
	mv t1,t6
	xor t0,t0,t1
	case4_skip4:
	
	
	andi t0,t0,0xF	#Ĩȥ����λ��
	slli t1,a0,4
	or a0,t1,t0	#ƴ������
	sw a0,(s0)	#�����IO
	j main	#����
	
case5:
	lw a0,(s0)	#��������
	andi a0,a0,0xFF
	mv t3,a0	#ת��ԭ����
	andi t5,a0,0xF	#��У���뵽t5
	srli a0,a0,4	#��ԭ���ݵ�a0
	li t6,19	#����
	slli t0,a0,4	#��λ��������
	
	srli t2,t0,7	#ȡ���λ
	beq t2,zero,case5_skip1
	slli t1,t6,3
	xor t0,t0,t1
	case5_skip1:
	
	srli t2,t0,6	#ȡ���λ
	beq t2,zero,case5_skip2
	slli t1,t6,2
	xor t0,t0,t1
	case5_skip2:
	
	srli t2,t0,5	#ȡ���λ
	beq t2,zero,case5_skip3
	slli t1,t6,1
	xor t0,t0,t1
	case5_skip3:
	
	srli t2,t0,4	#ȡ���λ
	beq t2,zero,case5_skip4
	mv t1,t6
	xor t0,t0,t1
	case5_skip4:
	
	
	andi t0,t0,0xF	#Ĩȥ����λ��
	slli t1,a0,4
	or a0,t1,t0	#ƴ������
	beq a0,t3,case5_yes
	sw zero,(s0) #��ͨ��������0
	j main
	case5_yes:
	li t0,1
	sw t0,(s0)	#ͨ������1
	j main	#����
	
case6:
	lui t0,0xABCDE	#����ø������� :)
	sw t0,(s0)
	j main
case7:
	li t1,0	#���ԼĴ���
	jal t0,case7_test
	addi t1,t1,2	#����Ӧ�ñ�ִ��
	lw t0,(s0)	#ֻ�ǵ��ж���
	sw t1,(s0)	#Ӧ���������һ�����һ������
	lw t0,(s0)	#ֻ�ǵ��ж���
	sw t2,(s0)	#���jarl����ĵ�ַ
	j main	#��
	
case7_test:
	lw t1,(s0)
	andi t1,t1,0xFF
	addi t1,t1,1	#�Ӹ�1��������
	sw t1,(s0)
	jalr t2,t0,4
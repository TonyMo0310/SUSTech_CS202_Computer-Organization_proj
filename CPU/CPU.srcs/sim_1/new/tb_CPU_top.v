`timescale 1ns / 1ps

module tb_CPU_top;
    // �����ź�
    reg clk;
    reg rst;
    reg [31:0] IOin;

    // ����ź�
    wire [31:0] IOout;

    // �м��ź�
    wire [31:0] instruction;

    // ָ���ڴ棨��ģ�⣩
    reg [31:0] instruction_memory [0:255];

    // ʵ���� CPU_top
    CPU_top uut (
        .clk(clk),
        .rst(rst)
    );

    // ʱ������
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20 ns ʱ������
    end

    // ��λ�Ͳ�������
    initial begin
        // ��ʼ���ź�
        rst = 1;
        IOin = 32'hA5A5A5A5; // �ṩ��Ч�� IO ����

        // Ԥ����ָ���ڴ�
        instruction_memory[0] = 32'h00000083; // lb x1, 0(x0)
        instruction_memory[1] = 32'h00000103; // lh x2, 0(x0)
        instruction_memory[2] = 32'h00000183; // lw x3, 0(x0)
        instruction_memory[3] = 32'h00A00023; // sb x10, 0(x0)
        instruction_memory[4] = 32'h00B000A3; // sh x11, 0(x0)
        instruction_memory[5] = 32'h00C00123; // sw x12, 0(x0)

        // ��λ
        #5 rst = 0;

        // ����һ��ʱ���Թ۲첨��
        #1000 $finish;
    end

    // ģ��ָ���ڴ��ȡ
    assign instruction = instruction_memory[uut.pc[15:2]];

endmodule
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
        instruction_memory[3] = 32'h00000203; // lbu x4, 0(x0)
        instruction_memory[4] = 32'h00000283; // lhu x5, 0(x0)
        instruction_memory[5] = 32'h00A00023; // sb x10, 0(x0)
        instruction_memory[6] = 32'h00B000A3; // sh x11, 0(x0)
        instruction_memory[7] = 32'h00C00123; // sw x12, 0(x0)

        // ��ӡ��ʼ����Ϣ
        $display("Starting simulation at time 0 ns");
        $display("Initial IOin value: 0x%h", IOin);
        $display("Instruction memory loaded with %d instructions", 8);

        // ��λ
        #5 rst = 0;
        $display("Reset released at time %0t ns", $time);

        // ����һ��ʱ���Թ۲첨��
        #1000 $display("Simulation finished at time %0t ns", $time);
        $finish;
    end

    // ģ��ָ���ڴ��ȡ
    assign instruction = instruction_memory[uut.pc[15:2]];

    // ��ӡ����ָ��Ľ��
    always @(posedge clk) begin
        if (uut.MEMen && !uut.memWrite && uut.readData !== 32'hXXXXXXXX) begin // ����ָ��ִ��ʱ�� readData �Ѷ���
            case (uut.dataMem.memOp)
                3'b000: $display("Time %0t ns: lb  executed, readData = 0x%h", $time, uut.readData);
                3'b001: $display("Time %0t ns: lh  executed, readData = 0x%h", $time, uut.readData);
                3'b010: $display("Time %0t ns: lw  executed, readData = 0x%h", $time, uut.readData);
                3'b100: $display("Time %0t ns: lbu executed, readData = 0x%h", $time, uut.readData);
                3'b101: $display("Time %0t ns: lhu executed, readData = 0x%h", $time, uut.readData);
            endcase
        end
    end

    // ��ӡ�洢ָ�����Ϣ
    always @(posedge clk) begin
        if (uut.MEMen && uut.memWrite && uut.dataMem.writeData !== 32'hXXXXXXXX) begin // �洢ָ��ִ��ʱ�� writeData �Ѷ���
            case (uut.dataMem.memOp)
                3'b000: $display("Time %0t ns: sb  executed, writeData = 0x%h", $time, uut.dataMem.writeData);
                3'b001: $display("Time %0t ns: sh  executed, writeData = 0x%h", $time, uut.dataMem.writeData);
                3'b010: $display("Time %0t ns: sw  executed, writeData = 0x%h", $time, uut.dataMem.writeData);
            endcase
        end
    end

endmodule
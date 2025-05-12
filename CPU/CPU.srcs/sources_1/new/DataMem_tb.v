`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12
// Design Name: 
// Module Name: DataMem_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for DataMem module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DataMem_tb;
    // �����ź�
    reg [31:0] address;
    reg [2:0] memOp;
    reg memWrite;
    reg [31:0] writeData;
    reg clk;
    reg rst;
    reg [31:0] IOin;
    reg MEMen;

    // ����ź�
    wire [31:0] readData;
    wire [31:0] IOout;

    // �ڲ��źţ����� RAM ģ�飩
    wire [31:0] ramOut;
    reg [31:0] ramIn;
    reg writeMem;

    // ʵ���� DataMem ģ��
    DataMem dut (
        .address(address),
        .memOp(memOp),
        .memWrite(memWrite),
        .writeData(writeData),
        .clk(clk),
        .rst(rst),
        .IOin(IOin),
        .MEMen(MEMen),
        .readData(readData),
        .IOout(IOout)
    );

    // ʱ������
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns ����
    end

    // �����ź�
    initial begin
        rst = 1;
        #15 rst = 0; // 15 ns ���ͷŸ�λ
    end

    // ��������
    initial begin
        // ��ʼ��
        address = 32'h00000000;
        memOp = 3'b000;
        memWrite = 0;
        writeData = 32'h00000000;
        IOin = 32'hA5A5A5A5;
        MEMen = 0;
        #20;

        // ��ʼ���ڴ� (ͨ�� RAM д��)
        address = 32'h00000000;
        memOp = 3'b010; // lw ģʽ��ȷ����ȡ������
        memWrite = 1;
        writeMem = 1;   // ���� RAM д
        writeData = 32'hAABBCCDD; // ��ʼ�� mem[0]
        MEMen = 1;
        #10;
        MEMen = 0;
        writeMem = 0;
        #10;

        // ���� lb (�����ֽڣ�������չ)
        address = 32'h00000000;
        memOp = 3'b000; // lb
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lb Test: address=0x%h, readData=0x%h (expected 0xFFFFFFDD)", address, readData);
        MEMen = 0;
        #10;

        // ���� lh (���ذ��֣�������չ)
        address = 32'h00000000;
        memOp = 3'b001; // lh
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lh Test: address=0x%h, readData=0x%h (expected 0xFFFFCCDD)", address, readData);
        MEMen = 0;
        #10;

        // ���� lw (������)
        address = 32'h00000000;
        memOp = 3'b010; // lw
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lw Test: address=0x%h, readData=0x%h (expected 0xAABBCCDD)", address, readData);
        MEMen = 0;
        #10;

        // ���� lbu (�����ֽڣ�����չ)
        address = 32'h00000000;
        memOp = 3'b100; // lbu
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lbu Test: address=0x%h, readData=0x%h (expected 0x000000DD)", address, readData);
        MEMen = 0;
        #10;

        // ���� lhu (���ذ��֣�����չ)
        address = 32'h00000000;
        memOp = 3'b101; // lhu
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lhu Test: address=0x%h, readData=0x%h (expected 0x0000CCDD)", address, readData);
        MEMen = 0;
        #10;

        // ���� sb (�洢�ֽ�)
        address = 32'h00000000;
        memOp = 3'b000; // sb
        memWrite = 1;
        writeData = 32'h11223344; // ����ֽ� 44
        MEMen = 1;
        #10;
        $display("sb Test: address=0x%h, writeData=0x%h (expected 0x11223344)", address, writeData);
        MEMen = 0;
        #10;

        // ���� sh (�洢����)
        address = 32'h00000000;
        memOp = 3'b001; // sh
        memWrite = 1;
        writeData = 32'h55667788; // ��Ͱ��� 7788
        MEMen = 1;
        #10;
        $display("sh Test: address=0x%h, writeData=0x%h (expected 0x55667788)", address, writeData);
        MEMen = 0;
        #10;

        // ���� sw (�洢��)
        address = 32'h00000000;
        memOp = 3'b010; // sw
        memWrite = 1;
        writeData = 32'h99AABBCC;
        MEMen = 1;
        #10;
        $display("sw Test: address=0x%h, writeData=0x%h (expected 0x99AABBCC)", address, writeData);
        MEMen = 0;
        #10;

        // ���� MMIO ��ȡ
        address = 32'hFFFFFC00;
        memOp = 3'b000;
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("MMIO Read Test: address=0x%h, readData=0x%h (expected 0xA5A5A5A5)", address, readData);
        MEMen = 0;
        #10;

        // ���� MMIO д��
        address = 32'hFFFFFC00;
        memOp = 3'b000;
        memWrite = 1;
        writeData = 32'h12345678;
        MEMen = 1;
        #10;
        $display("MMIO Write Test: address=0x%h, IOout=0x%h (expected 0x12345678)", address, IOout);
        MEMen = 0;
        #10;

        // ���Խ���
        $finish;
    end

    // ���ӵ� RAM ģ����ź�
    always @* begin
        writeMem = MEMen & memWrite & (address != 32'hFFFFFC00); // ���ڷ� IO ��ַʱд�� RAM
    end
endmodule
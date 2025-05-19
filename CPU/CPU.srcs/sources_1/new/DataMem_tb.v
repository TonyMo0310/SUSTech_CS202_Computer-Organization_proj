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
// Description: Testbench for DataMem module with ramIn and ramOut testing
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
    wire [31:0] ramIn;  // ���ӵ� DataMem �� ramIn
    wire [31:0] ramOut; // ���ӵ� DataMem �� ramOut

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

    // �����ڲ��ź� ramIn �� ramOut
    assign ramIn = dut.ramIn;
    assign ramOut = dut.ramOut;

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
        memOp = 3'b010; // sw ģʽ��ȷ��д��������
        memWrite = 1;
        writeData = 32'hAABBCCDD; // ��ʼ�� mem[0]
        MEMen = 1;
        #10;
        $display("Init: ramIn=0x%h (expected 0xAABBCCDD)", ramIn);
        MEMen = 0;
        #10;
        $display("Init: ramOut=0x%h (expected 0xAABBCCDD)", ramOut);

        // ���� 1: lb (��ȡ�ֽڣ���֤ ramOut)
        address = 32'h00000000;
        memOp = 3'b000; // lb
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("Test 1: lb, ramOut=0x%h (expected 0xAABBCCDD), readData=0x%h (expected 0xFFFFFFDD)", ramOut, readData);
        MEMen = 0;
        #10;

        // ���� 2: sb (�洢�ֽڣ���֤ ramIn)
        address = 32'h00000000;
        memOp = 3'b000; // sb
        memWrite = 1;
        writeData = 32'h11223344; // ����ֽ� 44
        MEMen = 1;
        #10;
        $display("Test 2: sb, ramIn=0x%h (expected 0xAABBCC44)", ramIn);
        MEMen = 0;
        #10;

        // ���� 3: sh (�洢���֣���֤ ramIn)
        address = 32'h00000000;
        memOp = 3'b001; // sh
        memWrite = 1;
        writeData = 32'h55667788; // ��Ͱ��� 7788
        MEMen = 1;
        #10;
        $display("Test 3: sh, ramIn=0x%h (expected 0xAABB7788)", ramIn);
        MEMen = 0;
        #10;

        // ���� 4: sw (�洢�֣���֤ ramIn)
        address = 32'h00000000;
        memOp = 3'b010; // sw
        memWrite = 1;
        writeData = 32'h99AABBCC;
        MEMen = 1;
        #10;
        $display("Test 4: sw, ramIn=0x%h (expected 0x99AABBCC)", ramIn);
        MEMen = 0;
        #10;

        // ���� 5: lw (��ȡ�֣���֤ ramOut)
        address = 32'h00000000;
        memOp = 3'b010; // lw
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("Test 5: lw, ramOut=0x%h (expected 0x99AABBCC), readData=0x%h (expected 0x99AABBCC)", ramOut, readData);
        MEMen = 0;
        #10;

        // ���� 6: IO ��ַд�루��֤ ramIn ��Ӱ�� RAM��
        address = 32'hFFFFFC00;
        memOp = 3'b000;
        memWrite = 1;
        writeData = 32'h12345678;
        MEMen = 1;
        #10;
        $display("Test 6: IO Write, ramIn=0x%h (not written to RAM), IOout=0x%h (expected 0x12345678)", ramIn, IOout);
        MEMen = 0;
        #10;

        // ���Խ���
        $finish;
    end

    // ���μ�¼
    initial begin
        $dumpfile("datamem_tb.vcd");
        $dumpvars(0, DataMem_tb);
    end
endmodule
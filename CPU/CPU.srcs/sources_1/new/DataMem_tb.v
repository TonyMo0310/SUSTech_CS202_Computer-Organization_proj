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
    // 输入信号
    reg [31:0] address;
    reg [2:0] memOp;
    reg memWrite;
    reg [31:0] writeData;
    reg clk;
    reg rst;
    reg [31:0] IOin;
    reg MEMen;

    // 输出信号
    wire [31:0] readData;
    wire [31:0] IOout;
    wire [31:0] ramIn;  // 连接到 DataMem 的 ramIn
    wire [31:0] ramOut; // 连接到 DataMem 的 ramOut

    // 实例化 DataMem 模块
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

    // 连接内部信号 ramIn 和 ramOut
    assign ramIn = dut.ramIn;
    assign ramOut = dut.ramOut;

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns 周期
    end

    // 重置信号
    initial begin
        rst = 1;
        #15 rst = 0; // 15 ns 后释放复位
    end

    // 测试用例
    initial begin
        // 初始化
        address = 32'h00000000;
        memOp = 3'b000;
        memWrite = 0;
        writeData = 32'h00000000;
        IOin = 32'hA5A5A5A5;
        MEMen = 0;
        #20;

        // 初始化内存 (通过 RAM 写入)
        address = 32'h00000000;
        memOp = 3'b010; // sw 模式，确保写入完整字
        memWrite = 1;
        writeData = 32'hAABBCCDD; // 初始化 mem[0]
        MEMen = 1;
        #10;
        $display("Init: ramIn=0x%h (expected 0xAABBCCDD)", ramIn);
        MEMen = 0;
        #10;
        $display("Init: ramOut=0x%h (expected 0xAABBCCDD)", ramOut);

        // 测试 1: lb (读取字节，验证 ramOut)
        address = 32'h00000000;
        memOp = 3'b000; // lb
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("Test 1: lb, ramOut=0x%h (expected 0xAABBCCDD), readData=0x%h (expected 0xFFFFFFDD)", ramOut, readData);
        MEMen = 0;
        #10;

        // 测试 2: sb (存储字节，验证 ramIn)
        address = 32'h00000000;
        memOp = 3'b000; // sb
        memWrite = 1;
        writeData = 32'h11223344; // 最低字节 44
        MEMen = 1;
        #10;
        $display("Test 2: sb, ramIn=0x%h (expected 0xAABBCC44)", ramIn);
        MEMen = 0;
        #10;

        // 测试 3: sh (存储半字，验证 ramIn)
        address = 32'h00000000;
        memOp = 3'b001; // sh
        memWrite = 1;
        writeData = 32'h55667788; // 最低半字 7788
        MEMen = 1;
        #10;
        $display("Test 3: sh, ramIn=0x%h (expected 0xAABB7788)", ramIn);
        MEMen = 0;
        #10;

        // 测试 4: sw (存储字，验证 ramIn)
        address = 32'h00000000;
        memOp = 3'b010; // sw
        memWrite = 1;
        writeData = 32'h99AABBCC;
        MEMen = 1;
        #10;
        $display("Test 4: sw, ramIn=0x%h (expected 0x99AABBCC)", ramIn);
        MEMen = 0;
        #10;

        // 测试 5: lw (读取字，验证 ramOut)
        address = 32'h00000000;
        memOp = 3'b010; // lw
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("Test 5: lw, ramOut=0x%h (expected 0x99AABBCC), readData=0x%h (expected 0x99AABBCC)", ramOut, readData);
        MEMen = 0;
        #10;

        // 测试 6: IO 地址写入（验证 ramIn 不影响 RAM）
        address = 32'hFFFFFC00;
        memOp = 3'b000;
        memWrite = 1;
        writeData = 32'h12345678;
        MEMen = 1;
        #10;
        $display("Test 6: IO Write, ramIn=0x%h (not written to RAM), IOout=0x%h (expected 0x12345678)", ramIn, IOout);
        MEMen = 0;
        #10;

        // 测试结束
        $finish;
    end

    // 波形记录
    initial begin
        $dumpfile("datamem_tb.vcd");
        $dumpvars(0, DataMem_tb);
    end
endmodule
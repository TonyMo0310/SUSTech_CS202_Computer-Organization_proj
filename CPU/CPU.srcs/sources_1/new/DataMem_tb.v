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

    // 内部信号（访问 RAM 模块）
    wire [31:0] ramOut;
    reg [31:0] ramIn;
    reg writeMem;

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
        memOp = 3'b010; // lw 模式，确保读取完整字
        memWrite = 1;
        writeMem = 1;   // 启用 RAM 写
        writeData = 32'hAABBCCDD; // 初始化 mem[0]
        MEMen = 1;
        #10;
        MEMen = 0;
        writeMem = 0;
        #10;

        // 测试 lb (加载字节，符号扩展)
        address = 32'h00000000;
        memOp = 3'b000; // lb
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lb Test: address=0x%h, readData=0x%h (expected 0xFFFFFFDD)", address, readData);
        MEMen = 0;
        #10;

        // 测试 lh (加载半字，符号扩展)
        address = 32'h00000000;
        memOp = 3'b001; // lh
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lh Test: address=0x%h, readData=0x%h (expected 0xFFFFCCDD)", address, readData);
        MEMen = 0;
        #10;

        // 测试 lw (加载字)
        address = 32'h00000000;
        memOp = 3'b010; // lw
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lw Test: address=0x%h, readData=0x%h (expected 0xAABBCCDD)", address, readData);
        MEMen = 0;
        #10;

        // 测试 lbu (加载字节，零扩展)
        address = 32'h00000000;
        memOp = 3'b100; // lbu
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lbu Test: address=0x%h, readData=0x%h (expected 0x000000DD)", address, readData);
        MEMen = 0;
        #10;

        // 测试 lhu (加载半字，零扩展)
        address = 32'h00000000;
        memOp = 3'b101; // lhu
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("lhu Test: address=0x%h, readData=0x%h (expected 0x0000CCDD)", address, readData);
        MEMen = 0;
        #10;

        // 测试 sb (存储字节)
        address = 32'h00000000;
        memOp = 3'b000; // sb
        memWrite = 1;
        writeData = 32'h11223344; // 最低字节 44
        MEMen = 1;
        #10;
        $display("sb Test: address=0x%h, writeData=0x%h (expected 0x11223344)", address, writeData);
        MEMen = 0;
        #10;

        // 测试 sh (存储半字)
        address = 32'h00000000;
        memOp = 3'b001; // sh
        memWrite = 1;
        writeData = 32'h55667788; // 最低半字 7788
        MEMen = 1;
        #10;
        $display("sh Test: address=0x%h, writeData=0x%h (expected 0x55667788)", address, writeData);
        MEMen = 0;
        #10;

        // 测试 sw (存储字)
        address = 32'h00000000;
        memOp = 3'b010; // sw
        memWrite = 1;
        writeData = 32'h99AABBCC;
        MEMen = 1;
        #10;
        $display("sw Test: address=0x%h, writeData=0x%h (expected 0x99AABBCC)", address, writeData);
        MEMen = 0;
        #10;

        // 测试 MMIO 读取
        address = 32'hFFFFFC00;
        memOp = 3'b000;
        memWrite = 0;
        MEMen = 1;
        #10;
        $display("MMIO Read Test: address=0x%h, readData=0x%h (expected 0xA5A5A5A5)", address, readData);
        MEMen = 0;
        #10;

        // 测试 MMIO 写入
        address = 32'hFFFFFC00;
        memOp = 3'b000;
        memWrite = 1;
        writeData = 32'h12345678;
        MEMen = 1;
        #10;
        $display("MMIO Write Test: address=0x%h, IOout=0x%h (expected 0x12345678)", address, IOout);
        MEMen = 0;
        #10;

        // 测试结束
        $finish;
    end

    // 连接到 RAM 模块的信号
    always @* begin
        writeMem = MEMen & memWrite & (address != 32'hFFFFFC00); // 仅在非 IO 地址时写入 RAM
    end
endmodule
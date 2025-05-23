`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19
// Design Name: 
// Module Name: RAM_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for RAM module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module RAM_tb;
    // 输入信号
    reg clk;
    reg wea;
    reg [13:0] addra; // 14 位地址，来自 address[15:2]
    reg [31:0] dina;

    // 输出信号
    wire [31:0] douta;

    // 实例化 RAM 模块
    RAM udram (
        .clka(clk),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(douta)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns 周期
    end

    // 测试用例
    initial begin
        // 初始化
        wea = 0;
        addra = 14'h0000;
        dina = 32'h00000000;
        #20;

        // 测试 1: 基本读写（地址 0）
        wea = 1;                // 启用写入
        addra = 14'h0000;       // 地址 0
        dina = 32'hAABBCCDD;    // 写入数据
        #10;
        wea = 0;                // 切换到读取
        #10;
        $display("Test 1: Basic Read/Write at address 0x%h, douta=0x%h (expected 0xAABBCCDD)", addra, douta);
        if (douta == 32'hAABBCCDD)
            $display("Test 1 Passed");
        else
            $display("Test 1 Failed");

        // 测试 2: 连续地址读写（地址 1 和 2）
        wea = 1;
        addra = 14'h0001;       // 地址 1
        dina = 32'h11223344;
        #10;
        addra = 14'h0002;       // 地址 2
        dina = 32'h55667788;
        #10;
        wea = 0;
        #10;
        addra = 14'h0001;       // 读取地址 1
        #10;
        $display("Test 2a: Read at address 0x%h, douta=0x%h (expected 0x11223344)", addra, douta);
        if (douta == 32'h11223344)
            $display("Test 2a Passed");
        else
            $display("Test 2a Failed");
        addra = 14'h0002;       // 读取地址 2
        #10;
        $display("Test 2b: Read at address 0x%h, douta=0x%h (expected 0x55667788)", addra, douta);
        if (douta == 32'h55667788)
            $display("Test 2b Passed");
        else
            $display("Test 2b Failed");

        // 测试 3: 边界地址（最大地址 16383）
        wea = 1;
        addra = 14'h3FFF;       // 最大地址 16383 (2^14 - 1)
        dina = 32'h99AABBCC;
        #10;
        wea = 0;
        #10;
        $display("Test 3: Read at address 0x%h, douta=0x%h (expected 0x99AABBCC)", addra, douta);
        if (douta == 32'h99AABBCC)
            $display("Test 3 Passed");
        else
            $display("Test 3 Failed");

        // 测试 4: 覆盖测试（检查未写入地址）
        addra = 14'h0003;       // 未写入的地址 3
        #10;
        $display("Test 4: Read at address 0x%h, douta=0x%h (expected 0x00000000)", addra, douta);
        if (douta == 32'h00000000) // 假设未写入地址初始化为 0（依赖 .coe 文件）
            $display("Test 4 Passed");
        else
            $display("Test 4 Failed");

        // 测试结束
        #20;
        $finish;
    end

    // 波形记录（可选）
    initial begin
        $dumpfile("ram_tb.vcd");
        $dumpvars(0, RAM_tb);
    end
endmodule
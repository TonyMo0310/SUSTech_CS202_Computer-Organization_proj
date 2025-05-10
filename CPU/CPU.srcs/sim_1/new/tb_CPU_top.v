`timescale 1ns / 1ps

module tb_CPU_top;
    // 输入信号
    reg clk;
    reg rst;
    reg [31:0] IOin;

    // 输出信号
    wire [31:0] IOout;

    // 中间信号
    wire [31:0] instruction;

    // 指令内存（简单模拟）
    reg [31:0] instruction_memory [0:255];

    // 实例化 CPU_top
    CPU_top uut (
        .clk(clk),
        .rst(rst)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20 ns 时钟周期
    end

    // 复位和测试序列
    initial begin
        // 初始化信号
        rst = 1;
        IOin = 32'hA5A5A5A5; // 提供有效的 IO 输入

        // 预加载指令内存
        instruction_memory[0] = 32'h00000083; // lb x1, 0(x0)
        instruction_memory[1] = 32'h00000103; // lh x2, 0(x0)
        instruction_memory[2] = 32'h00000183; // lw x3, 0(x0)
        instruction_memory[3] = 32'h00A00023; // sb x10, 0(x0)
        instruction_memory[4] = 32'h00B000A3; // sh x11, 0(x0)
        instruction_memory[5] = 32'h00C00123; // sw x12, 0(x0)

        // 复位
        #5 rst = 0;

        // 运行一段时间以观察波形
        #1000 $finish;
    end

    // 模拟指令内存读取
    assign instruction = instruction_memory[uut.pc[15:2]];

endmodule
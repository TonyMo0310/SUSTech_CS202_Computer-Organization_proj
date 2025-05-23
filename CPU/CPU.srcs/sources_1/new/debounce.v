`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 21:29:05
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce (
    input clk,         // 时钟信号
    input rst,         // 复位信号
    input btn_in,      // 按键信号（可能有抖动）
    output reg btn_out     // 去抖后的按键信号
    
);
    wire slow_clk;
    wire dff1_q;
    wire dff2_q;
    clock_divider ck_div(
        .clk_in(clk),
        .reset(rst),
        .clk_out(slow_clk)
    );
    // 第一个 D 型触发器（同步按键信号）
    
    D_Flip_Flop dff1 (
        .clk(slow_clk),
        .rst(rst),
        .d(btn_in),
        .q(dff1_q)
    );

    // 第二个 D 型触发器（去抖，输出稳定信号）
    D_Flip_Flop dff2 (
        .clk(slow_clk),
        .rst(rst),
        .d(dff1_q),
        .q(dff2_q)
    );

    always@(*)begin
        if(dff1_q & ~dff2_q)btn_out<=1;
        else btn_out<=0;
    end

endmodule

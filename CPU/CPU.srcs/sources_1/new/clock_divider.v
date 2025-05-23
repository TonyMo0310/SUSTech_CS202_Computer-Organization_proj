`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 21:26:54
// Design Name: 
// Module Name: clock_divider
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


module clock_divider (
    input clk_in,    // 输入时钟 (100 MHz)
    input reset,     // 重置信号
    output reg clk_out // 输出时钟 (100 Hz)
);

    // 设定计数器的最大值，假设原始时钟是 100 MHz，要分频到 100 Hz
    // 计数值 = 100,000,000 / 100 - 1 = 999,999
    reg [17:0] counter; // 计数器宽度为 20 位，最大值为 999,999

    always @(posedge clk_in or negedge reset) begin
        if (!reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == 99999) begin
                counter <= 0;
                clk_out <= ~clk_out;  // 翻转输出时钟
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

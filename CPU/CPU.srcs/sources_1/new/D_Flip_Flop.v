`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 21:28:02
// Design Name: 
// Module Name: D_Flip_Flop
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


module D_Flip_Flop(
        input clk,   // 时钟信号
        input rst,   // 复位信号，通常为高有效
        input d,     // 输入数据
        output reg q // 输出数据
    );

        // D 型触发器逻辑
        always @(posedge clk or negedge rst) begin
            if (!rst) 
                q <= 0;  // 复位时输出为 0
            else
                q <= d;  // 在时钟上升沿时更新 q 为 d 的值
        end


endmodule


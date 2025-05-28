`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/28 20:23:51
// Design Name: 
// Module Name: ClkDiv
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


module ClkDiv(
    input clk_in,
    output reg clk_out,
    input rst
    );
    // 分频到10MHz。分频比为10，计数值=10-1=9
        reg [3:0] counter; // 改为4位足够（最大值为9）
    
        always @(posedge clk_in or negedge rst) begin
            if (!rst) begin
                counter <= 0;
                clk_out <= 0;
            end else begin
                if (counter == 9) begin   // 当计数达到9时触发翻转
                    counter <= 0;         // 清零计数器
                    clk_out <= ~clk_out;  // 翻转输出时钟
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    
endmodule

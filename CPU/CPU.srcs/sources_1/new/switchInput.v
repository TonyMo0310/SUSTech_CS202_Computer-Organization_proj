`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 15:02:03
// Design Name: 
// Module Name: switchInput
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

//该模块用于控制IO输入
module switchInput(
    input clk,
    input rst,
    input [7:0] l_sw,
    input [2:0] r_sw,
    output reg [31:0] IOin
    );
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            IOin=32'h0;
        end else begin
           IOin={21'h0,r_sw,l_sw};
        end
    end
endmodule

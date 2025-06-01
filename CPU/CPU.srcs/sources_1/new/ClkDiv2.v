`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/01 22:17:38
// Design Name: 
// Module Name: ClkDiv2
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


module ClkDiv2(
    input clk_in,
    output reg clk_out,
    input rst
    );
    always @(posedge clk_in or negedge rst) begin
        if(!rst)
            clk_out=1'b0;
        else
            clk_out=~clk_out;
    end
    
endmodule

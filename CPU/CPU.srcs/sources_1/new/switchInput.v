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
    input [7:0] sw,
    input [1:0] choose,
    output reg [31:0] IOin
    );
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            IOin=32'h0;
        end else begin
            case(choose)
                2'b00:IOin[7:0]=sw;
                2'b01:IOin[15:8]=sw;
                2'b10:IOin[23:16]=sw;
                2'b11:IOin[31:24]=sw;
            endcase
        end
    end
endmodule

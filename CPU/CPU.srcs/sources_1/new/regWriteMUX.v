`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/09 16:21:57
// Design Name: 
// Module Name: regWriteMUX
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


module regWriteMUX(
    input memtoReg,
    input [31:0] ALUresult,  // 注意这里的端口名
    input [31:0] DataRead,
    output reg [31:0] regWriteData
);
    always @* begin
        if(memtoReg) begin
            regWriteData=DataRead;
        end else begin
            regWriteData=ALUresult;
        end
    end
endmodule

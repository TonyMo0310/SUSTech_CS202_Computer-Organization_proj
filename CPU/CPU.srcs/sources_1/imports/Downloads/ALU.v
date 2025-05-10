`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/29 15:21:28
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:这东西估计后面还得大改 :(
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [31:0] imm32,
    input ALUSrc,
    input PCtoALU,
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0]pc,
    output reg [31:0] ALUResult,
    output reg zero
    );
    reg [31:0]num1;
    reg [31:0]num2;
    always @* begin 
        if(ALUSrc)
            num2=imm32;
        else
            num2=ReadData2;
            
        if(PCtoALU)
            num1=pc;
        else
            num1=ReadData2;
    end 
    always @* begin
        casex({ALUOp,funct7,funct3})
            12'b00_xxxxxxx_xxx: ALUResult=num1+num2;
            12'b01_xxxxxxx_xxx: ALUResult=num1-num2;
            12'b10_0000000_000: ALUResult=num1+num2;
            12'b10_0100000_000: ALUResult=num1-num2;
            12'b10_0000000_111: ALUResult=num1&num2;
            12'b10_0000000_110: ALUResult=num1|num2;
            default:ALUResult=32'h0;
        endcase
    end 
    always @* begin
        if(ALUResult)
            zero=1'b0;
        else
            zero=1'b1;
    end
endmodule
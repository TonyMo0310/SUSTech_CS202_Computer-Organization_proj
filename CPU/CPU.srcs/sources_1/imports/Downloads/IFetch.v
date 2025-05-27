`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/21 15:27:04
// Design Name: 
// Module Name: IFetch
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


module IFetch(
    input clk,
    input rst,             // 异步复位输入（下降沿触发）
    input branch,
    input zero,            // ALU零标志
    input [31:0] imm32,    // 符号扩展后的32位立即数
    output reg [31:0]pc,
    input IFen,             // PC更新使能信号（仅在为高时允许改变PC）
    input regtoPC, //仅用于判定是否是jalr指令
    input [31:0]readData1//用于jalr指令
);
    
    // 处理异步复位和同步时钟更新
    always @(negedge rst or posedge clk) begin
        if (!rst) 
            pc <= 32'h0;   // 异步复位触发（下降沿）
        else begin         // 同步模式，仅在使能有效且时钟上升沿时更新PC
            if(IFen) begin
                if(branch&&zero)
                    if(regtoPC)
                        pc<=imm32+readData1;
                    else
                        pc<=pc+imm32;
                else
                    pc<=pc+4;
            end
        end
    end
endmodule

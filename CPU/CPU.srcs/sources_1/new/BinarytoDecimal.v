`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/29 21:31:29
// Design Name: 
// Module Name: BinarytoDecimal
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


module BinarytoDecimal(
    input [7:0] in,
    output reg [39:0] out
    );
    
    reg [7:0] bin;
    reg [11:0] tem;
    wire neg;
    assign neg=in[7];
    always @*  
    begin
            if(neg) begin //输入为负
                bin=~in+1;
                out[39:35]=5'b10000;
            end else begin //输入为正
                bin=in;
                out[39:35]=5'b00000;
            end
            tem = 12'b0000_0000_0000;
            repeat(7)
                begin
                tem[0] = bin[7];
                if(tem[3:0] > 4'b0100)
                    tem[3:0] = tem[3:0] + 4'b0011;
                if(tem[7:4] > 4'b0100)
                    tem[7:4] = tem[7:4] + 4'b0011;
                if(tem[11:8] > 4'b0100)
                    tem[11:8] = tem[11:8] + 4'b0011;
                    tem = tem << 1;
                    bin = bin << 1;
                end
            tem[0] = bin[7];
            
            out[3:0] = tem[3:0];
            out[4] = 1'b0;
            out[8:5] = tem[7:4];
            out[9] = 1'b0;
            out[13:10] = tem[11:8];
            out[34:14] = 21'b00000_00000_00000_00000_0;
    end
endmodule

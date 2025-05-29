`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/29 21:29:05
// Design Name: 
// Module Name: IOtoBCD
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


module IOtoBCD(
    input [31:0] IOout,
    output reg [39:0] bcd,
    input displayMode
    );
    wire [39:0]hexBCD;
    wire [39:0]decBCD;
    BinarytoDecimal BinarytoDecimal(.in(IOout[7:0]),.out(decBCD));
    assign hexBCD={1'b0,IOout[31:28],1'b0,IOout[27:24],1'b0,IOout[23:20],1'b0,IOout[19:16],1'b0,IOout[15:12],1'b0,IOout[11:8],1'b0,IOout[7:4],1'b0,IOout[3:0]};
    always @* begin
        if(displayMode) bcd=decBCD;
        else bcd=hexBCD;
    end
endmodule

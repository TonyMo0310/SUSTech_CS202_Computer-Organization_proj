module decoder(
 input clk,        // ʱ���źţ���������Ч��
 input rst,        // ��λ�źţ��͵�ƽ���ͬ����λ��
 input [31:0] instruction,
 input [31:0] writeData,
 output [31:0] immediate,
 input regWrite,
 input WBen,
 output [31:0] readData1,
 output [31:0] readData2
);
 registers dut1 (
     .clk(clk),             // input clk
     .rst(rst),             // input rst
     .readRegister1(instruction[19:15]),   // input [4:0] readRegister1
     .readRegister2(instruction[24:20]),   // input [4:0] readRegister2
     .writeRegister(instruction[11:7]),   // input [4:0] writeRegister
     .writeData(writeData[31:0]),       // input [31:0] writeData
     .readData1(readData1[31:0]),       // output reg [31:0] readData1
     .readData2(readData2[31:0]),       // output reg [31:0] readData2
     .regWrite(regWrite),         // input regWrite
     .WBen(WBen)
 );
 immGen dut2 (
     .instruction(instruction[31:0]),     // input [31:0] instruction
     .immediate(immediate[31:0])        // output reg [31:0] immediate
 );
endmodule
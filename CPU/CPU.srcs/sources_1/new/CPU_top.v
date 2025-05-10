`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/28 15:30:21
// Design Name: 
// Module Name: CPU_top
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

module CPU_top(
    input clk,
    input rst
    );
    wire branch;
    wire zero;
    wire [31:0] imm;    
    wire [31:0] instruction;
    
    wire [31:0] regWriteData;
    wire regWrite;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire IFen;
    wire WBen;
    wire [31:0] address;
    wire [31:0] readData;
    wire memWrite;
    wire MEMen;
    wire [31:0] pc; // 修改为 32 位，与 IFetch 一致
    wire ALUsrc;
    wire PCtoALU;
    wire [1:0] ALUOp;
    wire [31:0] ALUResult;
    wire [31:0] IOin;
    wire [31:0] IOout;
    wire memtoReg;
    wire [2:0] memOp; // 新增：用于传递 funct3

    // 实例化 IFetch 模块
    IFetch ifetch (
        .clk(clk),
        .rst(rst),          
        .branch(branch),       
        .zero(zero),          
        .imm32(imm),
        .pc(pc),        
        .instruction(instruction)  
    );
    // 实例化 decoder 模块
    decoder decoder (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .writeData(regWriteData),
        .immediate(imm),
        .regWrite(regWrite),
        .readData1(readData1),
        .readData2(readData2),
        .WBen(WBen)
    );
    // 实例化控制模块（Control Unit）
    control control (
        .opcode(instruction[6:0]),
        .branch(branch),
        .memRead(),
        .memtoReg(memtoReg),
        .ALUop(ALUOp),
        .memWrite(memWrite),
        .ALUsrc(ALUsrc),
        .regWrite(regWrite),
        .PCtoALU(PCtoALU),
        .regtoPC()
    );
    regWriteMUX regWriteMUX(
        .memtoReg(memtoReg),
        .ALUresult(ALUResult),  // 修正后的端口名
        .DataRead(readData),
        .regWriteData(regWriteData)
    );
    // 实例化 DataMem 模块
    DataMem dataMem (
        .address(address),
        .memOp(instruction[14:12]), // 直接使用 funct3
        .readData(readData),
        .memWrite(memWrite),
        .writeData(readData2),
        .clk(clk),
        .rst(rst),
        .IOin(IOin),
        .IOout(IOout),
        .MEMen(MEMen)
    );
    
    // CPU 状态机
    CPU_state cpu_state (
        .clk(clk),
        .rst(rst),
        .IFen(IFen),
        .MEMen(MEMen),
        .WBen(WBen)
    );
    // 实例化 ALU 模块
    ALU ALU (
        .ReadData1(readData1),
        .ReadData2(readData2),
        .imm32(imm),
        .ALUSrc(ALUsrc),
        .PCtoALU(PCtoALU),
        .ALUOp(ALUOp),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .pc(pc),
        .ALUResult(ALUResult),
        .zero(zero)
    );
    
    // 连接 address
    assign address = ALUResult;
endmodule
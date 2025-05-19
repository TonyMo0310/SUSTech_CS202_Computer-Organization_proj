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
    input rst,
    output [7:0] seg,
    output [7:0] seg1,
    output [7:0] an,
    input [7:0] sw,
    input [1:0] choose,
    input uart_rx,          // 串口输入
    output uart_tx          // 串口输出
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
    wire [31:0] pc;
    wire ALUsrc;
    wire PCtoALU;
    wire [1:0] ALUOp;
    wire [31:0] ALUResult;
    wire [31:0] IOin;
    wire [31:0] IOout;
    wire memtoReg;
    wire [2:0] memOp;

    // UART 相关信号
    wire upg_clk_o;
    wire upg_wen_o;
    wire [14:0] upg_adr_o;
    wire [31:0] upg_dat_o;
    wire upg_done_o;

    // 实例化 IFetch 模块
    IFetch ifetch (
        .clk(clk),
        .rst(rst),          
        .branch(branch),       
        .zero(zero),          
        .imm32(imm),
        .pc(pc),        
        .instruction(instruction),
        .IFen(IFen),
        // UART 相关信号
        .upg_wen_i(upg_wen_o),
        .upg_adr_i(upg_adr_o),
        .upg_dat_i(upg_dat_o)
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
        .ALUresult(ALUResult),
        .DataRead(readData),
        .regWriteData(regWriteData)
    );

    // 实例化 DataMem 模块
    DataMem dataMem (
        .address(address),
        .memOp(instruction[14:12]),
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
    
    // 七段显示模块实例化
    sevenSegmentDisplay sevenSegmentDisplay (
        .clk(clk),
        .rst(rst),
        .IOout(IOout),
        .seg(seg),
        .seg1(seg1),
        .an(an)
    );

    // 开关输入
    switchInput switchInput (
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .choose(choose),
        .IOin(IOin)
    );
    
    // 实例化 uart_bmpg_0
    uart_bmpg_0 uart_inst (
        .upg_clk_i(clk),        // 使用 CPU 主时钟
        .upg_rst_i(rst),        // 使用 CPU 复位信号
        .upg_clk_o(upg_clk_o),  // 输出时钟（未使用）
        .upg_wen_o(upg_wen_o),  // 写使能
        .upg_adr_o(upg_adr_o),  // 地址
        .upg_dat_o(upg_dat_o),  // 数据
        .upg_done_o(upg_done_o),// 传输完成
        .upg_rx_i(uart_rx),     // 串口输入
        .upg_tx_o(uart_tx)      // 串口输出
    );

    // 连接 address
    assign address = ALUResult;
endmodule
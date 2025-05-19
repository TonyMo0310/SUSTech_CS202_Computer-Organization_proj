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
    input uart_rx,          // ��������
    output uart_tx          // �������
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

    // UART ����ź�
    wire upg_clk_o;
    wire upg_wen_o;
    wire [14:0] upg_adr_o;
    wire [31:0] upg_dat_o;
    wire upg_done_o;

    // ʵ���� IFetch ģ��
    IFetch ifetch (
        .clk(clk),
        .rst(rst),          
        .branch(branch),       
        .zero(zero),          
        .imm32(imm),
        .pc(pc),        
        .instruction(instruction),
        .IFen(IFen),
        // UART ����ź�
        .upg_wen_i(upg_wen_o),
        .upg_adr_i(upg_adr_o),
        .upg_dat_i(upg_dat_o)
    );

    // ʵ���� decoder ģ��
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

    // ʵ��������ģ�飨Control Unit��
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

    // ʵ���� DataMem ģ��
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
    
    // CPU ״̬��
    CPU_state cpu_state (
        .clk(clk),
        .rst(rst),
        .IFen(IFen),
        .MEMen(MEMen),
        .WBen(WBen)
    );

    // ʵ���� ALU ģ��
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
    
    // �߶���ʾģ��ʵ����
    sevenSegmentDisplay sevenSegmentDisplay (
        .clk(clk),
        .rst(rst),
        .IOout(IOout),
        .seg(seg),
        .seg1(seg1),
        .an(an)
    );

    // ��������
    switchInput switchInput (
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .choose(choose),
        .IOin(IOin)
    );
    
    // ʵ���� uart_bmpg_0
    uart_bmpg_0 uart_inst (
        .upg_clk_i(clk),        // ʹ�� CPU ��ʱ��
        .upg_rst_i(rst),        // ʹ�� CPU ��λ�ź�
        .upg_clk_o(upg_clk_o),  // ���ʱ�ӣ�δʹ�ã�
        .upg_wen_o(upg_wen_o),  // дʹ��
        .upg_adr_o(upg_adr_o),  // ��ַ
        .upg_dat_o(upg_dat_o),  // ����
        .upg_done_o(upg_done_o),// �������
        .upg_rx_i(uart_rx),     // ��������
        .upg_tx_o(uart_tx)      // �������
    );

    // ���� address
    assign address = ALUResult;
endmodule
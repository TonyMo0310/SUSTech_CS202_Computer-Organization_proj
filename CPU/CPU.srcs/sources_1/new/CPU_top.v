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
    input fpga_clk,
    input fpga_rst,//低电平激活
    output [7:0] seg,
    output [7:0] seg1,
    output [7:0] an,
    input [7:0] sw,
    input [1:0] choose,
    output [7:0]led,        //控制LED灯，由IOout低位控制
    input start_pg,          //串口输入开关
    input uart_rx,          // 串口输入
    output uart_tx,          // 串口输出
    input confirmBottom
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
    wire clk;
    wire upg_clk;
<<<<<<< HEAD
    wire pause;    
    wire confirm;
=======
>>>>>>> b42b803b8728acc44a8e6860d387ef788439fa4f
    // UART 相关信号
    wire upg_clk_o;
    wire upg_wen_o;
    wire [14:0] upg_adr_o;
    wire [31:0] upg_dat_o;
    wire upg_done_o;
    wire spg_bufg;
    BUFG U1(.I(start_pg), .O(spg_bufg));     // de-twitter
     // Generate UART Programmer reset signal
     reg upg_rst;
     always @ (negedge fpga_clk) begin
      if (!fpga_rst)
       upg_rst <= 1;
      if (spg_bufg) upg_rst <= 0;
     end
     //used for other modules which don't relate to UART
     wire rst;      
    assign rst = !(!fpga_rst | !upg_rst);
<<<<<<< HEAD
    assign led=IOout[7:0];
    debounce debounce(
        .clk(fpga_clk),
        .rst(rst),
        .btn_in(confirmBottom),
        .btn_out(confirm)
    );
=======
    
    assign led=IOout[7:0];
    
>>>>>>> b42b803b8728acc44a8e6860d387ef788439fa4f
    cpuclk cpuclk(
        .clk_in1(fpga_clk),
        .clk_out1(clk),
        .clk_out2(upg_clk)
    );
    // 实例化 IFetch 模块
    IFetch ifetch (
        .clk(clk),
        .rst(rst),          
        .branch(branch),       
        .zero(zero),          
        .imm32(imm),
        .pc(pc),        
        .IFen(IFen)
    );
    programrom programrom (
      // Program ROM Pinouts
      .rom_clk_i        (upg_clk_o),       // input rom_clk_i
      .rom_adr_i        (pc[15:2]),       // input [13:0] rom_adr_i
      .instruction      (instruction),       // output [31:0] instruction
      
      // UART Programmer Pinouts         
      .upg_rst_i        (rst),       // input upg_rst_i
      .upg_clk_i        (upg_clk_o),       // input upg_clk_i
      .upg_wen_i        (upg_wen_o&!upg_adr_o[14]),       // input upg_wen_i
      .upg_adr_i        (upg_adr_o[13:0]),       // input [13:0] upg_adr_i
      .upg_dat_i        (upg_dat_o),       // input [31:0] upg_dat_i
      .upg_done_i       (upg_done_o)        // input upg_done_i
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
        .MEMen(MEMen),
<<<<<<< HEAD
        .pause(pause),
=======
>>>>>>> b42b803b8728acc44a8e6860d387ef788439fa4f
        //UART相关端口
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );
    
    // CPU 状态机
    CPU_state cpu_state (
        .clk(clk),
        .rst(rst),
        .IFen(IFen),
        .MEMen(MEMen),
        .WBen(WBen),
        .confirm(confirm),
        .pause(pause)
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
        .upg_clk_i(upg_clk),        // 使用 Upg时钟
        .upg_rst_i(upg_rst),        // 使用 UPG 复位信号
        .upg_clk_o(upg_clk_o),  // 输出时钟
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
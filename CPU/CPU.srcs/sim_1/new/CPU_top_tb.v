`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/28 17:35:38
// Design Name: 
// Module Name: CPU_top_tb
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


module CPU_top_tb(

    );
    reg fpga_clk;
    reg fpga_rst;//低电平激活
    wire [7:0] seg;
    wire [7:0] seg1;
    wire [7:0] an;
    reg [7:0] sw;
    reg[1:0] choose;
    wire [7:0]led;        //控制LED灯，由IOout低位控制
    reg start_pg;          //串口输入开关
    reg uart_rx;          // 串口输入
    wire uart_tx;          // 串口输出
    reg confirmBottom;
    
    CPU_top cpu_top_inst (
    .fpga_clk(fpga_clk),
    .fpga_rst(fpga_rst),
    .seg(seg),
    .seg1(seg1),
    .an(an),
    .sw(sw),
    .choose(choose),
    .led(led),
    .start_pg(start_pg),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .confirmBottom(confirmBottom)
    );
    initial begin
    fpga_clk=1'b0;
    fpga_rst=1'b0;
    sw=7'b0101010;
    choose=2'b00;
    start_pg=1'b0;
    uart_rx=1'b0;
    confirmBottom=1'b0;
    end
    always  begin
        #10 fpga_clk=~fpga_clk; 
    end
    initial begin
    #500
    fpga_rst=1'b1;
    #5000
    confirmBottom=1'b1;
    end
endmodule


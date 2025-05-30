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
    reg fpga_rst;//�͵�ƽ����
    wire [7:0] seg;
    wire [7:0] seg1;
    wire [7:0] an;
    reg [7:0] l_sw;
    reg[2:0] r_sw;
    reg displayMode;
    wire [7:0]led;        //����LED�ƣ���IOout��λ����
    reg start_pg;          //�������뿪��
    reg uart_rx;          // ��������
    wire uart_tx;          // �������
    reg confirmBottom;
    
    CPU_top cpu_top_inst (
    .fpga_clk(fpga_clk),
    .fpga_rst(fpga_rst),
    .seg(seg),
    .seg1(seg1),
    .an(an),
    .l_sw(l_sw),
    .r_sw(r_sw),
    .displayMode(displayMode),
    .led(led),
    .start_pg(start_pg),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .confirmBottom(confirmBottom)
    );
    initial begin
    fpga_clk=1'b0;
    fpga_rst=1'b0;
    l_sw=7'b0101010;
    r_sw=3'b000;
    displayMode=1'b0;
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 21:29:05
// Design Name: 
// Module Name: debounce
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


module debounce (
    input clk,         // ʱ���ź�
    input rst,         // ��λ�ź�
    input btn_in,      // �����źţ������ж�����
    output reg btn_out     // ȥ����İ����ź�
    
);
    wire slow_clk;
    wire dff1_q;
    wire dff2_q;
    clock_divider ck_div(
        .clk_in(clk),
        .reset(rst),
        .clk_out(slow_clk)
    );
    // ��һ�� D �ʹ�������ͬ�������źţ�
    
    D_Flip_Flop dff1 (
        .clk(slow_clk),
        .rst(rst),
        .d(btn_in),
        .q(dff1_q)
    );

    // �ڶ��� D �ʹ�������ȥ��������ȶ��źţ�
    D_Flip_Flop dff2 (
        .clk(slow_clk),
        .rst(rst),
        .d(dff1_q),
        .q(dff2_q)
    );

    always@(*)begin
        if(dff1_q & ~dff2_q)btn_out<=1;
        else btn_out<=0;
    end

endmodule

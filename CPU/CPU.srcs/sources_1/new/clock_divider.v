`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 21:26:54
// Design Name: 
// Module Name: clock_divider
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


module clock_divider (
    input clk_in,    // ����ʱ�� (100 MHz)
    input reset,     // �����ź�
    output reg clk_out // ���ʱ�� (100 Hz)
);

    // �趨�����������ֵ������ԭʼʱ���� 100 MHz��Ҫ��Ƶ�� 100 Hz
    // ����ֵ = 100,000,000 / 100 - 1 = 999,999
    reg [17:0] counter; // ���������Ϊ 20 λ�����ֵΪ 999,999

    always @(posedge clk_in or negedge reset) begin
        if (!reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == 99999) begin
                counter <= 0;
                clk_out <= ~clk_out;  // ��ת���ʱ��
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

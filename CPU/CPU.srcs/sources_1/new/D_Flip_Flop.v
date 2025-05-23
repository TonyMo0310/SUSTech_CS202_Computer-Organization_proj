`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 21:28:02
// Design Name: 
// Module Name: D_Flip_Flop
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


module D_Flip_Flop(
        input clk,   // ʱ���ź�
        input rst,   // ��λ�źţ�ͨ��Ϊ����Ч
        input d,     // ��������
        output reg q // �������
    );

        // D �ʹ������߼�
        always @(posedge clk or negedge rst) begin
            if (!rst) 
                q <= 0;  // ��λʱ���Ϊ 0
            else
                q <= d;  // ��ʱ��������ʱ���� q Ϊ d ��ֵ
        end


endmodule


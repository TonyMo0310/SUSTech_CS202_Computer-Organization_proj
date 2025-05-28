`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/28 20:23:51
// Design Name: 
// Module Name: ClkDiv
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


module ClkDiv(
    input clk_in,
    output reg clk_out,
    input rst
    );
    // ��Ƶ��10MHz����Ƶ��Ϊ10������ֵ=10-1=9
        reg [3:0] counter; // ��Ϊ4λ�㹻�����ֵΪ9��
    
        always @(posedge clk_in or negedge rst) begin
            if (!rst) begin
                counter <= 0;
                clk_out <= 0;
            end else begin
                if (counter == 9) begin   // �������ﵽ9ʱ������ת
                    counter <= 0;         // ���������
                    clk_out <= ~clk_out;  // ��ת���ʱ��
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    
endmodule

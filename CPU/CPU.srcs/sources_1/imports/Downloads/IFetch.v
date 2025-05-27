`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/21 15:27:04
// Design Name: 
// Module Name: IFetch
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


module IFetch(
    input clk,
    input rst,             // �첽��λ���루�½��ش�����
    input branch,
    input zero,            // ALU���־
    input [31:0] imm32,    // ������չ���32λ������
    output reg [31:0]pc,
    input IFen,             // PC����ʹ���źţ�����Ϊ��ʱ����ı�PC��
    input regtoPC, //�������ж��Ƿ���jalrָ��
    input [31:0]readData1//����jalrָ��
);
    
    // �����첽��λ��ͬ��ʱ�Ӹ���
    always @(negedge rst or posedge clk) begin
        if (!rst) 
            pc <= 32'h0;   // �첽��λ�������½��أ�
        else begin         // ͬ��ģʽ������ʹ����Ч��ʱ��������ʱ����PC
            if(IFen) begin
                if(branch&&zero)
                    if(regtoPC)
                        pc<=imm32+readData1;
                    else
                        pc<=pc+imm32;
                else
                    pc<=pc+4;
            end
        end
    end
endmodule

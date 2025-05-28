`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/08 20:57:44
// Design Name: 
// Module Name: CPU_state
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


module CPU_state(
    input clk,
    input rst,
    input pause,
    input confirm,
    output reg  IFen,
    output reg MEMen,
    output reg  WBen
    );
    reg [2:0]state;//000:IF,001:MEM,010:WB,011:IDLE, 101:inst&ALU  后续有需要再加
    reg confirm_pre;
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            state<=3'b011;//默认IDLE状态
            confirm_pre<=1'b0;
        end else begin
            confirm_pre<=confirm;
            case(state)
                3'b011:state<=3'b000;//IDLE->IF
                3'b000:state<=3'b101;//IF->ALU
                3'b101:state<=3'b001;//ALU->MEM
                3'b001:
                    if(pause)
                        if(confirm&!confirm_pre)//检测上升沿
                            state<=3'b010;//PAUSE->MEM
                        else
                            state<=3'b001;
                    else
                        state<=3'b010;//PAUSE->MEM
                3'b010:state<=3'b000;//WB->IF

                default :state<=3'b011;//异常情况处理
            endcase 
        end
    end
    always@* begin
        if(state==3'b000)
            IFen=1'b1;
        else
            IFen=1'b0;
        
        if(state==3'b001)
            MEMen=1'b1;
        else
            MEMen=1'b0;
            
        if(state==3'b010)
            WBen=1'b1;
        else
            WBen=1'b0;
    end 
endmodule

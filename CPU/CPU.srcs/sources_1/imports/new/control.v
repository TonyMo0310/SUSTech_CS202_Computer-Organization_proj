`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/20 17:03:33
// Design Name: 
// Module Name: control
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


module control(
    input [6:0] opcode,
    output reg branch,
    output reg memRead,
    output reg memtoReg,
    output reg [2:0] ALUop,// 3'b000:运算指令      3'b001:内存存取指令    3'b010:分支类型    3'b011:J type     3'b100:lui      3'b101:auipc      3'b111:异常情况
    output reg memWrite,
    output reg ALUsrc,//0 is from reg,1 is from imm
    output reg regWrite,
    output reg PCtoALU,
    output reg regtoPC,
    output reg hasFun7
    );
    always@*
    begin
     case(opcode)
      7'b000_0011:begin //lb,lh,lw,ld,lbu,lhu
       branch=1'b0;
       memRead=1'b1;
       memtoReg=1'b1;
       ALUop=3'b001;
       memWrite=1'b0;
       ALUsrc=1'b1;
       regWrite=1'b1;
       PCtoALU=1'b0;
       regtoPC=1'b0;
       hasFun7=1'b0;
      end
      7'b110_0111:begin //jarl
        branch=1'b1;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b011;    
        memWrite=1'b0;
        ALUsrc=1'b1;
        regWrite=1'b1;
        PCtoALU=1'b1;
        regtoPC=1'b1;
        hasFun7=1'b0;
      end
      7'b001_0011:begin//addi,slli,slti,sltiu,xori,srli,srai,ori,andi
        branch=1'b0;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b000;    
        memWrite=1'b0;
        ALUsrc=1'b1;
        regWrite=1'b1;
        PCtoALU=1'b0;
        regtoPC=1'b0;
        hasFun7=1'b0;
      end
      7'b010_0011:begin//sb,sh,sw,sd
        branch=1'b0;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b001;    
        memWrite=1'b1;
        ALUsrc=1'b1;
        regWrite=1'b0;
        PCtoALU=1'b0;
        regtoPC=1'b0;
        hasFun7=1'b0;
      end
      7'b011_0011:begin//add.sub.sll.slt.sltu.xor,sri,sra,or,and
        branch=1'b0;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b000;
        memWrite=1'b0;
        ALUsrc=1'b0;
        regWrite=1'b1;
        PCtoALU=1'b0;
        regtoPC=1'b0;
        hasFun7=1'b1;
      end
      7'b110_0011:begin//beq,bne,blt,bge,bltu,bgeu
        branch=1'b1;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b010;    
        memWrite=1'b0;
        ALUsrc=1'b0;
        regWrite=1'b0;
        PCtoALU=1'b0;
        regtoPC=1'b0;
        hasFun7=1'b0;
      end
      7'b001_0111:begin//auipc
        branch=1'b0;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b101;    
        memWrite=1'b0;
        ALUsrc=1'b1;
        regWrite=1'b1;
        PCtoALU=1'b1;
        regtoPC=1'b0;
        hasFun7=1'b0;
      end
      7'b011_0111:begin//lui
        branch=1'b0;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b100;    
        memWrite=1'b0;
        ALUsrc=1'b1;
        regWrite=1'b1;
        PCtoALU=1'b0;
        regtoPC=1'b0;
        hasFun7=1'b0;
      end
      7'b110_1111:begin//jal
        branch=1'b1;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b011;    
        memWrite=1'b0;
        ALUsrc=1'b1;
        regWrite=1'b1;
        PCtoALU=1'b1;
        regtoPC=1'b0;
        hasFun7=1'b0;
      end
      default:begin
        branch=1'b0;
        memRead=1'b0;
        memtoReg=1'b0;
        ALUop=3'b000;
        memWrite=1'b0;
        ALUsrc=1'b0;
        regWrite=1'b0;
        PCtoALU=1'b0;
        regtoPC=1'b0;
        hasFun7=1'b0;
      end
     endcase
    end
endmodule

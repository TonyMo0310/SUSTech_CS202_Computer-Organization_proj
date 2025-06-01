`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/29 15:21:28
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:这东西估计后面还得大�? :(
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [31:0] imm32,
    input ALUSrc,
    input PCtoALU,
    input [2:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] pc,
    input hasFun7,
    output reg [31:0] ALUResult,
    output reg zero
);
    reg [31:0] num1;
    reg [31:0] num2;
    reg [6:0]f7;
    // 选择ALU操作�?
    always @* begin
        if(hasFun7)
            f7=funct7;
        else
            f7=7'h0;
        if (ALUSrc) begin
            num2 = imm32;  // 如果ALUSrc�?1，使用立即数
        end else begin
            num2 = ReadData2;  // 否则使用寄存器�??
        end

        if (PCtoALU) begin
            num1 = pc;  // 如果PCtoALU�?1，使用PC�?
        end else begin
            num1 = ReadData1;  // 否则使用寄存器�??
        end
    end

    // ALU操作
    always @* begin
        case (ALUOp)
            3'b000: begin  // 加法或�?�辑运算
                zero=1'b0;
                case (funct3)
                    3'b000: begin
                        if(f7==7'b0000000)begin
                            ALUResult = num1 + num2;  // ADD
                        end else begin
                            ALUResult = num1 - num2; // SUB
                        end
                    end
                    3'b001: ALUResult = num1 << num2[4:0];  // SLL
                    3'b010: ALUResult = ($signed(num1) < $signed(num2));  // SLT
                    3'b011: ALUResult = (num1 < num2);  // SLTU
                    3'b100: ALUResult = num1 ^ num2;  // XOR
                    3'b101: begin
                        if (f7 == 7'b0100000) begin
                            ALUResult = num1 >>> num2[4:0];  // SRA
                        end else begin
                            ALUResult = num1 >> num2[4:0];  // SRL
                        end
                    end
                    3'b110: ALUResult = num1 | num2;  // OR
                    3'b111: ALUResult = num1 & num2;  // AND
                endcase
            end
            3'b001: begin  // 减法
                zero=1'b0;
                ALUResult = num1 + num2;  // lw,sw
            end
            3'b010: begin  // 比较
                ALUResult=32'h0;
                case (funct3)
                    3'b000: zero = (num1 == num2);  // BEQ
                    3'b001: zero = (num1 != num2);  // BNE
                    3'b100: zero = (num1 < num2);  // BLT
                    3'b101: zero = (num1 >= num2);  // BGE
                    3'b110: zero = ($signed(num1) < $signed(num2));  // BLTU
                    3'b111: zero = ($signed(num1) >= $signed(num2));  // BGEU
                    default: zero = 1'b0;
                endcase
            end
            3'b011:begin//J type
                zero=1'b1;
                ALUResult=pc+4;
            end
            3'b100:begin//lui
                zero=1'b0;
                ALUResult=num2;
            end
            3'b101:begin//auipc
                zero=1'b0;
                ALUResult=num1+num2;
            end
            default: begin
                ALUResult = 32'h0;
                zero = 1'b0;
            end
        endcase
    end
endmodule

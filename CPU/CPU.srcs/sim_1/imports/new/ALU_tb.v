`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 10:49:18
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb;
    reg [31:0] ReadData1;
    reg [31:0] ReadData2;
    reg [31:0] imm32;
    reg ALUSrc;
    reg PCtoALU;
    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [31:0] pc;
    wire [31:0] ALUResult;
    wire zero;

    ALU alu (
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .imm32(imm32),
        .ALUSrc(ALUSrc),
        .PCtoALU(PCtoALU),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .pc(pc),
        .ALUResult(ALUResult),
        .zero(zero)
    );

    initial begin
        // ≤‚ ‘ ADD
        ReadData1 = 32'h00000001;
        ReadData2 = 32'h00000002;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("ADD Result: %h", ALUResult);

        // ≤‚ ‘ SUB
        ReadData1 = 32'h00000005;
        ReadData2 = 32'h00000003;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b01;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        pc = 32'h00000000;
        #10;
        $display("SUB Result: %h", ALUResult);

        // ≤‚ ‘ SLL
        ReadData1 = 32'h00000001;
        ReadData2 = 32'h00000002;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("SLL Result: %h", ALUResult);

        // ≤‚ ‘ SLT
        ReadData1 = 32'h00000003;
        ReadData2 = 32'h00000004;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("SLT Result: %h", ALUResult);

        // ≤‚ ‘ SLTU
        ReadData1 = 32'h00000003;
        ReadData2 = 32'h00000004;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b011;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("SLTU Result: %h", ALUResult);

        // ≤‚ ‘ XOR
        ReadData1 = 32'h00000001;
        ReadData2 = 32'h00000002;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("XOR Result: %h", ALUResult);

        // ≤‚ ‘ SRL
        ReadData1 = 32'h00000008;
        ReadData2 = 32'h00000003;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("SRL Result: %h", ALUResult);

        // ≤‚ ‘ SRA
        ReadData1 = 32'hFFFFFFF8;
        ReadData2 = 32'h00000003;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        pc = 32'h00000000;
        #10;
        $display("SRA Result: %h", ALUResult);

        // ≤‚ ‘ OR
        ReadData1 = 32'h00000001;
        ReadData2 = 32'h00000002;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("OR Result: %h", ALUResult);

        // ≤‚ ‘ AND
        ReadData1 = 32'h00000001;
        ReadData2 = 32'h00000002;
        imm32 = 32'h00000000;
        ALUSrc = 1'b0;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("AND Result: %h", ALUResult);

        // ≤‚ ‘ ADDI
        ReadData1 = 32'h00000001;
        imm32 = 32'h00000002;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("ADDI Result: %h", ALUResult);

        // ≤‚ ‘ SLTI
        ReadData1 = 32'h00000003;
        imm32 = 32'h00000004;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("SLTI Result: %h", ALUResult);

        // ≤‚ ‘ SLTIU
        ReadData1 = 32'h00000003;
        imm32 = 32'h00000004;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b011;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("SLTIU Result: %h", ALUResult);

        // ≤‚ ‘ XORI
        ReadData1 = 32'h00000001;
        imm32 = 32'h00000002;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("XORI Result: %h", ALUResult);

        // ≤‚ ‘ ORI
        ReadData1 = 32'h00000001;
        imm32 = 32'h00000002;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("ORI Result: %h", ALUResult);

        // ≤‚ ‘ ANDI
        ReadData1 = 32'h00000001;
        imm32 = 32'h00000002;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("ANDI Result: %h", ALUResult);

        // ≤‚ ‘ SLLI
        ReadData1 = 32'h00000001;
        imm32 = 32'h00000002;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("SLLI Result: %h", ALUResult);

        // ≤‚ ‘ SRLI
        ReadData1 = 32'h00000008;
        imm32 = 32'h00000003;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("SRLI Result: %h", ALUResult);

        // ≤‚ ‘ SRAI
        ReadData1 = 32'hFFFFFFF8;
        imm32 = 32'h00000003;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        pc = 32'h00000000;
        #10;
        $display("SRAI Result: %h", ALUResult);

        // ≤‚ ‘ BEQ
        ReadData1 = 32'h00000003;
        ReadData2 = 32'h00000003;
        imm32 = 32'h00000004;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b10;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("BEQ Result: %h", ALUResult);
        $display("BEQ Zero: %b", zero);

        // ≤‚ ‘ BNE
        ReadData1 = 32'h00000003;
        ReadData2 = 32'h00000004;
        imm32 = 32'h00000004;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b10;
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("BNE Result: %h", ALUResult);
        $display("BNE Zero: %b", zero);

        // ≤‚ ‘ BLT
        ReadData1 = 32'h00000003;
        ReadData2 = 32'h00000004;
        imm32 = 32'h00000004;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b10;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("BLT Result: %h", ALUResult);
        $display("BLT Zero: %b", zero);

        // ≤‚ ‘ BGE
        ReadData1 = 32'h00000004;
        ReadData2 = 32'h00000003;
        imm32 = 32'h00000004;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b10;
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("BGE Result: %h", ALUResult);
        $display("BGE Zero: %b", zero);

        // ≤‚ ‘ BLTU
        ReadData1 = 32'h00000003;
        ReadData2 = 32'h00000004;
        imm32 = 32'h00000004;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b10;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("BLTU Result: %h", ALUResult);
        $display("BLTU Zero: %b", zero);

        // ≤‚ ‘ BGEU
        ReadData1 = 32'h00000004;
        ReadData2 = 32'h00000003;
        imm32 = 32'h00000004;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b10;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("BGEU Result: %h", ALUResult);
        $display("BGEU Zero: %b", zero);

        // ≤‚ ‘ LUI
        imm32 = 32'h00001000;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("LUI Result: %h", ALUResult);

        // ≤‚ ‘ AUIPC
        imm32 = 32'h00001000;
        ALUSrc = 1'b1;
        PCtoALU = 1'b1;
        ALUOp = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("AUIPC Result: %h", ALUResult);

        // ≤‚ ‘ JAL
        imm32 = 32'h00001000;
        ALUSrc = 1'b1;
        PCtoALU = 1'b1;
        ALUOp = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("JAL Result: %h", ALUResult);

        // ≤‚ ‘ JALR
        ReadData1 = 32'h00000001;
        imm32 = 32'h00001000;
        ALUSrc = 1'b1;
        PCtoALU = 1'b0;
        ALUOp = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        pc = 32'h00000000;
        #10;
        $display("JALR Result: %h", ALUResult);

        // ≤‚ ‘Ω· ¯
        $finish;
    end
endmodule
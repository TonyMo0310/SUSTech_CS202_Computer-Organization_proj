`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/28 15:10:47
// Design Name: 
// Module Name: DataMem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Supports lw, sw, lb, lh, sb, sh, lbu, lhu instructions
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DataMem(
    input [31:0] address,          // Memory address
    input [2:0] memOp,             // Memory operation from funct3 (instruction[14:12])
    output reg [31:0] readData,    // Data read from memory
    input memWrite,                // Write enable
    input [31:0] writeData,        // Data to write
    input [31:0] IOin,             // IO input
    output reg [31:0] IOout,       // IO output
    input clk,                     // Clock
    input rst,                     // Reset
    input MEMen,                    // Memory enable
    // UART Programmer Pinouts
    input upg_rst_i,
    input  upg_clk_i,// UPG ram_clk_i (10MHz)
    input upg_wen_i,// UPG write enable
    input [13:0]upg_adr_i, // UPG write address
    input [31:0]upg_dat_i,// UPG write data
    input upg_done_i    // 1 if programming is finished

);

    reg writeMem;                  // Write enable for RAM
    wire [31:0] ramOut;            // Data output from RAM
    reg [31:0] ramIn;              // Data input to RAM for write
    parameter IOaddress = 32'hFFFFFC00; // IO address

    // Read logic: Handle word, byte, halfword reads (signed and unsigned)
    always @* begin
        if (address == IOaddress) begin
            readData = IOin;       // IO read (word only)
        end else begin
            case (memOp)
                3'b000: begin // lb: Load byte with sign extension
                    case (address[1:0])
                        2'b00: readData = {{24{ramOut[7]}}, ramOut[7:0]};
                        2'b01: readData = {{24{ramOut[15]}}, ramOut[15:8]};
                        2'b10: readData = {{24{ramOut[23]}}, ramOut[23:16]};
                        2'b11: readData = {{24{ramOut[31]}}, ramOut[31:24]};
                    endcase
                end
                3'b001: begin // lh: Load halfword with sign extension
                    case (address[1])
                        1'b0: readData = {{16{ramOut[15]}}, ramOut[15:0]};
                        1'b1: readData = {{16{ramOut[31]}}, ramOut[31:16]};
                    endcase
                end
                3'b010: begin // lw: Load word
                    readData = ramOut;
                end
                3'b100: begin // lbu: Load byte with zero extension
                    case (address[1:0])
                        2'b00: readData = {24'b0, ramOut[7:0]};
                        2'b01: readData = {24'b0, ramOut[15:8]};
                        2'b10: readData = {24'b0, ramOut[23:16]};
                        2'b11: readData = {24'b0, ramOut[31:24]};
                    endcase
                end
                3'b101: begin // lhu: Load halfword with zero extension
                    case (address[1])
                        1'b0: readData = {16'b0, ramOut[15:0]};
                        1'b1: readData = {16'b0, ramOut[31:16]};
                    endcase
                end
                default: begin
                    readData = ramOut; // Default to word read
                end
            endcase
        end
    end

    // Write logic: Handle word, byte, halfword writes with read-modify-write
    always @* begin
        writeMem = MEMen & memWrite & (address != IOaddress);
        if (writeMem) begin
            case (memOp)
                3'b000: begin // sb: Store byte
                    case (address[1:0])
                        2'b00: ramIn = {ramOut[31:8], writeData[7:0]};
                        2'b01: ramIn = {ramOut[31:16], writeData[7:0], ramOut[7:0]};
                        2'b10: ramIn = {ramOut[31:24], writeData[7:0], ramOut[15:0]};
                        2'b11: ramIn = {writeData[7:0], ramOut[23:0]};
                    endcase
                end
                3'b001: begin // sh: Store halfword
                    case (address[1])
                        1'b0: ramIn = {ramOut[31:16], writeData[15:0]};
                        1'b1: ramIn = {writeData[15:0], ramOut[15:0]};
                    endcase
                end
                3'b010: begin // sw: Store word
                    ramIn = writeData;
                end
                default: begin
                    ramIn = writeData; // Default to word write
                end
            endcase
        end else begin
            ramIn = writeData; // Default, not used unless writeMem is high
        end
    end

    // IO output handling
    always @(posedge clk or negedge rst) begin
        if (!rst)
            IOout <= 32'h0;
        else begin
            if (address == IOaddress && MEMen && memWrite) begin
                IOout <= writeData;
            end
        end
    end

    
    /* CPU work on normal mode when kickOff is 1.
     CPU work on Uart communicate mode when kickOff is 0.*/
     wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
     RAM ram (
     .clka (kickOff ?  clk     : upg_clk_i),
     .wea (kickOff ?    writeMem  : upg_wen_i),
     .addra (kickOff ?  address[15:2] : upg_adr_i),
     .dina (kickOff ?   ramIn : upg_dat_i),
     .douta (ramOut)
);
endmodule
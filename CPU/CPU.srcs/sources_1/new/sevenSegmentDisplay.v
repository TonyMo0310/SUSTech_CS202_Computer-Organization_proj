`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 2025/05/11 14:37:46
// Module Name: sevenSegmentDisplay
// Description:
// Modified to display a 32-bit value as hexadecimal digits on the 8-digit display.
//////////////////////////////////////////////////////////////////////////////////

module sevenSegmentDisplay(
    input wire clk,                 // Clock signal
    input wire rst,                 // Reset signal
    input wire [39:0] values,       // 40-bit input values (8 digits, 5 bits each)
    output reg [7:0] seg,           // 7-segment display segments
    output reg [7:0] seg1,
    output reg [7:0] an             // 7-segment display anodes
);

    // Clock divider for multiplexing
    reg [18:0] divclk_cnt = 0;
    reg divclk = 0;
    parameter maxcnt = 50000;       // Divider max count

    // Current digit and value to display
    reg [2:0] current_digit = 0;    // Current digit index (0-7)
    reg [4:0] current_value = 0;    // Current value (5 bits)

    // Clock divider logic
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            divclk_cnt <= 0;
            divclk <= 0;
        end else if (divclk_cnt == maxcnt) begin
            divclk <= ~divclk;
            divclk_cnt <= 0;
        end else begin
            divclk_cnt <= divclk_cnt + 1'b1;
        end
    end

    // Multiplexing logic for selecting the active digit
    always @(posedge divclk or negedge rst) begin
        if (~rst) begin
            current_digit <= 0;
            an <= 8'b00000000;      // All digits off
        end else begin
            current_digit <= (current_digit == 7) ? 0 : current_digit + 1'b1;

            // Activate corresponding digit
            case (current_digit)
                3'b000: an <= 8'b00000001;
                3'b001: an <= 8'b00000010;
                3'b010: an <= 8'b00000100;
                3'b011: an <= 8'b00001000;
                3'b100: an <= 8'b00010000;
                3'b101: an <= 8'b00100000;
                3'b110: an <= 8'b01000000;
                3'b111: an <= 8'b10000000;
                default: an <= 8'b00000000;
            endcase

            // Get the value for the current digit
            case (current_digit)
                3'b000: current_value <= values[4:0];
                3'b001: current_value <= values[9:5];
                3'b010: current_value <= values[14:10];
                3'b011: current_value <= values[19:15];
                3'b100: current_value <= values[24:20];
                3'b101: current_value <= values[29:25];
                3'b110: current_value <= values[34:30];
                3'b111: current_value <= values[39:35];
                default: current_value <= 5'h00;
            endcase
        end
    end

    // 7-segment display decoding
    always @* begin
        case (current_value)
            5'd0: seg = ~8'hC0;  // 0
            5'd1: seg = ~8'hF9;  // 1
            5'd2: seg = ~8'hA4;  // 2
            5'd3: seg = ~8'hB0;  // 3
            5'd4: seg = ~8'h99;  // 4
            5'd5: seg = ~8'h92;  // 5
            5'd6: seg = ~8'h82;  // 6
            5'd7: seg = ~8'hF8;  // 7
            5'd8: seg = ~8'h80;  // 8
            5'd9: seg = ~8'h90;  // 9
            5'd10: seg = ~8'h88; // A
            5'd11: seg = ~8'h83; // B
            5'd12: seg = ~8'hC6; // C
            5'd13: seg = ~8'hA1; // D
            5'd14: seg = ~8'h86; // E
            5'd15: seg = ~8'b10001110; // F
            5'd16: seg = ~8'hBF; // '-'
            5'd17: seg = ~8'hFF; // Blank
            default: seg = ~8'hFF; // Default: Blank
        endcase
        seg1 = seg;
    end

endmodule
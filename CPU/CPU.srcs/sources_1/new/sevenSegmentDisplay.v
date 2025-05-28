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
    input wire [31:0] IOout,        // 32-bit input values (8 digits,4 bits each)
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
    reg [3:0] current_value = 0;    // Current value (4 bits)

    // Clock divider logic remains unchanged
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

    // Multiplexing logic for selecting the active digit and extracting current_value
    always @(posedge divclk or negedge rst) begin
        if (~rst) begin
            current_digit <= 0;
            an <= 8'h0;             // All digits off
        end else begin
            current_digit <= (current_digit == 7) ? 3'd0 : current_digit + 1'b1;

            // Activate corresponding digit's anode
            case (current_digit)
                3'd0: an <= 8'h01;  // Digit 0 active (using hexadecimal literals for clarity)
                3'd1: an <= 8'h02;
                3'd2: an <= 8'h04;
                3'd3: an <= 8'h08;
                3'd4: an <= 8'h10;
                3'd5: an <= 8'h20;
                3'd6: an <= 8'h40;
                3'd7: an <= 8'h80;
                default: an <= 8'h00; // All off in case of invalid digit (should not occur)
            endcase

            // Extract current 4-bit value from the input
            case (current_digit)
                3'd0: current_value <= IOout[3:0];   // Bits [3:0]
                3'd1: current_value <= IOout[7:4];   // Bits [7:4]
                3'd2: current_value <= IOout[11:8];  // Bits [11:8]
                3'd3: current_value <= IOout[15:12]; // Bits [15:12]
                3'd4: current_value <= IOout[19:16]; // Bits [19:16]
                3'd5: current_value <= IOout[23:20]; // Bits [23:20]
                3'd6: current_value <= IOout[27:24]; // Bits [27:24]
                3'd7: current_value <= IOout[31:28]; // Bits [31:28]
                default: current_value <= 4'h0;      // Default to 0
            endcase
        end
    end

    // Seven-segment decoding for hexadecimal digits (0-9, A-F)
    always @* begin
        case (current_value)
            4'd0: seg = ~8'hC0;     // '0'
            4'd1: seg = ~8'hF9;     // '1'
            4'd2: seg = ~8'hA4;     // '2'
            4'd3: seg = ~8'hB0;     // '3'
            4'd4: seg = ~8'h99;     // '4'
            4'd5: seg = ~8'h92;     // '5'
            4'd6: seg = ~8'h82;     // '6'
            4'd7: seg = ~8'hF8;     // '7'
            4'd8: seg = ~8'h80;     // '8'
            4'd9: seg = ~8'h90;     // '9'
            
            // Hex letters A-F
            4'd10: seg = ~8'h88;    // 'A'
            4'd11: seg = ~8'h83;    // 'B'
            4'd12: seg = ~8'hC6;    // 'C'
            4'd13: seg = ~8'hA1;    // 'D' 
            4'd14: seg = ~8'h86;    // 'E'
            4'd15: seg = ~8'h8E;    // 'F'
            
            default: seg = ~8'hFF;  // Turn off all segments if invalid
        endcase
        
        seg1 <= seg;                // Copy to both segments for symmetry (if needed)
    end

endmodule
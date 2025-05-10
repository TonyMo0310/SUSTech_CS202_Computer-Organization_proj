module immGen(
    input [31:0] instruction,
    output reg [31:0] immediate
    );
    always @*
    begin
        case(instruction[6:0])
            7'b0000011,7'b1100111,7'b0010011:begin// I type
                if(instruction[31])
                    immediate={20'b11111_11111_11111_11111,instruction[31:20]};
                else
                    immediate={20'b00000_00000_00000_00000,instruction[31:20]};
            end
            7'b0100011:begin//S type
                if(instruction[31])
                    immediate={20'b11111_11111_11111_11111,instruction[31:25],instruction[11:7]};
                else
                    immediate={20'b00000_00000_00000_00000,instruction[31:25],instruction[11:7]};
            end
            7'b1100011:begin//SB type
                if(instruction[31])
                    immediate={19'b11111_11111_11111_1111,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
                else
                    immediate={19'b00000_00000_00000_0000,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
            end
            7'b0010111,7'b0110111://U type
                immediate={instruction[31:12],10'b00000_00000};
            7'b1101111:begin//UJ type
                if(instruction[31])
                    immediate={11'b11111_11111_1,instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
                else
                    immediate={11'b00000_00000_0,instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
            end
            default:immediate=32'b00000000_00000000_00000000_00000000;
        endcase
    end
endmodule
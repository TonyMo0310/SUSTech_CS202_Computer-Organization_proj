`timescale 1ns / 1ps

module tb_CPU_top;
    reg clk;
    reg rst;
    reg [31:0] switchInput;
    reg [31:0] IOin;
    wire [31:0] IOout;
    wire [31:0] sevenSegmentDisplay;

    CPU_top uut (
        .clk(clk),
        .rst(rst),
        .switchInput(switchInput),
        .IOin(IOin),
        .IOout(IOout),
        .sevenSegmentDisplay(sevenSegmentDisplay)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns 周期
    end

    initial begin
        rst = 1;
        #15 rst = 0; // 15 ns 后释放复位
        switchInput = 32'h00000001; // 开关打开
        IOin = 32'hA5A5A5A5;

        // 加载 calc_display.asm 机器码
        #20;
        $display("Starting Test Case 1: Calc Display");
        uut.instruction_memory[0] = 32'h00200093;  // addi x1, x0, 2
        uut.instruction_memory[1] = 32'h00300113;  // addi x2, x0, 3
        uut.instruction_memory[2] = 32'h00208233;  // add x3, x1, x2
        uut.instruction_memory[3] = 32'h00302223;  // sw x3, 4(x0)
        uut.instruction_memory[4] = 32'h00500213;  // addi x4, x0, 5
        uut.instruction_memory[5] = 32'h00402423;  // sw x4, 8(x0)
        uut.instruction_memory[6] = 32'h0000006F;  // jal x0, halt
        #500;

        // 加载 switch_led.asm 机器码
        $display("Starting Test Case 2: Switch LED");
        uut.instruction_memory[0] = 32'h00000883;  // lw x1, 12(x0)
        uut.instruction_memory[1] = 32'h00008863;  // beq x1, x0, off
        uut.instruction_memory[2] = 32'h00100113;  // addi x2, x0, 1
        uut.instruction_memory[3] = 32'h00202023;  // sw x2, 0(x0)
        uut.instruction_memory[4] = 32'h0080006F;  // jal x0, done
        uut.instruction_memory[5] = 32'h00000113;  // addi x2, x0, 0
        uut.instruction_memory[6] = 32'h00202023;  // sw x2, 0(x0)
        uut.instruction_memory[7] = 32'h0000006F;  // jal x0, halt
        #500;

        $finish;
    end

    always @(posedge clk) begin
        if (uut.dataMem.address == 32'h00000004 && uut.MEMen && uut.memWrite)
            $display("Calc Display: Memory[0x04] = 0x%h (expected 0x5)", uut.dataMem.writeData);
        if (uut.dataMem.address == 32'h00000008 && uut.MEMen && uut.memWrite)
            $display("Calc Display: SevenSegment = 0x%h (expected 0x5)", sevenSegmentDisplay);
        if (uut.dataMem.address == 32'hFFFFFC00 && uut.MEMen && uut.memWrite)
            $display("Switch LED: IOout = 0x%h (expected 0x1)", IOout);
    end

    initial begin
        $dumpfile("cpu_top_tb.vcd");
        $dumpvars(0, tb_CPU_top);
    end
endmodule
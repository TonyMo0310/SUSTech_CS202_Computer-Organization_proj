`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19
// Design Name: 
// Module Name: RAM_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for RAM module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module RAM_tb;
    // �����ź�
    reg clk;
    reg wea;
    reg [13:0] addra; // 14 λ��ַ������ address[15:2]
    reg [31:0] dina;

    // ����ź�
    wire [31:0] douta;

    // ʵ���� RAM ģ��
    RAM udram (
        .clka(clk),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(douta)
    );

    // ʱ������
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns ����
    end

    // ��������
    initial begin
        // ��ʼ��
        wea = 0;
        addra = 14'h0000;
        dina = 32'h00000000;
        #20;

        // ���� 1: ������д����ַ 0��
        wea = 1;                // ����д��
        addra = 14'h0000;       // ��ַ 0
        dina = 32'hAABBCCDD;    // д������
        #10;
        wea = 0;                // �л�����ȡ
        #10;
        $display("Test 1: Basic Read/Write at address 0x%h, douta=0x%h (expected 0xAABBCCDD)", addra, douta);
        if (douta == 32'hAABBCCDD)
            $display("Test 1 Passed");
        else
            $display("Test 1 Failed");

        // ���� 2: ������ַ��д����ַ 1 �� 2��
        wea = 1;
        addra = 14'h0001;       // ��ַ 1
        dina = 32'h11223344;
        #10;
        addra = 14'h0002;       // ��ַ 2
        dina = 32'h55667788;
        #10;
        wea = 0;
        #10;
        addra = 14'h0001;       // ��ȡ��ַ 1
        #10;
        $display("Test 2a: Read at address 0x%h, douta=0x%h (expected 0x11223344)", addra, douta);
        if (douta == 32'h11223344)
            $display("Test 2a Passed");
        else
            $display("Test 2a Failed");
        addra = 14'h0002;       // ��ȡ��ַ 2
        #10;
        $display("Test 2b: Read at address 0x%h, douta=0x%h (expected 0x55667788)", addra, douta);
        if (douta == 32'h55667788)
            $display("Test 2b Passed");
        else
            $display("Test 2b Failed");

        // ���� 3: �߽��ַ������ַ 16383��
        wea = 1;
        addra = 14'h3FFF;       // ����ַ 16383 (2^14 - 1)
        dina = 32'h99AABBCC;
        #10;
        wea = 0;
        #10;
        $display("Test 3: Read at address 0x%h, douta=0x%h (expected 0x99AABBCC)", addra, douta);
        if (douta == 32'h99AABBCC)
            $display("Test 3 Passed");
        else
            $display("Test 3 Failed");

        // ���� 4: ���ǲ��ԣ����δд���ַ��
        addra = 14'h0003;       // δд��ĵ�ַ 3
        #10;
        $display("Test 4: Read at address 0x%h, douta=0x%h (expected 0x00000000)", addra, douta);
        if (douta == 32'h00000000) // ����δд���ַ��ʼ��Ϊ 0������ .coe �ļ���
            $display("Test 4 Passed");
        else
            $display("Test 4 Failed");

        // ���Խ���
        #20;
        $finish;
    end

    // ���μ�¼����ѡ��
    initial begin
        $dumpfile("ram_tb.vcd");
        $dumpvars(0, RAM_tb);
    end
endmodule
module registers(
    input          clk,        // ʱ���źţ���������Ч��
    input          rst,        // ��λ�źţ��͵�ƽ���ͬ����λ��
    input   [4:0]  readRegister1,
    input   [4:0]  readRegister2,
    input   [4:0]  writeRegister,
    input   [31:0] writeData,  
    input WBen,
    output reg [31:0] readData1,
    output reg [31:0] readData2,
    input          regWrite     // дʹ���ź�
);
// ��������32���Ĵ��������飨ÿ���Ĵ���Ϊ32λ��
reg [31:0] registers [0:31];
integer i;
always@(posedge clk or negedge rst)//���������
begin
 if(!rst)begin
  for (i = 0; i < 2; i = i + 1)
   registers[i] <= 32'h0;
  registers[2]=32'b0000_0000_0000_0000_1111_1111_1111_1000;//���⴦��sp�Ĵ���
  for (i = 3; i < 32; i = i + 1)
   registers[i] <= 32'h0;
 end else begin
 if (regWrite&&WBen) begin   // дʹ����Чʱ����д��
  if (writeRegister != 5'd0)  // �ų���ֻ���Ĵ���x0���޸�
    registers[writeRegister] <= writeData;
  end
 end
end

always@*
begin
 readData1=registers[readRegister1];
 readData2=registers[readRegister2];
end
endmodule
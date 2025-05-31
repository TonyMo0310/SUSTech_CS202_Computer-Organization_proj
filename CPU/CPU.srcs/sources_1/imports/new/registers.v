module registers(
    input          clk,        // 时钟信号（上升沿有效）
    input          rst,        // 复位信号（低电平激活，同步复位）
    input   [4:0]  readRegister1,
    input   [4:0]  readRegister2,
    input   [4:0]  writeRegister,
    input   [31:0] writeData,  
    input WBen,
    output reg [31:0] readData1,
    output reg [31:0] readData2,
    input          regWrite     // 写使能信号
);
// 声明包含32个寄存器的数组（每个寄存器为32位）
reg [31:0] registers [0:31];
integer i;
always@(posedge clk or negedge rst)//存入和重置
begin
 if(!rst)begin
  for (i = 0; i < 2; i = i + 1)
   registers[i] <= 32'h0;
  registers[2]=32'b0000_0000_0000_0000_1111_1111_1111_1000;//特殊处理sp寄存器
  for (i = 3; i < 32; i = i + 1)
   registers[i] <= 32'h0;
 end else begin
 if (regWrite&&WBen) begin   // 写使能有效时触发写入
  if (writeRegister != 5'd0)  // 排除对只读寄存器x0的修改
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
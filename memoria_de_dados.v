module datamemory(
  input [31:0] address,
  input [31:0] WriteData,
  input MemWrite,
  input MemRead,
  output [31:0] DataMemory
);

reg [31:0] mem [127:0];
always @ (MemWrite, MemRead) begin
  if(MemWrite == 1'b1) begin
    mem[address] = WriteData;
  end
end
assign DataMemory = MemWrite ? WriteData: mem[address][31:0];
endmodule

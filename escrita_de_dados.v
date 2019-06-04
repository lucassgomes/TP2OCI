module muxdata(
  input MemtoReg,
  input [31:0] readDataMemory,
  input [31:0] ALURst,
  output reg [31:0] writeData
);
always @(MemtoReg) begin
  if(MemtoReg == 0) begin
    writeData = ALURst;
  end
  if(MemtoReg == 1) begin
    writeData = readDataMemory;
  end
end
endmodule

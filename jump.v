module shiftjump(
  input [31:0] inst,
  output [25:0] target,
  output reg [27:0] addressShiftJ
);
  assign target = inst[25:0];
  always @ (inst) begin
    addressShiftJ = target << 2;
  end
endmodule

module addressJump(
  input [27:0] addressShiftJ,
  input [31:0] somador,
  output reg [3:0] pc4,
  output reg [31:0] addressJ
);

always@(addressShiftJ) begin
pc4 = somador[31:28];
addressJ = addressShiftJ+pc4;
end
endmodule

module muxjump(
  input [31:0] addressJ,
  input [31:0] addressFin,
  input Jump,
  output reg [31:0] addressFinal
);

always @(Jump) begin
if(Jump == 0) begin
  addressFinal = addressFin;
end
else if(Jump == 1) begin
  addressFinal = addressJ;
end
end
endmodule

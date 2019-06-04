////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
// - Create Date: 25/05/2018                                                                  //
// - Developer: Paulo Brandao e Lucas Soares                                                  //
// - Module Name: Bloco II - Leitura dos registradores                                        //
// - Project Name: Caminho de dados MIPS                                                      //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////
module instruction(
    input [31:0] addressIn,
    output [5:0] opcode,
    output reg[4:0] rs,
    output reg[4:0] rt,
    output reg[4:0] rd,
    output reg[5:0] FuncCode,
    output reg[15:0] address
);

assign opcode = addressIn[31:26];
always @(addressIn) begin
  rs = addressIn[25:21];
  rt = addressIn[20:16];
  rd = addressIn[15:11];
  FuncCode = addressIn[5:0];
  address = addressIn[15:0];
end
endmodule

module control(
    input [5:0] opcode,
    output reg RegDst,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg Jump,
    output reg ALUSrc,
    output reg RegWrite,
    output reg [1:0] ALUOp
);

always @(opcode) begin
  //R
  if(opcode == 6'b000000) begin
    RegDst = 1;
    Branch = 0;
    MemRead = 0;
    MemtoReg = 0;
    MemWrite = 0;
    Jump = 0;
    ALUSrc = 0;
    RegWrite = 1;
    ALUOp = 2'b10;
  end
  //LW
  else if(opcode == 6'b100011) begin
    RegDst = 0;
    Branch = 0;
    MemRead = 1;
    MemtoReg = 1;
    MemWrite = 0;
    Jump = 0;
    ALUSrc = 1;
    RegWrite = 1;
    ALUOp = 2'b00;
  end
  //SW
  else if(opcode == 6'b101011) begin
    RegDst = 0;
    Branch = 0;
    MemRead = 0;
    MemtoReg = 0;
    MemWrite = 1;
    Jump = 0;
    ALUSrc = 1;
    RegWrite = 0;
    ALUOp = 2'b00;
  end
  //BEQ
  else if(opcode == 6'b000100) begin
    RegDst = 0;
    Branch = 1;
    MemRead = 0;
    MemtoReg = 0;
    MemWrite = 0;
    Jump = 0;
    ALUSrc = 0;
    RegWrite = 0;
    ALUOp = 2'b01;
  end
  //J
  else if(opcode == 6'b	000010) begin
  RegDst = 0;
  Branch = 0;
  MemRead = 0;
  MemtoReg = 0;
  MemWrite = 0;
  Jump = 1;
  ALUSrc = 0;
  RegWrite = 0;
  ALUOp = 2'b11;
  end
  end
endmodule



module MUX(
  input [4:0] rd, //parte [15:11] da instrucao
  input [4:0] rt, //parte [20:16] da instrucao
  input RegDst,
  output reg [4:0] RegMUXOut
);
    always @ (RegDst) begin
      if (RegDst == 1'b1) begin
        RegMUXOut = rd;
      end
      if (RegDst == 1'b0) begin
        RegMUXOut = rt;
      end
    end
endmodule

module registers(
  input RegWrite,
  input [4:0] WriteRegister, //recebe resultado do MUX
  input [4:0] rs, //Read Register 1 parte [25:21] da instrucao
  input [4:0] rt, //Read Register 2 parte [20:16] da instrucao
  input [4:0] rd, //parte [15:11] da instrução
  output [31:0] readData1, //Saida de dados 1
  output [31:0] readData2 //Saida de dados 2
);

//Banco de registradores
reg [31:0]BancoReg[31:0]; //Armazena dados contidos nos registradores
initial begin
    BancoReg[0] = 32'b00000000000000000000000000000000;
    BancoReg[1] = 32'b00000000000000000000000000000001;
    BancoReg[2] = 32'b00000000000000000000000000000010;
    BancoReg[3] = 32'b00000000000000000000000000000011;
    BancoReg[4] = 32'b00000000000000000000000000000100;
    BancoReg[5] = 32'b00000000000000000000000000000101;
    BancoReg[6] = 32'b00000000000000000000000000000110;
    BancoReg[7] = 32'b00000000000000000000000000000111;
    BancoReg[8] = 32'b00000000000000000000000000001000;
    BancoReg[9] = 32'b00000000000000000000000000001001;
    BancoReg[10] = 32'b00000000000000000000000000001010;
    BancoReg[11] = 32'b00000000000000000000000000001011;
    BancoReg[12] = 32'b00000000000000000000000000001100;
    BancoReg[13] = 32'b00000000000000000000000000001101;
    BancoReg[14] = 32'b00000000000000000000000000001110;
    BancoReg[15] = 32'b00000000000000000000000000001111;
    BancoReg[16] = 32'b00000000000000000000000000010000;
    BancoReg[17] = 32'b00000000000000000000000000010001;
    BancoReg[18] = 32'b00000000000000000000000000010010;
    BancoReg[19] = 32'b00000000000000000000000000010011;
    BancoReg[20] = 32'b00000000000000000000000000010100;
    BancoReg[21] = 32'b00000000000000000000000000010101;
    BancoReg[22] = 32'b00000000000000000000000000010110;
    BancoReg[23] = 32'b00000000000000000000000000010111;
    BancoReg[24] = 32'b00000000000000000000000000011000;
    BancoReg[25] = 32'b00000000000000000000000000011001;
    BancoReg[26] = 32'b00000000000000000000000000011010;
    BancoReg[27] = 32'b00000000000000000000000000011011;
    BancoReg[28] = 32'b00000000000000000000000000011100;
    BancoReg[29] = 32'b00000000000000000000000000011101;
    BancoReg[30] = 32'b00000000000000000000000000011110;
    BancoReg[31] = 32'b00000000000000000000000000011111;
  end
  always @ (WriteRegister) begin
    if(RegWrite == 1'b1) begin
      BancoReg[rd] = WriteRegister;
    end
  end
  assign readData1 = BancoReg[rs];
  assign readData2 = BancoReg[rt];
endmodule

//Extensao
module extensor(
    input [15:0]entrada,
    output [31:0]saida
);
    assign saida[15:0] = entrada[15:0];
    assign saida[31:16] = entrada[15];
endmodule

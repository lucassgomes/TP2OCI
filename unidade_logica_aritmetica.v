////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
// - Create Date: 25/05/2018                                                                  //
// - Developer: Paulo Brandao e Lucas Soares                                                  //
// - Module Name: Bloco III - ULA - Unidade Logica Aritmetica                                 //
// - Project Name: Caminho de dados MIPS                                                      //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////

// a) Instrucao logica Aritmetica
//    recebe o valor do registrador 1 (Read data 1) e o valor selecionado no MUX
//    entre o registrador 2 (Read data 2) e a instrucao extendida [15:0] apos
//    passar pelo Sign-extend
// b) Calculo do Endereco
//    E dado por um Registrador Base (Read data 1) somado aos 16bits que foram
//    extendidos para 32bits pelo Sign-extend.
//    Load Store - o MUX seleciona a entrada debaixo
// c) Calculo de Endereco do Desvio condicional
//    Compara os 2 valores do registradores e gera sinal ZERO para determinar a
//    a igualdade. em paralelo, calcula o endereco para onde vai desviar.
//    Utiliza o PC atualizado (+4) e soma com os 16bits apos extensao para 32bits
//    O valor extendido e deslocado 2 vezes a esquerda (shift left <<2) pois o PC
//    esta atualizado (+4), ajustando as posicoes.

module ULAControl(
  input [5:0] FuncCode,
  input [1:0] ALUOp,
  output reg [3:0] ALUCtl
);
always @(ALUOp, FuncCode) begin
if(ALUOp == 2'b10) begin
    case(FuncCode)
        6'b100000: ALUCtl = 4'b0010; //add
        6'b100010: ALUCtl = 4'b0110; //sub
        6'b100100: ALUCtl = 4'b0000; //and
        6'b100101: ALUCtl = 4'b0001; //or
        6'b101010: ALUCtl = 4'b0111; //slt
    endcase
end
else if(ALUOp == 2'b00) begin
    ALUCtl = 4'b0010; //lw sw
end
else if(ALUOp == 2'b01) begin
    ALUCtl = 4'b0110; //beq
end
end
endmodule
//MUX que define a segunda entrada da ULA,entre
//Read Data 2 e a instrucao extendida 32bits.
module MuxULA(
  input [31:0]valueMux0, //recebe Read data 2 do Banco de Registradores
  input [31:0]valueMux1, //recebe a instrucao [15:0] apos o Sign-extend
  input ALUSrc, //Sinal de controle
  output reg[31:0] RegMUXoutULA
);
    always @(ALUSrc) begin
      if (ALUSrc == 1'b1) begin
        RegMUXoutULA = valueMux1;
      end
      if(ALUSrc == 1'b0) begin
        RegMUXoutULA = valueMux0;
      end
    end
endmodule

module ULA(
  input [31:0]value1,
  input [31:0]value2,
  input [3:0]ALUControl,
  output reg [31:0]ALUResult,
  output reg zero
);
  always @ (ALUControl, value1, value2)
  begin
    case (ALUControl)
      4'b0000: ALUResult = value1 & value2;
      4'b0001: ALUResult = value1 | value2;
      4'b0010: ALUResult = value1 + value2;
      4'b0110: ALUResult = value1 - value2;
      4'b0111: ALUResult = value1 < value2 ? 1 : 0;
      4'b1100: ALUResult = ~(value1 | value2);
      default: ALUResult = 32'b0;
    endcase
  end
  always @ (ALUResult) begin
  if(ALUResult == 0) begin
    zero = 1;
  end
  else begin
    zero = 0;
  end
  end
endmodule

module controleand(
  input Branch,
  input Zero,
  output reg controland
);
always @(Branch, Zero) begin
controland = Branch & Zero;
end
endmodule

//Descolamento
module shift(
  input [31:0] addressExtendido,
  output reg [31:0] addressShift
);
always @(addressExtendido) begin
addressShift = addressExtendido << 2;
end
endmodule

module ULAAdd(
  input [31:0] addressSomador,
  input [31:0] addressShift,
  output reg [31:0] ALUResult
);
always @ (addressShift, addressSomador) begin
  ALUResult = addressSomador + addressShift;
end
endmodule

//Multiplexador do Desvio condicional
module muxDesvio(
  input [31:0] in0, //Valor 1 de entrada no MUX de desvio condicional
  input [31:0] in1, //Valor 2 de entrada no MUX de desvio condicional
  input controland, //Controle de sinal apos AND
  output reg [31:0] addressDesvio //Saida do MUX de desvio condicional
);

  always @ (controland) begin
    if(controland == 1'b1) begin
      addressDesvio = in1;
    end
    else begin
      addressDesvio = in0;
    end
  end
endmodule

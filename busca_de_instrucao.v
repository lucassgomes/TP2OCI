////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
// - Create Date: 25/05/2018                                                                  //
// - Developer: Paulo Brandao e Lucas Soares                                                  //
// - Module Name: Bloco I - Acessar instruçao na memoria                                      //
// - Project Name: Caminho de dados MIPS                                                      //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////

//PC (process_count) [envia um endereco de 32bits para a memoria de instrucao]
//InstructionMemory [Recebe o endereco do PC e envia para os registradores em forma de instrucao]
//InstructionMemory: MIPS simplificado, sera implementado instrucoes do tipo R, lw, sw e beq


//PC (Process Count)
module process_count(
  input [31:0] addressInPC,              //addressIn -> Endereco que o PC recebe (entrada1) ao iniciar
  input clk,
  output reg[31:0] addressOut          //addressOut -> Endereco que o PC envia para a Instruction Memory (saida)
);
  initial begin
    addressOut = addressInPC;
  end
  always @(clk)
    begin
      addressOut = addressInPC;
//      $monitor("atual: %d\n",addressOut);
    end

endmodule

//Instruction Memory
module instruction_memory(
    input [31:0]addressIn,              //addressIn -> endereco recebido do process_count (entrada)
    output reg[31:0]InstructionOut,         //InstructionOut ->instrucao enviada para leitura dos registradores (saida)
    output reg[31:0]ProxInstruction //ProxInstruction -> Próxima instrução
  );
  reg[31:0]InstructionEnd[8:0];
  initial begin
    InstructionEnd[0] = 32'b00000010001100100100000000100000; //add $t0,$s1,$s2
    InstructionEnd[1] = 32'b00000001000010011000000000100010; //sub $s0,$t0,$t1
    InstructionEnd[2] = 32'b00000001001010100100000000100101; //or $t0,$t1,$t2
    InstructionEnd[3] = 32'b10001110011010000000000000001000; //lw $t0, 8($s3)
    InstructionEnd[4] = 32'b00000001001010100100000000100100; //and $t0,$t1,$t2
    InstructionEnd[5] = 32'b10101110011010000000000000110000; //sw $t0, 48($s3)
    InstructionEnd[6] = 32'b00010010001100010000000000000001; //beq $s1,$s1,1
    InstructionEnd[7] = 32'b00001000000000000000000000001000; //j 8
    InstructionEnd[8] = 32'b00000010011101000100000000101010; //slt $t0,$s3,$s4
  end
  always @ (addressIn)
  begin
    InstructionOut = InstructionEnd[addressIn/32'b00000000000000000000000000000100];
    $display("Instrucao: %b", InstructionOut);
    ProxInstruction = InstructionEnd[(addressIn+4)/4];
    $display("Prox Instrucao: %b", ProxInstruction);
  end
endmodule

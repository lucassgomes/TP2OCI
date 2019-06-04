`include "busca_de_instrucao.v"
`include "leitura_dos_registradores.v"
`include "unidade_logica_aritmetica.v"
`include "memoria_de_dados.v"
`include "escrita_de_dados.v"
`include "jump.v"

module test;
  //PC
  reg [31:0] addressIn;
  reg clk;
  wire [31:0] addressOut;

  //IM
  wire [31:0] InstructionOut;
  wire [31:0] ProxInstruction;

  //instrução dividida
  wire[4:0]rt,rs,rd;
  wire[5:0]FuncCode,opcode;
  wire[15:0]address;

  //Multiplexador instrução
  wire [4:0]RegMUXOut;

  //control
  wire RegDst, Branch, MemRead, MemtoReg, MemWrite, Jump, ALUSrc, RegWrite;
  wire [1:0]ALUOp;

  //db registradores
  wire [31:0] readData1, readData2;

  //extensor de Sinal
  wire [31:0] address32;

  //Multiplexador ALU
  wire [31:0] RegMUXoutULA;

  //ALU
  wire [31:0] ALUResult;
  wire [3:0] ALUCtl;
  wire Zero;

  //AND
  wire controland;

  //shift
  wire [31:0] addressShift;

  //Somador
  wire [31:0] somador;
  wire [31:0] ALUResultAdd;

  //Mux add
  wire [31:0] addressFin;

  //Escrita de dados
  wire [31:0] DataMemory;

  //Mux Escrita
  wire [31:0] writeData;

  //Jump
  wire [25:0] target;
  wire [27:0] addressShiftJ;

  wire [3:0] pc4;
  wire [31:0] addressJ;

  wire  [31:0] addressFinal;

  process_count pc(
		.addressInPC(addressIn),
		.addressOut(addressOut),
    .clk(clk)
	);

  instruction_memory im(
    .addressIn(addressOut),
		.InstructionOut(InstructionOut),
    .ProxInstruction(ProxInstruction)
  );

  instruction inst(
    .addressIn(InstructionOut),
    .opcode(opcode),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .FuncCode(FuncCode),
    .address(address)
  );

  control controlador(
    .opcode(opcode),
    .RegDst(RegDst),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Jump(Jump),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp)
  );

  MUX multplexador(
    .rd(rd),
    .rt(rt),
    .RegDst(RegDst),
    .RegMUXOut(RegMUXOut)
  );

  registers dbreg(
    .RegWrite(RegWrite),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .WriteRegister(RegMUXOut),
    .readData1(readData1),
    .readData2(readData2)
  );

  extensor extends(
    .entrada(address),
    .saida(address32)
  );

  MuxULA muxula(
    .valueMux0(readData2),
    .valueMux1(address32),
    .ALUSrc(ALUSrc),
    .RegMUXoutULA(RegMUXoutULA)
  );

  ULAControl alucontrol(
    .FuncCode(FuncCode),
    .ALUOp(ALUOp),
    .ALUCtl(ALUCtl)
  );

  ULA alu(
    .value1(readData1),
    .value2(RegMUXoutULA),
    .ALUControl(ALUCtl),
    .ALUResult(ALUResult),
    .zero(Zero)
  );

  controleand portand(
    .Branch(Branch),
    .Zero(Zero),
    .controland(controland)
  );

  shift deslocamento(
    .addressExtendido(address32),
    .addressShift(addressShift)
  );

  ULAAdd addula(
    .addressSomador(ProxInstruction),
    .addressShift(addressShift),
    .ALUResult(ALUResultAdd)
  );

  muxDesvio desvio(
    .in0(ProxInstruction),
    .in1(ALUResultAdd),
    .controland(controland),
    .addressDesvio(addressFin)
  );

  datamemory dm(
    .address(ALUResult),
    .WriteData(readData2),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .DataMemory(DataMemory)
  );

  muxdata datamu(
    .MemtoReg(MemtoReg),
    .ALURst(ALUResult),
    .readDataMemory(DataMemory),
    .writeData(writeData)
  );

  shiftjump shtj(
    .inst(InstructionOut),
    .target(target),
    .addressShiftJ(addressShiftJ)
  );

  addressJump jumpaddress(
    .addressShiftJ(addressShiftJ),
    .somador(ProxInstruction),
    .pc4(pc4),
    .addressJ(addressJ)
  );

  muxjump jumpmux(
    .addressJ(addressJ),
    .addressFin(addressFin),
    .Jump(Jump),
    .addressFinal(addressFinal)
  );

  initial begin
    $dumpfile("MIPS.vcd");
    $dumpvars;
    clk = 0; addressIn=0;
    #1 clk=!clk; addressIn=4;
    $display("Saida ALU: %b", ALUResult);
    #1 clk=!clk; addressIn=8;
    $display("Saida ALU: %b", ALUResult);
    #1 clk=!clk; addressIn=12;
    $display("Saida ALU: %b", ALUResult);
    #1 clk=!clk; addressIn=16;
    $display("Saida ALU: %b", ALUResult);
    #1 clk=!clk; addressIn=20;
    $display("Saida ALU: %b", ALUResult);
    #1 clk=!clk; addressIn=24;
    $display("Saida ALU: %b", ALUResult);
    #1 clk=!clk; addressIn=28;
    $display("Saida ALU: %b", ALUResult);
    #1 clk=!clk; addressIn=32;
    $display("Saida ALU: %b", ALUResult);
    #1 clk=!clk;
  end
endmodule

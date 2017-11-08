`timescale 1ns/10ps

module cpu(reset, clk);
	input logic reset, clk;
	logic [31:0] instruction;
	logic [63:0] instr_addr;

	// Controls
	logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc, MemWrite,
		CmpMode, ImmInstr, ByteOrFull, ByteorFullData, MemToReg,
		DataMemRead, clear, mov;

	// instr. args
	logic [2:0] ALUOp;
	logic [8:0] DAddr9;
	logic [11:0] Imm12;
	logic [15:0] Imm16;
	logic [1:0] shamt;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;

	// Extended args
	logic [63:0] Imm64, Daddr64;

	// Addr's
	logic [4:0] Rd, Rm, Rn, RegChoose;

	// Data
	logic [63:0] Da, Db;
	logic [3:0] flags;
	logic negative, zero, overflow, carry_out;
	logic [63:0] ALUResult, addArg, constArg, fullOrByte, WrD;

	// Choose memData controls
	logic [3:0] size;
	logic [63:0] ReadDataMem;

	// Final Data being written
	logic [63:0] WriteData;

	// mov
	logic [63:0] inserted, aluOut;

	program_counter PC(
		.program_index(instr_addr),
		.cond_addr(CondAddr19),
		.br_addr(BrAddr26),
		.uncondbr(UncondBr),
		.br_taken(BrTaken),
		.reset(reset),
		.clk(clk)
	);

	instructmem memory(
		.address(instr_addr),
		.instruction(instruction),
		.clk(clk)
	);

	instr_decoder controls(
		.instruction,
		.ZeroFlag(zero),
		.flags,
		.UncondBr,
		.BrTaken,
		.Reg2Loc,
		.RegWrite,
		.ALUSrc,
		.ALUOp,
		.CmpMode,
		.ImmInstr,
		.MemWrite,
		.DAddr9,
		.Imm12,
		.shamt,
		.Imm16,
		.CondAddr19,
		.BrAddr26,
		.ByteOrFull,
		.ByteorFullData,
		.DataMemRead,
		.MemToReg,
		.Rn,
		.Rm,
		.Rd,
		.clear,
		.mov
	);

	// Proceccinfg block
	n_mux2_1 #5 ChooseWhatInput(
		.out(RegChoose),
		.in0(Rd),
		.in1(Rm),
		.sel(Reg2Loc)
	);

	regfile registerFile(
		.ReadData1(Da),
		.ReadData2(Db),
		.WriteData(WrD),
		.ReadRegister1(Rn),
		.ReadRegister2(RegChoose),
		.WriteRegister(Rd),
		.RegWrite(RegWrite),
		.reset(reset),
		.clk(clk)
	);

	sign_extend #(9, 64) extDaddr(
		.in(DAddr9),
		.out(Daddr64)
	);

	sign_extend_unsigned #(12, 64) extImm12(
		.in(Imm12),
		.out(Imm64)
	);


	Big64mux2_1 ChooseConstant(
		.out(constArg),
		.in0(Daddr64),
		.in1(Imm64),
		.sel(ImmInstr)
	);

	Big64mux2_1 ChooseConstantOrDb(
		.out(addArg),
		.in0(Db),
		.in1(constArg),
		.sel(ALUSrc)
	);

	alu mainALU(
		.A(Da),
		.B(addArg),
		.cntrl(ALUOp),
		.result(ALUResult),
		.negative,
		.zero,
		.overflow,
		.carry_out
	);

	// Decides transfer amount
	n_mux2_1 #4 TransferAmt(
		.out(size),
		.in0(4'b1000),
		.in1(4'b0001),
		.sel(ByteOrFull)
	);

	datamem dataMemory(
	.address(ALUResult),
	.write_enable(MemWrite),
	.read_enable(DataMemRead),
	.write_data(Db),
	.clk(clk),
	.xfer_size(size),
	.read_data(ReadDataMem)
	);

	Big64mux2_1 RegWriteDataMux(
		.out(WriteData),
		.in0(ALUResult),
		.in1(ReadDataMem),
		.sel(MemToReg)
	);

	Big64mux2_1 LoadFullDataOrByte (
		.out(WrD),
		.in0(WriteData),
		.in1({56'b00000000000000000000000000000000000000000000000000000000, WriteData[7:0]}),
		.sel(ByteorFullData)
	);

	Reg_Create #(4) FlagRegister(
		.q(flags),
		.in({negative, zero, overflow, carry_out}),
		.en(CmpMode),
		.reset(reset),
		.clk(clk)
	);

	transposer mov1(
		.data(Db),
		.fixed(Imm16),
		.shamt(shamt),
		.clear(clear),
		.out(inserted)
	);

	Big64mux2_1 aluMux(
		.out(aluOut),
		.in0(ALUResult),
		.in1(inserted),
		.sel(mov)
	);


endmodule

module cpu_testbench();

	parameter ClockDelay = 5000;
	logic clk, reset;
	cpu dut (.reset, .clk);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	integer i;
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for (i = 0; i < 30; i++) begin
			@(posedge clk);
		end
		$stop;
	end
	
		
		
endmodule

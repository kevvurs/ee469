module cpu(reset, clk);
	input logic reset, clk;
	logic [31:0] instruction;
	logic [63:0] instr_addr;

	// Controls
	logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc, ALUOp, MemWrite,
		CmpMode, ImmInstr, ByteOrFull, MemToReg, DataMemRead;

	// instr. args
	logic [8:0] Daddr9;
	logic [11:0] Imm12;
	logic [15:0] Imm16;
	logic [6:0] shamt;
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
	logic [63:0] ALUResult, addArg, constArg;
	
	// Choose memData controls
	logic [3:0] size;
	logic [63:0] ReadDataMem;
	
	// Final Data being written
	logic [63:0] WriteData;

	program_counter PC(
		.program_index(instr_addr),
		.cond_addr(instruction[23:5]),
		.br_addr(CondAddr19),
		.uncondbr(BrAddr26),
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
		.DataMemRead,
		.MemToReg
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
		.WriteData(WriteData),
		.ReadRegister1(Rn),
		.ReadRegister2(RegChoose),
		.WriteRegister(Rd),
		.RegWrite(RegWrite),
		.clk(clk)
	);
	
	sign_extend #(9, 64) extDaddr(
		.in(Daddr9),
		.out(Daddr64)
	);
	
	sign_extend #(12, 64) extImm12(
		.in(Imm12),
		.out(Imm64)
	);
	
	Big64mux2_1 ChooseConstant(
		.out(constArg),
		.in0(Daddr64),
		.in1(Imm12),
		.sel(ImmInstr)
	);
	
	Big64mux2_1 ChooseConstantOrDb(
		.out(addArg),
		.in0(Db),
		.in1(addArg),
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
	

	Reg_Create #4 FlagRegister(
		.q(flags),
		.in({negative, zero, overflow, carry_out}),
		.en(CmpMode),
		.reset(reset),
		.clk(clk)
	);



endmodule

module cpu_testbench();


endmodule

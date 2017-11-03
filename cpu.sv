module cpu(reset, clk);
	input logic reset, clk;
	logic [31:0] instruction;
	logic [63:0] instr_addr;

	// Controls
	logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc, ALUOp, MemWrite,
		CmpMode;

	// instr. args
	logic [8:0] Daddr9;
	logic [11:0] Imm12;
	logic [15:0] Imm16;
	logic [6:0] shamt;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;

	// Addr's
	logic [4:0] Rd, Rm, Rn, RegChoose;

	// Data
	logic [63:0] Da, Db;
	logic [3:0] flags;
	logic negative, zero, overflow, carry_out;

	program_counter(
		.program_index(instr_addr),
		.cond_addr(instruction[23:5]),
		.br_addr(CondAddr19),
		.uncondbr(BrAddr26),
		.br_taken(BrTaken),
		.reset(reset),
		.clk(clk)
	);

	instructmem(
		.address(instr_addr),
		.instruction(instruction),
		.clk(clk)
	);

	instr_decoder(
		.instruction,
		.ZeroFlag(),
		.flags,
		.UncondBr,
		.BrTaken,
		.Reg2Loc,
		.RegWrite,
		.ALUSrc,
		.ALUOp,
		.CmpMode,
		.MemWrite,
		.DAddr9,
		.Imm12,
		.shamt,
		.Imm16,
		.CondAddr19,
		.BrAddr26
	);

	// Proceccinfg block
	n_mux2_1 #5 ChooseWhatInput(
		.out(RegChoose),
		.in0(Rd),
		.in1(Rm),
		.sel(Reg2Loc)
	);

	regfile(
		.ReadData1(Da),
		.ReadData2(Db),
		.WriteData(),
		.ReadRegister1(Rn),
		.ReadRegister2(RegChoose),
		.WriteRegister(RegWrite),
		.RegWrite,
		.clk(clk)
	);

	alu mainALU(
		.A(),
		.B(),
		.cntrl(ALUOp),
		.result(),
		.negative,
		.zero,
		.overflow,
		.carry_out
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

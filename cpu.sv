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
	logic [4:0] mem_Rd;

	// Data
	logic [63:0] Da, Db;
	logic [3:0] flags;
	logic negative, isZero, zero, overflow, carry_out;
	logic [63:0] ALUResult, addArg, constArg, fullOrByte, WrD;

	// Choose memData controls
	logic [3:0] size;
	logic [63:0] ReadDataMem;

	// Final Data being written
	logic [63:0] WriteData;

	// mov
	logic [63:0] inserted;
	logic [63:0] exe_out, mem_exe_out;
	// Old PC
	logic [63:0] registerPC;

	// WriteBack Data Vals
	logic regWriteFuck;
	logic [63:0] WBData;
	logic [4:0] wb_Rd;

	// forwarding crap
	logic fwd_en;
	logic [4:0] fwd_exe_id;
	logic [4:0] fwd_mem_id;
	logic [63:0] rm_catch;
	logic [63:0] rn_catch;
	logic rm_valid;
	logic rn_valid;
	logic [4:0] execute_Rd;
	logic [63:0] fwd_Da, fwd_Db;


// INSTRUCTION FETCH
////////////////////////////////////////////////////////////////
	program_counter PC(
		.program_index(instr_addr),
		.baby_maker_br(registerPC),
		.cond_addr(CondAddr19),
		.br_addr(BrAddr26),
		.uncondbr(UncondBr),
		.br_taken(BrTaken),
		.reset(reset),
		.clk(clk)
	);  // TODO: decouple the internal PC adders and pipe instr_addr

	instructmem memory(
		.address(instr_addr),
		.instruction(instruction),
		.clk(clk)
	);

	logic [31:0] currentInstruction;
	register_BABY_Maker #96 instruct_pipe(
		.q({currentInstruction, registerPC}),
		.in({instruction, instr_addr}),
		.clk(clk),
		.reset(reset)
	);

// REG/DEC
////////////////////////////////////////////////////////////////
	instr_decoder controls(
		.instruction(currentInstruction),
		.ZeroFlag(isZero),
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
		.mov,
		.fwd_en
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
		.WriteData(WBData),
		.ReadRegister1(Rn),
		.ReadRegister2(RegChoose),
		.WriteRegister(wb_Rd),
		.RegWrite(regWriteFuck),
		.reset(reset),
		.clk(~clk)
	);

	// Accelerated Branch
	zeroFlagCheck accel(
		.zeroFlagCheck(isZero),
		.result(addArg)
	);

	sign_extend #(9, 64) extDaddr(
		.in(DAddr9),
		.out(Daddr64)
	);

	sign_extend_unsigned #(12, 64) extImm12(
		.in(Imm12),
		.out(Imm64)
	);

	// Choose ALU input B ->
	Big64mux2_1 ChooseConstant(
		.out(constArg),
		.in0(Daddr64),
		.in1(Imm64),
		.sel(ImmInstr)
	);

	Big64mux2_1 ChooseConstantOrDb(
		.out(addArg),
		.in0(fwd_Db),
		.in1(constArg),
		.sel(ALUSrc)
	);  // -> ALU input B

	// Forwarding //
	n_mux2_1 #5 fwd_exe_enable(
		.out(fwd_exe_id),
		.in0(5'b11111),
		.in1(execute_Rd),
		.sel(execute_fwd_en)
	);

	n_mux2_1 #5 fwd_mem_enable(
		.out(fwd_mem_id),
		.in0(5'b11111),
		.in1(mem_Rd),
		.sel(mem_fwd_en)
	);

	fowarding BigBitch(
		.alu_rd_key(fwd_exe_id),
		.alu_result(exe_out),
		.mem_rd_key(fwd_mem_id),
		.mem_result(mem_exe_out),
		.reg_rm_lookup(RegChoose),
		.reg_rn_lookup(Rn),
	  .rm_fetch(rm_catch),
		.rn_fetch(rn_catch),
		.rm_valid(rm_valid),
		.rn_valid(rn_valid)
	);

	Big64mux2_1 muxymux(
		.out(fwd_Db),
		.in0(Db),
		.in1(rm_catch),
		.sel(rm_valid)
	);

	Big64mux2_1 muxymux3(
		.out(fwd_Da),
		.in0(Da),
		.in1(rn_catch),
		.sel(rn_valid)
	);

	// PIPE //
	logic
		execute_MemWrite,
		execute_MemToReg,
		execute_RegWrite,
		execute_CmpMode,
		execute_clear,
		execute_mov,
		execute_ByteOrFull,
		execute_ByteorFullData,
		execute_DataMemRead;
	logic [1:0] execute_shamt;
	logic [2:0] execute_ALUOp;
	logic [15:0] execute_Imm16;
	logic [63:0]
		execute_Da,
		execute_Db,
		execute_addArg,
		execute_ReadDataMem;

	register_BABY_Maker #293 regdec_pipe(
		.q({
			execute_Da,
			execute_Db,
			execute_addArg,
			execute_Imm16,
			execute_ALUOp,
			execute_shamt,
			execute_MemWrite,
			execute_MemToReg,
			execute_RegWrite,
			execute_CmpMode,
			execute_clear,
			execute_mov,
			execute_ByteOrFull,
			execute_ByteorFullData,
			execute_ReadDataMem,
			execute_Rd,
			execute_fwd_en,
			execute_DataMemRead
		}),
		.in({
			fwd_Da,
			fwd_Db,
			addArg,
			Imm16,
			ALUOp,
			shamt,
			MemWrite,
			MemToReg,
			RegWrite,
			CmpMode,
			clear,
			mov,
			ByteOrFull,
			ByteorFullData,
			ReadDataMem,
			Rd,
			fwd_en,
			DataMemRead
		}),
		.clk(clk),
		.reset(reset)
	);   // -->

	// TODO execute_ALUSrc might be wanted

// EXECUTE
///////////////////////////////////////////////////////////////////

	// MOV toolchain
	transposer mov1(
		.data(execute_Db),
		.fixed(execute_Imm16),
		.shamt(execute_shamt),
		.clear(execute_clear),
		.out(inserted)
	);

	alu mainALU(
		.A(execute_Da),
		.B(execute_addArg),
		.cntrl(execute_ALUOp),
		.result(ALUResult),
		.negative,
		.zero,
		.overflow,
		.carry_out
	);

	Big64mux2_1 aluMux(
		.out(exe_out),
		.in0(ALUResult),
		.in1(inserted),
		.sel(execute_mov)
	);

	// TODO: integrate this with readahead
	Reg_Create #(4) FlagRegister(
		.q(flags),
		.in({negative, zero, overflow, carry_out}),
		.en(execute_CmpMode),
		.reset(reset),
		.clk(clk)
	);

	// TODO: Forwarding plugin here

	logic
		mem_MemWrite,
		mem_MemToReg,
		mem_RegWrite,
		mem_ByteOrFull,
		mem_ByteorFullData,
		mem_DataMemRead;
	logic [63:0] mem_ALUResult, mem_Db, mem_ReadDataMem;


	register_BABY_Maker #205 execute_pipe(
		.q({
			mem_exe_out,
			mem_MemWrite,
			mem_MemToReg,
			mem_RegWrite,
			mem_ByteOrFull,
			mem_ByteorFullData,
			mem_Db,
			mem_ReadDataMem,
			mem_Rd,
			mem_fwd_en,
			mem_DataMemRead
		}),
		.in({
			exe_out,
			execute_MemWrite,
			execute_MemToReg,
			execute_RegWrite,
			execute_ByteOrFull,
			execute_ByteorFullData,
			execute_Db,
			execute_ReadDataMem,
			execute_Rd,
			execute_fwd_en,
			execute_DataMemRead
		}),
		.clk(clk),
		.reset(reset)
	);

// MEM
///////////////////////////////////////////////////////////////////
	// Decides transfer amount
	n_mux2_1 #4 TransferAmt(
		.out(size),
		.in0(4'b1000),
		.in1(4'b0001),
		.sel(mem_ByteOrFull)
	);

	datamem dataMemory(
	.address(mem_exe_out),
	.write_enable(mem_MemWrite),
	.read_enable(mem_DataMemRead),
	.write_data(mem_Db),
	.clk(clk),
	.xfer_size(size),
	.read_data(ReadDataMem)
	);

	Big64mux2_1 RegWriteDataMux(
		.out(WriteData),
		.in0(mem_exe_out),
		.in1(ReadDataMem),
		.sel(mem_MemToReg)
	);

	Big64mux2_1 LoadFullDataOrByte (
		.out(WrD),
		.in0(WriteData),
		.in1({56'b00000000000000000000000000000000000000000000000000000000, WriteData[7:0]}),
		.sel(mem_ByteorFullData)
	);
	register_BABY_Maker #70 write_back_pipe(
		.q({WBData, regWriteFuck, wb_Rd}),
		.in({WrD, mem_RegWrite, mem_Rd}),
		.clk(clk),
		.reset(reset)
	);
endmodule

module cpu_testbench();

	parameter ClockDelay = 10000;
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
		for (i = 0; i < 50; i++) begin
			@(posedge clk);
		end
		$stop;
	end



endmodule

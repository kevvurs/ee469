module cpu(reset, clk);
	input logic reset, clk;
	logic [31:0] instruction;
	logic [63:0] instr_addr;
	
	// Controls
	logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc, ALUOp, MemWrite;
	logic [8:0] Daddr9;
	logic [11:0] Imm12;
	logic [15:0] Imm16;
	
	logic [4:0] Rd, Rm, Rn, RegChoose;
	
	//5:2_1
	mux2_1 #5 ChooseWhatInput (.out(RegChoose), .in0(Rd), .in1(Rm), .sel(Reg2Loc));  
	
	regfile(
		.ReadData1(Da), .ReadData2(Db), .WriteData(), 
		.ReadRegister1(Rn), .ReadRegister2(RegChoose), .WriteRegister(RegWrite),
		.RegWrite, .clk(clk)
	);
	
	program_counter(
		.program_index(instr_addr),
		.cond_addr(instruction[23:5]),
		.br_addr(instruction[25:0]),
		.uncondbr(UncondBr),
		.br_taken(BrTaken),
		.reset(reset),
		.clk(clk)
	);
	
	instructmem(
		.address(instr_addr),
		.instruction(instruction),
		.clk(clk)
	);
	
	// TODO: drive control and params in PC count in feedback from decoded INSTR.
	
	
endmodule

module cpu_testbench();


endmodule

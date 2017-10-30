module cpu(reset, clk);
	input logic reset, clk;
	logic [31:0] instruction;
	logic [63:0] instr_addr;
	
	// Controls
	logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc, ALUOp, MemWrite;
	
	program_counter(
		.program_index(instr_addr),
		.cond_addr(instruction[23:5]),
		.br_addr(instruction[25:0]),
		.uncondbr(UncondBr),
		.br_taken(BrTaken),
		.reset(reset),
		.clk(clk),
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

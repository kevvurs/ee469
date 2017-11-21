module instr_decoder(instruction,
	ZeroFlag, flags,
	UncondBr, BrTaken,
	Reg2Loc, RegWrite,
	ALUSrc, ALUOp, CmpMode,
	MemWrite, MemToReg,
	DAddr9, Imm12, shamt, Imm16,
	CondAddr19, BrAddr26,
	ImmInstr, ByteOrFull, ByteorFullData, DataMemRead,
	Rn, Rm, Rd,
	clear, mov, fwd_en
);

	input logic [31:0] instruction;

	// Controllers
	output logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc , MemWrite, MemToReg,
		CmpMode, ImmInstr, ByteOrFull, ByteorFullData, DataMemRead,
		clear, mov, fwd_en;
	output logic [2:0] ALUOp;

	// Reg addr
	output logic [4:0] Rn, Rm, Rd;

	// Instruction args
	output logic [8:0] DAddr9;
	output logic [11:0] Imm12;
	output logic [1:0] shamt;
	output logic [15:0] Imm16;
	output logic [18:0] CondAddr19;
	output logic [25:0] BrAddr26;

	// ALU flags
	input logic ZeroFlag;  		// Fast
	input logic [3:0] flags;  // Previous

	logic lessThan;

	parameter
		// B-type
		B = 6'b000101,

		// CB-type
		BCond = 8'b01010100,
		CBZ = 8'b10110100,

		LT = 5'b01011,

		// R-type
		ADDS = 11'b10101011000,
		SUBS = 11'b11101011000,

		// I-type
		ADDI = 10'b1001000100,

		// D-type
		STURB = 11'b00111000000,
		LDURB = 11'b00111000010,
		STUR = 11'b11111000000,
		LDUR = 11'b11111000010,

		// MOVK MOVZ
		MOVZ = 9'b110100101,
		MOVK = 9'b111100101;


		xor notEqual(lessThan, flags[3], flags[1]);


	always_comb begin
		// Commands here act as global defaults
		// Arguments that stay the same in instructions
		Rd = instruction[4:0];
		Rn = instruction[9:5];
		Rm = instruction[20:16];
		BrAddr26 = instruction[25:0];
		CondAddr19 = instruction[23:5];
		Imm12 = instruction[21:10];
		// TODO: shamt = instruction[15:10];
		Imm16 = instruction[20:5];
		DAddr9 = instruction[20:12];
		shamt = instruction[22:21];
		// Control variables that stay constant in most instructions
		CmpMode = 1'b0;
		ImmInstr = 1'b0;
		DataMemRead = 1'b0;
		MemToReg = 1'b0;
		clear = 1'b0;
		mov = 1'b0;
		// If store or load 1 byte then true, false when full load or store
		ByteOrFull = 1'b0;
		ByteorFullData = 1'b0;
		RegWrite = 1'b0;
		MemWrite = 1'b0;
		BrTaken = 1'b0;
		fwd_en = 1'b1;

		// Decoder block:
		// B-type
		case (instruction[31:26])
			B: begin
				UncondBr = 1'b1;
				BrTaken =  1'b1;
				Reg2Loc = 1'bx;
				RegWrite = 1'b0;
				ALUSrc = 1'bx;
				ALUOp = 3'bxxx;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				fwd_en = 1'b0;
			end
			default:
				// CB-type
				case (instruction[31:24])
					BCond:
						case (instruction[4:0])
							LT: begin
								UncondBr = 1'b0;
								BrTaken =  lessThan;
								Reg2Loc = 1'b0;
								RegWrite = 1'b0;
								ALUSrc = 1'b0;
								ALUOp = 3'b000;
								MemWrite = 1'b0;
								MemToReg = 1'b0;
								fwd_en = 1'b0;
							end

							// no-op
							default: begin
								UncondBr = 1'bx;
								BrTaken =  1'b0;
								Reg2Loc = 1'bx;
								RegWrite = 1'b0;
								ALUSrc = 1'bx;
								ALUOp = 3'bxxx;
								MemWrite = 1'b0;
								MemToReg = 1'bx;
								fwd_en = 1'b0;
							end
						endcase


					CBZ: begin
						UncondBr = 1'b0;
						BrTaken =  ZeroFlag;
						Reg2Loc = 1'b0;
						RegWrite = 1'b0;
						ALUSrc = 1'b0;
						ALUOp = 3'b000;
						MemWrite = 1'b0;
						MemToReg = 1'b0;
						fwd_en = 1'b0;
					end
				default:

					//R-type
					case(instruction[31:21])

						ADDS: begin
							UncondBr = 1'b0;
							BrTaken =  1'b0;
							Reg2Loc = 1'b1;
							RegWrite = 1'b1;
							ALUSrc = 1'b0;
							ALUOp = 3'b010;
							MemWrite = 1'b0;
							MemToReg = 1'b0;
							CmpMode = 1'b1;
						end

						SUBS: begin
							UncondBr = 1'b0;
							BrTaken =  1'b0;
							Reg2Loc = 1'b1;
							RegWrite = 1'b1;
							ALUSrc = 1'b0;
							ALUOp = 3'b011;
							MemWrite = 1'b0;
							MemToReg = 1'b0;
							CmpMode = 1'b1;
						end

						default:

							// D-type
							case (instruction[31:21])
								STURB: begin
									UncondBr = 1'b0;
									BrTaken =  1'b0;
									Reg2Loc = 1'b0;
									RegWrite = 1'b0;
									ALUSrc = 1'b1;
									ALUOp = 3'b010;
									MemWrite = 1'b1;
									MemToReg = 1'b1;
									ByteOrFull = 1'b1;
								end

								LDURB: begin
									UncondBr = 1'b0;
									BrTaken =  1'b0;
									Reg2Loc = 1'b1;
									RegWrite = 1'b1;
									ALUSrc = 1'b1;
									ALUOp = 3'b010;
									MemWrite = 1'b0;
									MemToReg = 1'b1;
									ByteOrFull = 1'b1;
									ByteorFullData = 1'b1;
									DataMemRead = 1'b1;

								end

								STUR: begin
									UncondBr = 1'b0;
									BrTaken =  1'b0;
									Reg2Loc = 1'b0;
									RegWrite = 1'b0;
									ALUSrc = 1'b1;
									ALUOp = 3'b010;
									MemWrite = 1'b1;
									MemToReg = 1'b1;
									ByteOrFull = 1'b0;
								end

								LDUR:begin
									UncondBr = 1'b0;
									BrTaken =  1'b0;
									Reg2Loc = 1'b0;
									RegWrite = 1'b1;
									ALUSrc = 1'b1;
									ALUOp = 3'b010;
									MemWrite = 1'b0;
									MemToReg = 1'b1;
									ByteOrFull = 1'b0;
									DataMemRead = 1'b1;
								end
							default:

							// I-type
							case (instruction[31:22])

								ADDI: begin
									UncondBr = 1'bx;
									BrTaken =  1'b0;
									Reg2Loc = 1'b0;
									RegWrite = 1'b1;
									ALUSrc = 1'b1;
									ALUOp = 3'b010;
									MemWrite = 1'b0;
									MemToReg = 1'b0;
									ImmInstr = 1'b1;
								end
							default: begin
								mov = 1'b1;
								// TODO: MOV
								case (instruction[31:23])
									MOVK: begin
										UncondBr = 1'b0;
										BrTaken =  1'b0;
										Reg2Loc = 1'b0;
										RegWrite = 1'b1;
										ALUSrc = 1'b0;
										ALUOp = 3'b000;
										MemWrite = 1'b0;
										MemToReg = 1'b0;
									end

									MOVZ: begin
										UncondBr = 1'b0;
										BrTaken =  1'b0;
										Reg2Loc = 1'b0;
										RegWrite = 1'b1;
										ALUSrc = 1'b0;
										ALUOp = 3'b000;
										MemWrite = 1'b0;
										MemToReg = 1'b0;
										clear = 1'b1;
									end

									// N00p
									default: begin
										Rd = instruction[4:0];
										Rn = instruction[9:5];
										Rm = instruction[20:16];
										BrAddr26 = instruction[25:0];
										CondAddr19 = instruction[23:5];
										Imm12 = instruction[21:10];
										Imm16 = instruction[20:5];
										DAddr9 = instruction[20:12];
										shamt = instruction[22:21];
										CmpMode = 1'b0;
										ImmInstr = 1'b0;
										DataMemRead = 1'b0;
										MemToReg = 1'b0;
										clear = 1'b0;
										mov = 1'b0;
										ByteOrFull = 1'b0;
										ByteorFullData = 1'b0;
										RegWrite = 1'b0;
										MemWrite = 1'b0;
										BrTaken = 1'b0;
										fwd_en = 1'b0;
									end
								endcase
							end
							endcase
					endcase
				endcase
		endcase
	endcase
end
endmodule

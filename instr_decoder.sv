module instr_decoder(instruction, ZeroFlag, flags, UncondBr, BrTaken, Reg2Loc, RegWrite, ALUSrc, ALUOp, MemWrite);
	input logic instruction;

	// Controllers
	output logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc , MemWrite, MemToReg,
		CmpMode;
	output logic [2:0] ALUOp;

	// Instruction args
	output logic [8:0] DAddr9;
	output logic [11:0] Imm12;
	output logic [6:0] shamt;
	output logic [15:0] Imm16;
	output logic [18:0] CondAddr19;
	output logic [25:0] BrAddr26;

	// ALU flags
	input logic ZeroFlag;  		// Fast
	input logic [3:0] flags;  // Previous


	parameter
		// B-type
		B = 6'b000101,

		// CB-type
		BCond = 8'b01010100,
		CBZ = 8'b10110100,
		//CBNZ = 8'b10110101,
		//EQ = 8'b00000000,
		//NE = 8'b00000001,
		//GE = 8'b00001010,
		LT = 5'b01011,
		//GT = 8'b00001100,
		//LE = 8'b00001101,

		// R-type
		ADDS = 11'b10101011000,
		SUBS = 11'b11101011000,
		//AND = 11'b10001010000,
		//ADD = 11'b10001011000,
		//SDIV = 11'b10011010110,
		//MUL = 11'b10011011000,
		//ORR = 11'b10101010000,
		//EOR = 11'b11001010000,
		//SUB = 11'b11001011000,
		//LSR = 11'b11010011010,
		//LSL = 11'b11010011011,
		//BR = 11'b11010110000,
		//ANDS = 11'b11101010000,
		//SUBS = 11'b11101011000,

		// I-type
		ADDI = 10'b1001000100,
		//ANDI = 10'b1001001000,
		//ORRI = 10'b0101101000,
		//SUBI = 10'b1101000100,
		//EORI = 10'b1101001000,
		//ANDIS = 10'b1011001000,

		// D-type
		STURB = 11'b00111000000,
		LDURB = 11'b00111000010,
		STUR = 11'b11111000000,
		LDUR = 11'b11111000010,

		// MOVK MOVZ
		MOVZ = 9'b110100101,
		MOVK = 9'b111100101,



	always_comb

		// Args
		BrAddr26[25:0]  = instruction[25:0];
		Imm12[11:0] = instruction[21:10];
		shamt[6:0] = instruction[15:10];
		Imm16[15:0] = instruction[21:10];
		DAddr9[8:0] = instruction[20:12];

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
			end

			default:

				// CB-type
				case (instruction[31:24])
					BCond:
						case (instruction[4:0])
							LT: begin
								UncondBr = 1'b0;
								BrTaken =  ZeroFlag;
								Reg2Loc = 1'b0;
								RegWrite = 1'b0;
								ALUSrc = 1'b0;
								ALUOp = 3'b000;
								MemWrite = 1'b0;
								MemToReg = 1'b0;
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
					end
				default:

					//R-type
					case(instruction[31:21])

						ADDS: begin
							UncondBr = 1'b0;
							BrTaken =  1'b0;
							Reg2Loc = 1'b1;
							RegWrite = 1'b0;
							ALUSrc = 1'b0;
							ALUOp = 3'b010;
							MemWrite = 1'b0;
							MemToReg = 1'b0;
						end

						SUBS: begin
							UncondBr = 1'b0;
							BrTaken =  1'b0;
							Reg2Loc = 1'b1;
							RegWrite = 1'b0;
							ALUSrc = 1'b0;
							ALUOp = 3'b011;
							MemWrite = 1'b0;
							MemToReg = 1'b0;
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
									MemWrite = 1'b1
									MemToReg = 1'b0;
								end

								LDURB: begin
									UncondBr = 1'b0;
									BrTaken =  1'b0;
									Reg2Loc = 1'b0;
									RegWrite = 1'b0;
									ALUSrc = 1'b1;
									ALUOp = 3'b010;
									MemWrite = 1'b1
									MemToReg = 1'b0;
								end

								STUR: begin
									UncondBr = 1'b0;
									BrTaken =  1'b0;
									Reg2Loc = 1'b0;
									RegWrite = 1'b0;
									ALUSrc = 1'b1;
									ALUOp = 3'b010;
									MemWrite = 1'b1
									MemToReg = 1'b0;
								end

								LDUR:begin
									UncondBr = 1'b0;
									BrTaken =  1'b0;
									Reg2Loc = 1'b0;
									RegWrite = 1'b0;
									ALUSrc = 1'b1;
									ALUOp = 3'b010;
									MemWrite = 1'b1
									MemToReg = 1'b0;
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
								end
							default:

								// TODO: MOV
								case (instruction[31:23])
									MOVK: begin
										UncondBr = 1'bx;
										BrTaken =  1'bx;
										Reg2Loc = 1'bx;
										RegWrite = 1'bx;
										ALUSrc = 1'bx;
										ALUOp = 3'bxxx;
										MemWrite = 1'bx;
										MemToReg = 1'bx;
									end

									MOVZ: begin
										UncondBr = 1'bx;
										BrTaken =  1'bx;
										Reg2Loc = 1'bx;
										RegWrite = 1'bx;
										ALUSrc = 1'bx;
										ALUOp = 3'bxxx;
										MemWrite = 1'bx;
										MemToReg = 1'bx;
									end

									// WC no-op
									default: begin
										UncondBr = 1'bx;
										BrTaken =  1'b0;
										Reg2Loc = 1'bx;
										RegWrite = 1'b0;
										ALUSrc = 1'bx;
										ALUOp = 3'bxxx;
										MemWrite = 1'b0;
										MemToReg = 1'bx;
									end
								endcase
							endcase
					endcase
				endcase
		endcase
endmodule

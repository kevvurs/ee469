module instr_decoder(instruction, ZeroFlag, UncondBr, BrTaken, Reg2Loc, RegWrite, ALUSrc, ALUOp, MemWrite);
	input logic instruction;
	input logic ZeroFlag;
	output logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc , MemWrite, MemToReg;
	output logic [2:0] ALUOp;
	output logic [8:0] DAddr9;
	output logic [11:0] Imm12;
	output logic [6:0] shamt;
	output logic [15:0] Imm16;
	output logic [18:0] CondAddr19;
	output logic [25:0] BrAddr26;

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
		//LT = 8'b00001011,
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
		// B-type
		case (instruction[31:26])
			B: begin
				UncondBr = 1;
				BrTaken =  1;
				Reg2Loc = 1'bx;
				RegWrite = 0;
				ALUSrc = 1'bx;
				ALUOp = 3'b000;
				MemWrite = 0
				MemToReg = 1'bx;
				DAddr9[8:0] = 9'b000000000;
				Imm12[11:0] = 12'b000000000000;
				shamt = 6'b000000;
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];
			end
			default:
			
				// CB-type
				case (instruction[31:24])
				BCond: begin
				UncondBr = 0;
				BrTaken =  ZeroFlag;
				Reg2Loc = 0;
				RegWrite = 0;
				ALUSrc = 0;
				ALUOp = 3'b000;
				MemWrite = 0
				MemToReg = 0;
				DAddr9[8:0] = 9'b000000000;
				Imm12[11:0] = 12'b000000000000;
				shamt = 6'b00000;
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];		
				end
				
				CBZ: begin
				UncondBr = 0;
				BrTaken =  ZeroFlag;
				Reg2Loc = 0;
				RegWrite = 0;
				ALUSrc = 0;
				ALUOp = 3'b000;
				MemWrite = 0
				MemToReg = 0;
				DAddr9[8:0] = 9'b000000000;
				Imm12[11:0] = 12'b000000000000;
				shamt = 6'b00000;
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];		
				end
					default:
						//R-type
				case(instruction[31:21]) 
				
				ADDI: begin
				UncondBr = 0;
				BrTaken =  0;
				Reg2Loc = 1;
				RegWrite = 1;
				ALUSrc = 0;
				ALUOp = 3'b010;
				MemWrite = 0
				MemToReg = 0;
				DAddr9[8:0] = 9'b000000000;
				Imm12[11:0] = 12'b000000000000;
				shamt = instruction[15:10];
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];	
				end
				
				SUBS: begin
				UncondBr = 0;
				BrTaken =  0;
				Reg2Loc = 1;
				RegWrite = 1;
				ALUSrc = 0;
				ALUOp = 3'b011;
				MemWrite = 0
				MemToReg = 0;
				DAddr9[8:0] = 9'b000000000;
				Imm12[11:0] = 12'b000000000000;
				shamt = instruction[15:10];
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];
				end
				default
				
				STURB: begin
				UncondBr = 0;
				BrTaken =  0;
				Reg2Loc = 0;
				RegWrite = 0;
				ALUSrc = 1;
				ALUOp = 3'b010;
				MemWrite = 1
				MemToReg = 0;
				DAddr9[8:0] = instruction[20:12];
				Imm12[11:0] = 12'b000000000000;
				shamt = 6'b000000;
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];
				end
				
				LDURB: begin
				UncondBr = 0;
				BrTaken =  0;
				Reg2Loc = 0;
				RegWrite = 0;
				ALUSrc = 1;
				ALUOp = 3'b010;
				MemWrite = 1
				MemToReg = 0;
				DAddr9[8:0] = instruction[20:12];
				Imm12[11:0] = 12'b000000000000;
				shamt = 6'b000000;
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];
				end
				
				STUR: begin
				UncondBr = 0;
				BrTaken =  0;
				Reg2Loc = 0;
				RegWrite = 0;
				ALUSrc = 1;
				ALUOp = 3'b010;
				MemWrite = 1
				MemToReg = 0;
				DAddr9[8:0] = instruction[20:12];
				Imm12[11:0] = 12'b000000000000;
				shamt = 6'b000000;
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];
				end
				
				LDUR:begin
				UncondBr = 0;
				BrTaken =  0;
				Reg2Loc = 0;
				RegWrite = 0;
				ALUSrc = 1;
				ALUOp = 3'b010;
				MemWrite = 1
				MemToReg = 0;
				DAddr9[8:0] = instruction[20:12];
				Imm12[11:0] = 12'b000000000000;
				shamt = 6'b000000;
				Imm16[15:0] = 16'b0000000000;
				CondAddr19[18:0] = 19'b000000000000000000;
				BrAddr26[25:0]  = instruction[25:0];
				end
				default:

				endcase
		endcase
endmodule

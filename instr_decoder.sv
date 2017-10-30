module instr_decoder(instruction, UncondBr, BrTaken, Reg2Loc, RegWrite, ALUSrc, ALUOp, MemWrite);
	input logic instruction;
	output logic UncondBr, BrTaken, Reg2Loc,
		RegWrite, ALUSrc, ALUOp, MemWrite;
	
	parameter
		// B-type
		B = 6'b000101,
		
		// CB-type
		BCond = 8'b01010100,
		CBZ = 8'b10110100,
		CBNZ = 8'b10110101,
		EQ = 8'b00000000,
		NE = 8'b00000001,
		GE = 8'b00001010,
		LT = 8'b00001011,
		GT = 8'b00001100,
		LE = 8'b00001101,
		
		// R-type
		AND = 11'b10001010000,
		ADD = 11'b10001011000,
		SDIV = 11'b10011010110,
		MUL = 11'b10011011000,
		ORR = 11'b10101010000,
		ADDS = 11'b10101011000,
		EOR = 11'b11001010000,
		SUB = 11'b11001011000,
		LSR = 11'b11010011010,
		LSL = 11'b11010011011,
		BR = 11'b11010110000,
		ANDS = 11'b11101010000,
		SUBS = 11'b11101011000,
		
		// I-type
		ADDI = 10'b1001000100,
		
		// D-type
		STRUB = 11'b00111000000;
		
		
		
		
	
	always_comb
		// B-type
		case (instruction[31:26])
			B: begin
				// Set controls
			end
			default:
				// CB-type
				case (instruction[31:24])
					BCond: begin
						// Set controls
					end
					default:
						//R-type
						
				endcase
		endcase
endmodule

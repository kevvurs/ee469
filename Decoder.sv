`timescale 1ns/10ps

// 5:32 Decoder implementation with enable
module Decoder (writeReg, RegWrite, regSelect);
	input [4:0] writeReg;
	input RegWrite;
	output [31:0] regSelect;
	parameter delay = 5;

	logic case1, case2, case3, case4, case5, case6, case7, case8;

	and #delay (case1, ~writeReg[4], ~writeReg[3], ~writeReg[2]);
	and #delay (case2, ~writeReg[4], ~writeReg[3], writeReg[2]);
	and #delay (case3, ~writeReg[4], writeReg[3], ~writeReg[2]);
	and #delay (case4, ~writeReg[4], writeReg[3], writeReg[2]);
	and #delay (case5, writeReg[4], ~writeReg[3], ~writeReg[2]);
	and #delay (case6, writeReg[4], ~writeReg[3], writeReg[2]);
	and #delay (case7, writeReg[4], writeReg[3], ~writeReg[2]);
	and #delay (case8, writeReg[4], writeReg[3], writeReg[2]);


	assign regSelect[31] = 0;

	and #delay (regSelect[0], RegWrite, case1, ~writeReg[1], ~writeReg[0]);
	and #delay (regSelect[1], RegWrite, case1, ~writeReg[1], writeReg[0]);
	and #delay (regSelect[2], RegWrite, case1, writeReg[1], ~writeReg[0]);
	and #delay (regSelect[3], RegWrite, case1, writeReg[1], writeReg[0]);

	and #delay (regSelect[4], RegWrite, case2, ~writeReg[1], ~writeReg[0]);
	and #delay (regSelect[5], RegWrite, case2, ~writeReg[1], writeReg[0]);
	and #delay (regSelect[6], RegWrite, case2, writeReg[1], ~writeReg[0]);
	and #delay (regSelect[7], RegWrite, case2, writeReg[1], writeReg[0]);

	and #delay (regSelect[8], RegWrite, case3, ~writeReg[1], ~writeReg[0]);
	and #delay (regSelect[9], RegWrite, case3, ~writeReg[1], writeReg[0]);
	and #delay (regSelect[10], RegWrite, case3, writeReg[1], ~writeReg[0]);
	and #delay (regSelect[11], RegWrite, case3, writeReg[1], writeReg[0]);

	and #delay (regSelect[12], RegWrite, case4, ~writeReg[1], ~writeReg[0]);
	and #delay (regSelect[13], RegWrite, case4, ~writeReg[1], writeReg[0]);
	and #delay (regSelect[14], RegWrite, case4, writeReg[1], ~writeReg[0]);
	and #delay (regSelect[15], RegWrite, case4, writeReg[1], writeReg[0]);

	and #delay (regSelect[16], RegWrite, case5, ~writeReg[1], ~writeReg[0]);
	and #delay (regSelect[17], RegWrite, case5, ~writeReg[1], writeReg[0]);
	and #delay (regSelect[18], RegWrite, case5, writeReg[1], ~writeReg[0]);
	and #delay (regSelect[19], RegWrite, case5, writeReg[1], writeReg[0]);

	and #delay (regSelect[20], RegWrite, case6, ~writeReg[1], ~writeReg[0]);
	and #delay (regSelect[21], RegWrite, case6, ~writeReg[1], writeReg[0]);
	and #delay (regSelect[22], RegWrite, case6, writeReg[1], ~writeReg[0]);
	and #delay (regSelect[23], RegWrite, case6, writeReg[1], writeReg[0]);

	and #delay (regSelect[24], RegWrite, case7, ~writeReg[1], ~writeReg[0]);
	and #delay (regSelect[25], RegWrite, case7, ~writeReg[1], writeReg[0]);
	and #delay (regSelect[26], RegWrite, case7, writeReg[1], ~writeReg[0]);
	and #delay (regSelect[27], RegWrite, case7, writeReg[1], writeReg[0]);

	and #delay (regSelect[28], RegWrite, case8, ~writeReg[1], ~writeReg[0]);
	and #delay (regSelect[29], RegWrite, case8, ~writeReg[1], writeReg[0]);
	and #delay (regSelect[30], RegWrite, case8, writeReg[1], ~writeReg[0]);


endmodule

module Decoder_testbench();
	logic [4:0] writeReg;
	logic RegWrite;
	logic [31:0] regSelect;
	parameter delay = 10

	Decoder dut (.writeReg, .RegWrite, .regSelect);

 initial begin
	writeReg = 5'b0000; RegWrite = 1; #delay;
	writeReg = 5'b0010;               #delay;
	writeReg = 5'b1010; RegWrite = 0; #delay;
	                    RegWrite = 1; #delay;
																		#delay;

 end
endmodule

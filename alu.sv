`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic	[63:0] A, B;
	input logic	[2:0]	cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out ;
	
	// Internal signals
	logic [63:0] add_sum;
	logic [63:0] add_cout;
	logic [63:0] difference;
	logic [63:0] sub_cout;
	
	logic [63:0] sub_sum;
	
	logic [63:0] and_out;
	logic [63:0] _or_out;
	logic [63:0] xor_out;
	
	logic OverFlow1, OverFlow2;
	
	parameter delay = 5;
	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;

	// Deploy parameter to each OP.
	Big64full_adder add (.a(A), .b(B), .cout(add_cout), .sum(add_sum));
	Big64full_subtractor sub (.a(A), .b(B), .cout(sub_cout), .difference(difference));
	
	bw_and _and (.a(A), .b(B), .c(and_out));
	bw_or  _or  (.a(A), .b(B), .c(_or_out));
	bw_xor _xor (.a(A), .b(B), .c(xor_out));
	
	// Resolve output
	Big64mux8_1 resolver (.out(result),
		.in0(B),  			// 000
		.in1(64'bX),		// 001
		.in2(add_sum),		// 010
		.in3(difference),	// 011
		.in4(and_out),		// 100
		.in5(_or_out), 	// 101
		.in6(xor_out),
		.in7(64'bX),
		.sel(cntrl));
	
	// Drive flags
	//and #delay overflowFlag (overflow, add_cout[62], add_cout[63]);
	// Zero Flag Check
	zeroFlagCheck CheckIfXero(.zeroFlagCheck(zero), .result(result));
	// Negative Flag Check
	assign negative = result[63];
	// Overflow Flag Check
	xor #delay additionOverFlow (OverFlow1, add_cout[63], add_cout[62]);
	xor #delay subtractionOverFlow (OverFlow2, sub_cout[63], sub_cout[62]);
	or #delay (overflow, OverFlow1, OverFlow2);
	// Carry Flag Check
	or #delay (carry_out, add_cout[63], sub_cout[63]);


endmodule

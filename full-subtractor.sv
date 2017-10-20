`timescale 1ns/10ps

module full_subtractor(cin, a, b, cout, difference);
	output logic cout, difference;
	input logic cin, a, b;
	parameter delay = 5;

	logic differenceNoCarry, cinCheck, inputCarryCheck, inverta, invertedDifferenceNoCarry;
	not #delay (inverta, a);
	and #delay inputCheck (inputCarryCheck, inverta, b);
	xor #delay addAB (differenceNoCarry, a, b);
	not #delay invertanswer (invertedDifferenceNoCarry, differenceNoCarry);
	and #delay cinCheckGate (cinCheck, cin, invertedDifferenceNoCarry);
	xor #delay result (difference, cin, differenceNoCarry);
	or  #delay (cout, cinCheck, inputCarryCheck);
	
endmodule

module full_subtractor_testbench();
	logic cout, difference;
	logic cin, a, b;

	full_subtractor dut (cin, a, b, cout, difference);
	integer i;

 initial begin
	
	for (i=0; i<8; i++) begin
		{cin, a, b} = i; #15;
	end
 end
endmodule

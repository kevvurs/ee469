`timescale 1ns/10ps

module full_adder(cin, a, b, cout, sum);
	output logic cout, sum;
	input logic cin, a, b;
	parameter delay = 5;

	logic sumNoCarry, cinCheck, inputCarryCheck;
	
	and #delay inputCheck (inputCarryCheck, a, b);
	and #delay cinCheckGate (cinCheck, cin, sumNoCarry);
	xor #delay addAB (sumNoCarry, a, b);
	xor #delay result (sum, cin, sumNoCarry);
	or #delay (cout, cinCheck, inputCarryCheck);
	
	
endmodule

module full_adder_testbench();
	logic cout, sum;
	logic cin, a, b;

	full_adder dut (cin, a, b, cout, sum);
	integer i;

 initial begin
	
	for (i=0; i<8; i++) begin
		{cin, a, b} = i; #10;
	end
 end
endmodule

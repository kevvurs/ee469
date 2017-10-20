`timescale 1ns/10ps

module Big64full_subtractor(a, b, cout, difference);
	input logic [63:0] a, b;
	output logic [63:0] cout, difference;
	parameter delay = 0;
	
	full_subtractor halfSubtractor(.a(a[0]), .b(b[0]), .cin(1'b0), .difference(difference[0]), .cout(cout[0]));
	
	genvar i;
	generate
		for (i=1; i<64; i++) begin : each
			full_subtractor fullsubtractor(.a(a[i]), .b(b[i]), .cin(cout[i - 1]), .cout(cout[i]), .difference(difference[i]));
		end
	endgenerate
endmodule

module Big64full_subtractor_testbench();
	logic [63:0] cout, difference;
	logic [63:0] cin, a, b;
	parameter delay = 1500; // wait for gate delays
	
	Big64full_subtractor dut (.a, .b, .cout, .difference);
	integer j, k;

	 initial begin
		a = 64'h0000000000000001;
		b = 64'h0000000000000001;
		#delay;
		
		a = 64'h000000000000CAFE;
		b = 64'h000000000000BABE;
		#delay;
		
		a = 64'h0000000000000004;
		b = 64'h0000000000000003;
		#delay;
		// assert (difference == 64'd27421);
		
		a = 64'h0000000000000007;
		b = 64'h000000000000000A;
		#delay;
		// assert (difference == 64'd27421);
		
		a = 64'h0000000000008820;
		b = 64'h0000000000001d03;
		#delay;
		// assert (difference == 64'd27421);
		
		a = 64'h00000000032EE236;
		b = 64'hFFFFFFFFFEB2357C;
		#delay;
		// assert (difference == 64'd98637746);
		
		
	 end
endmodule

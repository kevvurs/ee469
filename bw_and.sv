`timescale 1ns/10ps

module bw_and(a, b, c);
	input logic [63:0] a, b;
	output logic [63:0] c;
	parameter delay = 5;
	
	genvar i;
	generate
		for (i=0; i<64; i++) begin : each
			and #delay iAnd (c[i], a[i], b[i]);
		end
	endgenerate
endmodule

module bw_and_testbench();
	logic [63:0] a, b, c;
	parameter delay = 50;
	
	bw_and dut (.a, .b, .c);
	
	initial begin
		a = 64'hC0FFEE3949039248;
		b = 64'h4238Fe2039C348DE;
		#delay;
		
		a = 64'h0101010101010101;
		b = 64'h1010101010101010;
		#delay;
		assert(c == 0);
	end
endmodule

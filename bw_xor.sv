`timescale 1ns/10ps

module bw_xor(a, b, c);
	input logic [63:0] a, b;
	output logic [63:0] c;
	parameter delay = 5;
	
	genvar i;
	generate
		for (i=0; i<64; i++) begin : each
			xor #delay iXor (c[i], a[i], b[i]);
		end
	endgenerate
endmodule

module bw_xor_testbench();
	logic [63:0] a, b, c;
	parameter delay = 50;
	
	bw_xor dut (.a, .b, .c);
	
	initial begin
		a = 64'hC0FFEE3949039248;
		b = 64'h4238Fe2039C348DE;
		#delay;
		
		a = 64'hC3C3C3C3C3C3C3C3;
		b = 64'h3C3C3C3C3C3C3C3C;
		#delay;
		assert(c == 64'hFFFFFFFFFFFFFFFF);
	end
endmodule

`timescale 1ns/10ps

module bw_inv(a, c);
	input logic [63:0] a;
	output logic [63:0] c;
	parameter delay = 5;
	
	genvar i;
	generate
		for (i=0; i<64; i++) begin : each
			inv #delay iInv (.in(a[i]), .out(c[i]));
		end
	endgenerate
endmodule

module bw_inv_testbench();
	logic [63:0] a, c;
	parameter delay = 50;
	
	bw_inv dut (.a, .c);
	
	initial begin
		a = 64'hC0FFEE3949039248;
		#delay;
		
		a = 64'hFFFFFFFFFFFFFFFF;
		#delay;
		assert(c == 0);
	end
endmodule

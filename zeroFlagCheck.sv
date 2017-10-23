`timescale 1ns/10ps

module zeroFlagCheck(zeroFlagCheck, result);
	input logic [63:0] result;
	output logic zeroFlagCheck;
	logic [7:0] out;
	logic [1:0] out2;
	parameter delay = 5;
	
	genvar i;
	generate
		for (i=0; i< 8; i++) begin : each
			or #delay ior (out[i], result[i * 4], result[(i * 4) + 1], result[(i * 4) + 2], result[(i * 4) + 3]);
		end
	endgenerate
	
	or #delay FUCC (out2[0], out[0], out[1], out[2], out[3]);
	or #delay FUCC2 (out2[1], out[4], out[5], out[6], out[7]);
	nor #delay FinalFUCC (zeroFlagCheck, out2[0], out2[1]);

endmodule

module zeroFlagCheck_testbench();
	logic [63:0] result;
	logic zeroFlagCheck;
	parameter delay = 150;
	
	zeroFlagCheck dut(zeroFlagCheck, result);	
	
	initial begin
		result = 64'hC0FFEE3949039248;
		#delay;
		result = 64'h4238Fe2039C348DE;
		#delay;
		result = 64'hC3C3C3C3C3C3C3C3;
		#delay;
		result = 64'h3C3C3C3C3C3C3C3C;
		#delay;
		result = 64'b1111111111111111111111111111111111111111111111111111111111111111;
		#delay;
	end
endmodule
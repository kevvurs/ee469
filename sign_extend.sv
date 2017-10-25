`timescale 1ns/10ps

module sign_extend #(parameter INNER_WIDTH=1, OUTER_WIDTH=2) (in, out);
	input logic [INNER_WIDTH-1:0] in;
	output logic [OUTER_WIDTH-1:0] out;

	initial assert (INNER_WIDTH < OUTER_WIDTH);
	
	integer i;
	always_comb begin
		out[INNER_WIDTH-1:0] = in;
		for (i=INNER_WIDTH; i<(OUTER_WIDTH); i+=1) begin
			out[i] = in[INNER_WIDTH - 1];
		end
	end
endmodule

module sign_extend_testbench();
	parameter
		w1 = 8,
		w2 = 32,
		delay = 10;
	logic [w1-1:0] in;
	logic [w2-1:0] out;
	
	sign_extend #(w1, w2) dut (.in, .out);
	
	initial begin
		in = 8'hFA;
		#delay;
		
		in = 8'h42;
		#delay;
	end
endmodule

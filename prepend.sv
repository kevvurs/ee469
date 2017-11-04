`timescale 1ns/10ps

module prepend #(parameter INNER_WIDTH=1, OUTER_WIDTH=2) (in, out);
	input logic [INNER_WIDTH-1:0] in;
	output logic [OUTER_WIDTH-1:0] out;

	initial assert (INNER_WIDTH < OUTER_WIDTH);

	integer i;
	always_comb begin
		out[INNER_WIDTH-1:0] = in;
		for (i=INNER_WIDTH; i<(OUTER_WIDTH); i+=1) begin
			out[i] = 1'b0;
		end
	end
endmodule

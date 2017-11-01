`timescale 1ns/10ps

module n_mux2_1 parameter #(parameter MUXSIZE = 2) (out, in0, in1, sel);
	input logic sel;
	input logic [MUXSIZE - 1:0] in0, in1;
	output logic [MUXSIZE - 1:0] out;
	
	genvar i;
	generate
		for (i=0; i<MUXSIZE; i+=1) begin : each
			mux2_1 iMux (.out(out[i]), .in0(in0[i]), .in1(in1[i]), .sel(sel));
		end
	endgenerate

endmodule
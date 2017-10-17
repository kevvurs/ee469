`timescale 1ns/10ps

module Big64mux2_1 (out, in0, in1, sel);
	input logic sel;
	input logic [63:0] in0, in1;
	output logic [63:0] out;
	
	genvar i;
	generate
		for (i=0; i<64; i+=1) begin : each
			mux2_1 iMux (.out(out[i]), .in0(in0[i]), .in1(in1[i]), .sel(sel));
		end
	endgenerate

endmodule

module Big64mux2_1_testbench();
	logic sel;
	logic [63:0] in0, in1;
	logic [63:0] out;
	parameter delay = 50; // wait for gate delays
	
	Big64mux2_1 dut (.out(out), .in0(in0), .in1(in1), .sel(sel));
	
	initial begin
		in0 = 64'h000C000A000F000E;
		in1 = 64'h000B000A000B000E;
		sel = 1'b0;
		#delay;
		assert(out == in0);
		
		sel = 1'b1;
		#delay;
		assert(out == in1);
	end
endmodule

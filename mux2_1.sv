`timescale 1ns/10ps

module mux2_1(out, in0, in1, sel);   
	output logic out;    
	input  logic in0, in1, sel; 
	logic out1, out2;
	parameter delay = 5;

	and #delay (out1, in1, sel);
	and #delay (out2, in0, ~sel);
	or  #delay (out, out1, out2);

endmodule

module mux2_1_testbench();
	logic in0, in1, out, sel;
	parameter delay = 50;
	
	mux2_1 dut (.out, .in0, .in1, .sel);
	
	initial begin
		in0 = 1'b1;
		in1 = 1'b0;
		sel = 1'b0;
		#delay;
		assert(in0 == out);
		
		in0 = 1'b1;
		in1 = 1'b0;
		sel = 1'b1;
		#delay;
		assert(in1 == out);
		
		in0 = 1'b0;
		in1 = 1'b1;
		#delay;
		assert(in1 == out);
	end
endmodule

`timescale 1ns/10ps

module inv #(parameter DELAY=0) (in, out);
	input logic in;
	output logic out;
	assign out = !in;
endmodule

module inv_testbench();
	logic in;
	logic out;
	parameter delay = 15;
	parameter delay_gate = 5;
	
	inv #delay_gate dut (.in, .out);

	initial begin
		in = 1'b1;
		#delay;
		assert (out == 1'b0);
		
		in = 1'b0;
		#delay;
		assert (out == 1'b1);
	end
endmodule

`timescale 1ns/10ps

module mux4_1 (i0, i1, i2, i3, sel, out);
	input logic i0, i1, i2, i3;
	input logic [1:0] sel;
	output logic out;
	parameter delay = 5;

	logic out1, out2, out3, out4;
	
	//assign out = (i0 & ~sel[0] & ~sel[1]) | (i1 & sel[0] & ~sel[1]) | (i2 & ~sel[0] & sel[1]) | (i3 & sel[0] & sel[1]);
	
	and #delay a1(out1, i0, ~sel[0], ~sel[1]);
	and #delay a2(out2, i1, sel[0], ~sel[1]);
	and #delay a3(out3, i2, ~sel[0], sel[1]);
	and #delay a4(out4, i3, sel[0], sel[1]);
	
	or #delay finalOut(out, out1, out2, out3, out4);


endmodule

module mux4_1_testbench();
	logic i0, i1, i2, i3;
	logic [1:0] sel;
	logic out;
		

mux4_1 dut (i0, i1, i2, i3, sel, out);

 initial begin
	i0 = 0;
	i1 = 1;
	i2 = 0;
	i3 = 0;
	sel = 2'b01;
	#10;
 end

 // Set up the inputs to the design. Each line is a clock cycle.

endmodule
`timescale 1ns/10ps

module Big64mux8_1(out, in0, in1, in2, in3, in4, in5, in6, in7, sel);
	input logic [63:0] in0, in1, in2, in3, in4, in5, in6, in7;
	output logic [63:0] out;
	input logic [2:0] sel;
	
	// Internal signals
	logic [63:0] layer1_out0;
	logic [63:0] layer1_out1;
	logic [63:0] layer1_out2;
	logic [63:0] layer1_out3;
	
	logic [63:0] layer2_out0;
	logic [63:0] layer2_out1;
	
	// Layer 1
	Big64mux2_1 layer1_mux0 (.out(layer1_out0), .in0(in0), .in1(in1), .sel(sel[0]));
	Big64mux2_1 layer1_mux1 (.out(layer1_out1), .in0(in2), .in1(in3), .sel(sel[0]));
	Big64mux2_1 layer1_mux2 (.out(layer1_out2), .in0(in4), .in1(in5), .sel(sel[0]));
	Big64mux2_1 layer1_mux3 (.out(layer1_out3), .in0(in6), .in1(in7), .sel(sel[0]));
	
	// Layer 2
	Big64mux2_1 layer2_mux0 (.out(layer2_out0), .in0(layer1_out0), .in1(layer1_out1), .sel(sel[1]));
	Big64mux2_1 layer2_mux1 (.out(layer2_out1), .in0(layer1_out2), .in1(layer1_out3), .sel(sel[1]));
	
	// Layer 3
	Big64mux2_1 layer3_mux (.out(out), .in0(layer2_out0), .in1(layer2_out1), .sel(sel[2]));
endmodule

module Big64mux8_1_testbench();
	logic [63:0] in0, in1, in2, in3, in4, in5, in6, in7;
	logic [63:0] out;
	logic [2:0] sel;
	parameter delay = 120;
	
	Big64mux8_1 dut (.out, .in0, .in1, .in2, .in3, .in4, .in5, .in6, .in7, .sel);
	
	integer i;
	
	initial begin
		in0 = 64'h0000000000000000;
		in1 = 64'h1111111111111111;
		in2 = 64'hAAAAAAAAAAAAAAAA;
		in3 = 64'hBBBBBBBBBBBBBBBB;
		in4 = 64'hCCCCCCCCCCCCCCCC;
		in5 = 64'hDDDDDDDDDDDDDDDD;
		in6 = 64'hEEEEEEEEEEEEEEEE;
		in7 = 64'hFFFFFFFFFFFFFFFF;
		
		for (i=0; i<8; i+=1) begin
			sel = i;
			#delay;
		end
	end
endmodule

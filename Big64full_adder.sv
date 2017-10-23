`timescale 1ns/10ps

module Big64full_adder(a, b, addOrSubtract, cout, sum);
	input logic [63:0] a, b;
	input logic addOrSubtract;
	output logic [63:0] cout, sum;
	logic [63:0] flip;
	parameter delay = 5;
	
	mux2_1 choose(.out(flip[0]), .in0(b[0]), .in1(~b[0]), .sel(addOrSubtract));
	full_adder halfAdder(.a(a[0]), .b(flip[0]), .cin(addOrSubtract), .sum(sum[0]), .cout(cout[0]));
	
	genvar i;
	generate
		for (i=1; i<64; i++) begin : each
			mux2_1 choose(.out(flip[i]), .in0(b[i]), .in1(~b[i]), .sel(addOrSubtract));
			full_adder fullAdder(.a(a[i]), .b(flip[i]), .cin(cout[i - 1]), .cout(cout[i]), .sum(sum[i]));
		end
	endgenerate
endmodule

module Big64full_adder_testbench();
	logic [63:0] cout, sum;
	logic [63:0] cin, a, b;
	logic addOrSubtract;
	parameter delay = 100; // wait for gate delays
	
	Big64full_adder dut (.a, .b, .addOrSubtract, .cout, .sum);
	integer j, k;

	 initial begin
		
		for (j=0; j <= 100; j+=10) begin
			a = j;
			for (k=0; k < 100; k++) begin
				b = k; #delay;
			end
		end
	 end
endmodule

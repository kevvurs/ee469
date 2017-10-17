`timescale 1ns/10ps

module Big64full_adder(a, b, cout, sum);
	input logic [63:0] a, b;
	output logic [63:0] cout, sum;
	parameter delay = 0;
	
	full_adder halfAdder(.a(a[0]), .b(b[0]), .cin(1'b0), .sum(sum[0]), .cout(cout[0]));
	
	genvar i;
	generate
		for (i=1; i<64; i++) begin : each
			full_adder fullAdder(.a(a[i]), .b(b[i]), .cin(cout[i - 1]), .cout(cout[i]), .sum(sum[i]));
		end
	endgenerate
endmodule

module Big64full_adder_testbench();
	logic [63:0] cout, sum;
	logic [63:0] cin, a, b;

	Big64full_adder dut (.a, .b, .cout, .sum);
	integer j, k;

	 initial begin
		
		for (j=0; j < 100; j++) begin
			a = j;
			for (k=0; k < 100; k++) begin
				b = k; #10;
			end
		end
		$stop;
	 end
endmodule

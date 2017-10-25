module register #(parameter SIZE=1) (q, d, reset, clk);
	output reg [SIZE-1:0] q;
	input [SIZE-1:0] d; 
	input reset, clk;
	
	genvar i;
	generate
		for (i=0; i<SIZE; i+=1) begin : each
			D_FF iDff (
				.q(q[i]),
				.d(d[i]),
				.reset(reset),
				.clk(clk)
			);
		end
	endgenerate
endmodule

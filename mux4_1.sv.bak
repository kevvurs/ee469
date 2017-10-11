module mux4_1 (i0, i1, i2, i3, sel, out);
	input logic [63:0] i0, i1, i2, i3;
	input logic [1:0] sel;
	output logic [64:0] out;
	
	assign out = (i0 & ~sel[0] & ~sel[1]) | (i1 & ~sel[0] & sel[1]) | (i2 & sel[0] & ~sel[1]) | (i3 & sel[0] & sel[1]);
	
	

endmodule

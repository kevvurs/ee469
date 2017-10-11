module Mem_Create  #(parameter WIDTH=32, SUBWIDTH=64) (q, d, reset, clk);
	output logic  [WIDTH-1:0][SUBWIDTH-1:0]  q;  
	input  logic  [WIDTH-1:0][SUBWIDTH-1:0]  d;
	input  logic  reset, clk;
 
	initial assert(WIDTH>0); 
 
	genvar i; 
 
	generate
		for(i=0; i<WIDTH; i++) begin : eachDff       
			Reg_Create #(SUBWIDTH) rc (.q(q[i]),  .d(d[i]), .reset(reset), .clk);
		end   
	endgenerate	
endmodule 
 
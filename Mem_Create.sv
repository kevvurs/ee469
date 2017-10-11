module Mem_Create  #(parameter WIDTH = 32, SUBWIDTH = 64) (q, write, en, reset, clk);
	output logic [WIDTH-1:0][SUBWIDTH-1:0] q;  
	input  logic [SUBWIDTH-1:0] write;
	input logic [WIDTH-1:0] en;
	input  logic reset, clk;
 
	initial assert(WIDTH>0); 
 
	genvar i; 
	generate
		for(i=0; i<WIDTH; i++) begin : eachDff       
			Reg_Create #(SUBWIDTH) rc (.q(q[i]),  .in(write), .en(en[i]), .reset(reset), .clk(clk));
		end   
	endgenerate	
endmodule 

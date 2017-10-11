module Reg_Create #(parameter WIDTH=64) (q, in, en, reset, clk);
	output logic [WIDTH-1:0] q;
	input logic [WIDTH-1:0] in;
	input logic en, reset, clk; 
	/* TODO in -> user input, only write on en == true
		logic [WIDTH-1:0] d;
		always_comb
			if (en) <---| prob illegal in lab 1
				d = in
			else
				d = ???
	*/
	logic [WIDTH-1:0] d;
	genvar j;
	generate
		for(j=0; j < WIDTH; j++) begin : MUXXES
			mux2_1 createReg (.out(d[j]), .feedback(q[j]), .in(in[j]), .en(en));
		end
	endgenerate
	
	//d = mux output
	genvar i;
	generate
		for(i=0; i<WIDTH; i++) begin : eachDff       
			d_ff D_FF (.q(q[i]),  .d(d[i]), .reset(reset),  .clk);
		end   
	endgenerate	
	
endmodule 
 
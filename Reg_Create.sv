module Reg_Create #(parameter WIDTH=64) (q, in, en, reset, clk);
	output logic [WIDTH-1:0] q;
	input logic [WIDTH-1:0] in;
	input logic en, reset, clk; 

	logic [WIDTH-1:0] d;
	genvar j;
	generate
		for(j=0; j < WIDTH; j++) begin : MUXXES
			mux2_1 createReg (.out(d[j]), .feedback(q[j]), .in(in[j]), .en(en));
		end
	endgenerate
	
	genvar i;
	generate
		for(i=0; i<WIDTH; i++) begin : eachDff       
			d_ff D_FF (.q(q[i]),  .d(d[i]), .reset(reset),  .clk);
		end   
	endgenerate	
	
endmodule 
 
module Reg_Create_testbench();
	logic [64-1:0] q;
	logic [64-1:0] in;
	logic en, reset, clk;

	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	Reg_Create dut (.q, .in, .en, .reset, .clk);

	integer i;
	parameter c = 64'hF23E0138CD33092B;

	initial begin
		in <= 0; reset <= 1; en <= 0;	@(posedge clk);
												@(posedge clk);
		reset <= 0;							@(posedge clk);
		in <= c;								@(posedge clk);
												@(posedge clk);
		in <= c; en <= 1;					@(posedge clk);
												@(posedge clk);
		$stop;
	end

endmodule

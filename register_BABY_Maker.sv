module register_BABY_Maker #(parameter WIDTH=64) (q, in, en, reset, clk);
	output logic [WIDTH-1:0] q;
	input logic [WIDTH-1:0] in;
	input logic reset, clk; 

	genvar i;
	generate
		for(i=0; i<WIDTH; i++) begin : eachDff       
			D_FF df (.q(q[i]),  .d(in[i]), .reset(reset),  .clk);
		end   
	endgenerate	
endmodule 
 
module Reg_Create_testbench();
	logic [64-1:0] q;
	logic [64-1:0] in;
	logic reset, clk;

	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	Reg_Create dut (.q, .in, .reset, .clk);

	integer i;
	parameter c = 64'hF23E0138CD33092B;

	initial begin
		in <= 0; reset <= 1;	@(posedge clk);
								@(posedge clk);
		reset <= 0;				@(posedge clk);
		in <= c;				@(posedge clk);
								@(posedge clk);
		in <= c; en <= 1;	    @(posedge clk);
							    @(posedge clk);
		$stop;
	end

endmodule

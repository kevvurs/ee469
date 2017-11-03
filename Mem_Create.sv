// implementation of 32x64 Memory in the register array
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

module Mem_Create_testbench();
	logic [32-1:0][64-1:0] q;  
	logic [64-1:0] write;
	logic [32-1:0] en;
	logic reset, clk;
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	Mem_Create dut (.q, .write, .en, .reset, .clk);

	integer i;
	parameter k = 32;
	parameter c = 64'hF23E0138CD33092B;

	initial begin
		reset <= 1; write <= c;	en <= 0;	@(posedge clk);
													@(posedge clk);
		reset <= 0;								@(posedge clk);
													@(posedge clk);
		en <= 32'h00010000;					@(posedge clk);
													@(posedge clk);

		$stop;
	end

endmodule

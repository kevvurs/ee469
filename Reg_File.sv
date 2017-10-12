// implementation of 32x64 Memory in the register array
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

module Mem_Create_techbench();
	logic  [32-1:0][64-1:0]  q;
	logic  [32-1:0][64-1:0]  d;
	logic  reset, clk;

	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	Mem_Create dut (.q, .d, .reset, .clk)

	integer i;
	parameter k = 32;
	parameter c = 64'hF23E0138CD33092B;

	initial begin
		reset <= 1; 	@(posedge clk);
		d <= 0;	 			@(posedge clk);
		reset <= 0;		@(posedge clk);

		for (i = 0; i < k; i++) begin
			 @(posedge clk); d[i] = (c + i);
		end
		$stop;
	end

endmodule

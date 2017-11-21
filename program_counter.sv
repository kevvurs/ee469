module program_counter (
	program_index,			// out
	cond_addr, br_addr,  // args
	uncondbr, br_taken,  // control
	baby_maker_br,
	reset, clk  			// standard
);
	output logic [63:0] program_index;
	input logic uncondbr, br_taken,
		reset, clk;
	input logic [63:0] baby_maker_br;
	input logic [18:0] cond_addr;
	input logic [25:0] br_addr;
	
	parameter
	size = 64,
	add_code = 3'b010,
	incr = 64'd4,
	shift_d = 6'd2;
	
	logic [size-1:0] count_wr, count_rd;
	
	logic pc_incr_neg, pc_incr_z,
		pc_incr_ovfl, pc_incr_cout;
	
	logic [63:0] cond_addr_mux, br_addr_mux,
		br_factor, br_delta;
		
	logic pc_sum_neg, pc_sum_z,
		pc_sum_ovfl, pc_sum_cout;
		
	logic [63:0] branch, step;
	
	
	register #size counter_memory (
		.d(count_wr),
		.q(count_rd),
		.reset(reset),
		.clk(clk)
	);
	
	alu pc_incr (
		.A(count_rd),
		.B(incr),
		.cntrl(add_code),
		.result(step),
		.negative(pc_incr_neg),
		.zero(pc_incr_z),
		.overflow(pc_incr_ovfl),
		.carry_out(pc_incr_cout)
	);
	
	sign_extend #(19, 64) cond_addr_ext (
		.in(cond_addr),
		.out(cond_addr_mux)
	);
	
	sign_extend #(26, 64) br_addr_ext (
		.in(br_addr),
		.out(br_addr_mux)
	);
	
	Big64mux2_1 mux_br (
		.in0(cond_addr_mux),
		.in1(br_addr_mux),
		.out(br_factor),
		.sel(uncondbr)
	);
	
	shifter quadr (
		.value(br_factor),
		.direction(1'b0),
		.distance(shift_d),
		.result(br_delta)
	);
	
	alu pc_sum (
		.A(baby_maker_br),
		.B(br_delta),
		.cntrl(add_code),
		.result(branch),
		.negative(pc_sum_neg),
		.zero(pc_sum_z),
		.overflow(pc_sum_ovfl),
		.carry_out(pc_sum_cout)
	);
	
	Big64mux2_1 mux_out (
		.in0(step),
		.in1(branch),
		.out(count_wr),
		.sel(br_taken)
	);
	
	always_comb begin
		if (reset) program_index = 64'd0;
		else program_index = count_rd;
	end
	
endmodule

// Composite 32:1 mux implementation
module mux32_1 #(parameter WIDTH=8, SUBWIDTH=2) (in, sel, out);
	input logic [31:0] in;
	input logic [4:0] sel;
	logic [WIDTH-1:0] out0;
	logic [SUBWIDTH-1:0] out1;
	output logic out;

	genvar i;
	generate
		for(i=0; i<WIDTH; i++) begin : eachDff
			mux4_1 muxxLayer1 (.i0(in[i * 4]), .i1(in[(i * 4) + 1]), .i2(in[(i * 4) + 2]), .i3(in[(i * 4) + 3]), .sel(sel[1:0]), .out(out0[i]));
		end
	endgenerate

	genvar j;
	generate
		for(j=0; j<SUBWIDTH; j++) begin : eachDff2
			mux4_1 muxxLayer2 (.i0(out0[j * 4]), .i1(out0[(j * 4) + 1]), .i2(out0[(j * 4) + 2]), .i3(out0[(j * 4) + 3]), .sel(sel[3:2]), .out(out1[j]));
		end
	endgenerate

	mux4_1 muxx (.i0(out1[0]), .i1(out1[1]), .i2(1'b0), .i3(1'b0), .sel({1'b0, sel[4]}), .out(out));

endmodule

module mux32_1_testbench();
	logic [31:0] in;
	logic [4:0] sel;
	logic out;

	parameter delay = 10
	integer i;

	Decoder dut (.in, .sel, .out);

 initial begin
	in = 32'hF001AC93;  sel = 5'b00110; #delay;
	in = 32'hCF010C43;  sel = 5'b01010; #delay;
	in = 32'hCAFEBABE;  sel = 5'b11111; #delay;

	for (i=0; i<32; i+=1) begin
		sel = i;
		#delay;
	end
	#delay;
 end
endmodule


module mux_64by_32 #(parameter WIDTH = 64, SUBWIDTH = 32) (regSelect, sel, out);

	input logic [SUBWIDTH-1:0][WIDTH-1:0] regSelect;

	input logic [4:0] sel;

	output logic [WIDTH-1:0] out;

	

	// Translation of regSelect

	logic [WIDTH-1:0][SUBWIDTH-1:0] regBind;

	

	genvar i, j;

	generate  // Rotate the register data into the mux's

		for(i=0; i<WIDTH; i++) begin : eachMux

			for(j=0; j<SUBWIDTH-1; j++) begin : eachMuxInput

				 assign regBind[i][j] = regSelect[j][i];

			end

			assign regBind[i][SUBWIDTH-1] = 1'b0;

			mux32_1 muxx (.in(regBind[i]), .sel(sel), .out(out[i]));

		end

	endgenerate

endmodule



module mux_64by_32_testbench();

	logic [31:0][63:0] regSelect;

	logic [4:0] sel;

	logic [63:0] out;



	mux_64by_32 dut (regSelect, sel, out);



 initial begin

	regSelect = 0;

	regSelect[10][63:0] = 64'b0111010010000001010011101111000111101010001010101011011101110111;	

	sel = 5'b01010;

	#10;



 end

endmodule

// EOF
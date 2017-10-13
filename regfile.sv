/* Top Level module
	Connects all the components of the regfile
	Provides ability to read from 2 registers simultanously
	and write to 1 register */
module regfile(
	ReadData1, ReadData2, WriteData, 
	ReadRegister1, ReadRegister2, WriteRegister,
	RegWrite, clk
);
	// External ports
	output logic [63:0] ReadData1, ReadData2;
	input logic [63:0] WriteData;
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic RegWrite, clk;

	// Memory architecture
	parameter numReg = 32;
	parameter regSize = 64;
	logic [numReg-1:0][regSize-1:0] mem;
	logic [numReg-1:0] enables;
	logic reset;
	// Connect registers
	Decoder
		dec
		(.writeReg(WriteRegister), .RegWrite(RegWrite), .regSelect(enables));
	
	Mem_Create 
		#(.WIDTH(numReg), .SUBWIDTH(regSize))
		mainMem 
		(.q(mem), .write(WriteData), .en(enables), .reset(reset), .clk(clk));
	
	// Read access (dual channels)
	mux_64by_32
		#(.WIDTH(regSize), .SUBWIDTH(numReg))
		rchannel1
		(.regSelect(mem), .sel(ReadRegister1), .out(ReadData1));
	
	mux_64by_32
		#(.WIDTH(regSize), .SUBWIDTH(numReg))
		rchannel2
		(.regSelect(mem), .sel(ReadRegister2), .out(ReadData2));
		
	

endmodule
// EOF

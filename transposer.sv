`timescale 1ns/10ps

module transposer(data, fixed, shamt, clear, out);
  input logic [63:0] data;
  input logic [15:0] fixed;
  input logic [1:0] shamt;
  output logic [63:0] out;
  input logic clear;
  logic [5:0] shamtX16;
  logic [63:0] comp;
  parameter left = 1'b0;

  logic [63:0] extShamt, extShamtX16,
	extFixed, movFixed;

  prepend #(2, 64) prepShamt(
    .in(shamt),
    .out(extShamt)
  );
  
  prepend #(16, 64) prepFixed(
    .in(fixed),
    .out(extFixed)
  );

  shifter x16 (
    .value(extShamt),
    .direction(left),
    .distance(6'b000100),
    .result(extShamtX16)
  );

  // TODO: using 6'b to fit in shifter but this caps out
  assign shamtX16 = extShamtX16[5:0];
  
   shifter lsl(
    .value(extFixed),
    .direction(left),
    .distance(shamtX16),
    .result(movFixed)
  );
  
  integer i;
  always_comb
    if (clear)
		out[63:0] = movFixed[63:0];
	else begin
		for (i=0; i<64; i+=1)
			if (i >= shamtX16 && i < shamtX16 + 6'd16) 
				out[i] = movFixed[i];
			else
				out[i] = data[i];
	end
endmodule

module transposer_testbench();
  logic [63:0] data;
  logic [15:0] fixed;
  logic [1:0] shamt;
  logic [63:0] out;
  logic clear;

  parameter delay = 50;

  transposer dut(.data, .fixed, .shamt, .out, .clear);

  initial begin
    data[63:0] = 64'hBA0962E10168F4C0;
    fixed[15:0] = 64'hCAFE;
    shamt = 2'b00;
    clear = 1'b0;
    #delay;

    data[63:0] = 64'hAFCEDFAEDCFADCEE;
    fixed[15:0] = 64'h33C3;
    shamt = 2'b01;
    clear = 1'b1;
    #delay;

    data[63:0] = 64'h4293480238098048;
    fixed[15:0] = 64'hBABE;
    shamt = 2'b10;
    clear = 1'b0;
    #delay;

    #delay;
  end
endmodule

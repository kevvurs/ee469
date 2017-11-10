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
  parameter delay = 5;

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

  logic is00;
  logic is16;
  logic is32;
  logic is48;

  logic excl;
  logic [3:0] dec;
  xor #delay checkXx (excl, shamt[1], shamt[0]);
  nor #delay check00 (dec[0], shamt[1], shamt[0]);
  and #delay check16 (dec[1], excl, shamt[0]);
  and #delay check32 (dec[2], shamt[1], excl);
  and #delay check48 (dec[3], shamt[1], shamt[0]);

  logic [3:0] sel;
  genvar n;
  generate
    for (n=0; n<4; n+=1) begin : eachOr
      or #delay iOR (sel[n], clear, dec[n]);
    end
  endgenerate

  genvar i;
  generate
    for (i=0; i<64; i+=1) begin : eachMux
      mux2_1 iMux (.out(out[i]), .in0(data[i]), .in1(movFixed[i]), .sel(sel[i/16]));
    end
  endgenerate
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

	 data[63:0] = 64'h4293480238098048;
    fixed[15:0] = 64'hBABE;
    shamt = 2'b11;
    clear = 1'b0;
    #delay;

	 data[63:0] = 64'h4293480238098048;
    fixed[15:0] = 64'hBABE;
    shamt = 2'b11;
    clear = 1'b1;
    #delay;

    #delay;
  end
endmodule

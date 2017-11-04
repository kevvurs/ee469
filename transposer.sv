`timescale 1ns/10ps

module transposer(data, fixed, shamt, clear, out);
  input logic [63:0] data;
  input logic [15:0] fixed;
  input logic [1:0] shamt;
  output logic [63:0] out;
  input logic clear;
  logic [63:0] shamtX16;
  logic [63:0] comp;
  parameter left = 0;

  logic [63:0] extShamt, extShamtX16;

  prepend #(2, 64) prepShamt(
    .in(shamt),
    .out(extShamt)
  );

  shifter x16 (
    .value(extShamt),
    .direction(left),
    .distance(6'b000100),
    .result(extShamtX16)
  );

  // TODO: use 6'b to fit in shifter but this caps out
  assign shamtX16 = extShamtX16[5:0];

  always_comb begin
    if (clear) comp[63:16] = 48'd0;
    comp[15:0] = fixed;
  end

  shifter lsl(
    .value(comp),
    .direction(left),
    .distance(shamtX16),
    .result(out)
  );
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
    data[63:0] = 64'bBA0962E10168F4C0;
    fixed[15:0] = 64'bCAFE;
    shamt = 2'b00;
    clear = 1'b0;
    #delay;

    data[63:0] = 64'bAFCEDFAEDCFADCEE;
    fixed[15:0] = 64'b0000;
    shamt = 2'b01;
    clear = 1'b1;
    #delay;

    data[63:0] = 64'b4293480238098048;
    fixed[15:0] = 64'bBABE;
    shamt = 2'b10;
    clear = 1'b0;
    #delay;

    #delay;
  end
endmodule

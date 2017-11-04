module transposer(data, fixed, shamt, clear, out);
  input logic [63:0] data;
  input logic [15:0] fixed;
  input logic [1:0] shamt;
  output logic [63:0] out;
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

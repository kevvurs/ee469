module fowarding(alu_rd_key, alu_result, reg_rm_lookup, reg_rn_lookup,
  rm_fetch, rn_fetch, rm_valid, rn_valid, clk, reset);
  input logic [4:0] alu_rd_key
  input logic [63:0] alu_result;

  input logic [4:0] reg_rm_lookup, reg_rn_lookup;

  output logic [63:0] rm_fetch, rn_fetch;
  output logic rm_valid, rn_valid

  logic [1:0][63:0] alu_store_value;
  logic [1:0][4:0] alu_store_key;

  parameter x31 = 5'b11111;

  always_comb begin
    if (reg_rm_lookup == x31) begin
      rm_fetch = 64'd0;
      rm_valid =1'b0;
    end else begin
      if (reg_rm_lookup == alu_store_key[1]) begin
        rm_fetch = alu_store_value[1];
        rm_valid =1'b1;
      end else if (reg_rm_lookup == alu_store_key[0]) begin
        rm_fetch = alu_store_value[0];
        rm_valid =1'b1;
      end else begin
        rm_fetch = 64'd0;
        rm_valid =1'b0;
      end
    end

    if (reg_rn_lookup == x31) begin
      rn_fetch = 64'd0;
      rn_valid =1'b0;
    end else begin
      if (reg_rm_lookup == alu_store_key[1]) begin
        rn_fetch = alu_store_value[1];
        rn_valid =1'b1;
      end else if (reg_rm_lookup == alu_store_key[0]) begin
        rn_fetch = alu_store_value[0];
        rn_valid =1'b1;
      end else begin
        rn_fetch = 64'd0;
        rn_valid =1'b0;
      end
    end
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      rm_fetch <= 64'd0;
      rn_fetch <= 64'd0;
      rm_valid <= 1'b0;
      rn_valid <= 1'b0;
    end else begin
      alu_store_key[0] <= alu_store_key[1];
      alu_store_key[1] <= alu_rd_key;
      alu_store_value[0] <= alu_store_value[1];
      alu_store_value[1] <= alu_result;
    end
  end
endmodule

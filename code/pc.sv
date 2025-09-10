module pc (
   input logic i_clk, i_rst,
   input logic [31:0] i_pc,
   output logic [31:0] o_pc
);

   always_ff @(posedge i_clk or posedge i_rst ) begin
      if (i_rst)
         o_pc <= 32'd0;
      else
         o_pc <= i_pc;
   end

endmodule


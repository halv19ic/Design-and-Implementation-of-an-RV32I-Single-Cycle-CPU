module mux2to1 (
   // Inputs:
   input logic [31:0] i_0,
   input logic [31:0] i_1,
   input logic i_sel,
   // Output:
   output logic [31:0] o_mux
);

   assign o_mux = i_sel ? i_1 : i_0;

endmodule
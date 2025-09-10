module mux3to1 (
   // Inputs:
   input logic [31:0] i_0,
   input logic [31:0] i_1,
   input logic [31:0] i_2,
   input logic [1:0] i_sel,
   // Output:
   output logic [31:0] o_mux
);

   assign o_mux = (i_sel == 2'b10) ? i_2 : (i_sel == 2'b01) ? i_1 : i_0;

endmodule
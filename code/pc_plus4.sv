module pc_plus4(
	input logic [31:0] i_pc_plus4,
	output logic [31:0] o_next_pc
);

	assign o_next_pc = i_pc_plus4 + 3'd4;	
endmodule
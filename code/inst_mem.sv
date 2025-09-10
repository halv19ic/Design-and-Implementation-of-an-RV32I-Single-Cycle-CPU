module inst_mem (
	input logic [31:0] i_addr,
	output logic [31:0] o_inst
);
	logic [3:0][7:0] imem [2**11-1:0];
	initial begin
		$readmemh("D:/single_cycle/00_src/instmem_data.hex",imem);
	end
	
	assign o_inst = imem[i_addr[12:2]];
endmodule
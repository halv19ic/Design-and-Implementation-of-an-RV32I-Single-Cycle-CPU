module imm_gen(
	input logic [31:0] i_inst,
	output logic [31:0] o_immGen
);
	always_comb begin
		case(i_inst[6:0])
		
				// Immediate-type
        	7'b0010011: begin
			case(i_inst[14:12])
				3'b001: o_immGen = i_inst[24:20];
				3'b101: o_immGen = i_inst[24:20];
				default: o_immGen = {{20{i_inst[31]}}, i_inst[31:20] };
			endcase
    		end

				// Load-type
		7'b0000011: o_immGen = {{20{i_inst[31]}}, i_inst[31:20] };

				// Store-type
		7'b0100011: o_immGen = {{20{i_inst[31]}}, i_inst[31:25], i_inst[11:7] };

				// Branch-type
		7'b1100011: o_immGen = {{19{i_inst[31]}}, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};

				// Jump-type 
		7'b1100111: o_immGen = {{20{i_inst[31]}}, i_inst[31:20]};	// JALR	- Jump and Link
		7'b1101111: o_immGen = {{12{i_inst[31]}}, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0 };	// JAL - Jump and Link Register
	
				// Upper_immediate-type
		7'b0110111: o_immGen = {i_inst[31:12], {12{1'b0}}};	// LUI - load upper immediate						
   		7'b0010111: o_immGen = {i_inst[31:12], {12{1'b0}}};	// AUIPC - load upper immediate to PC	
		
		endcase
	end
endmodule	

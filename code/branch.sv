module branch(
	input logic [31:0] i_rs1_data, i_rs2_data,
	input logic i_BrUn,
	output logic o_BrEq, o_BrLT
);
	always_comb begin
		if(i_BrUn == 1) begin
			for(int i=31; i>=0;i--) begin
				if(i_rs1_data[i] != i_rs2_data[i]) begin
					o_BrEq = 0;
					o_BrLT = i_rs2_data[i];
					break;
				end
				else begin
					o_BrEq = 1;
					o_BrLT = 0;
				end
			end
		end
		else begin
			if(i_rs1_data[31] != i_rs2_data[31]) begin	
				o_BrLT = i_rs1_data[31];
				o_BrEq = 0;
			end
			else begin
				for(int i=31; i>=0;i--) begin
					if(i_rs1_data[i] != i_rs2_data[i]) begin
						o_BrEq = 0;
						o_BrLT = i_rs2_data[i];
						break;
					end
					else begin
						o_BrEq = 1;
						o_BrLT = 0;
					end
				end
				
			end
		end
	end

endmodule

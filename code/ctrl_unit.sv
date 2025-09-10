module ctrl_unit (
    input logic i_BrEq,
    input logic i_BrLT,
    input logic [31:0] inst,

    output logic o_pc_sel,
    output logic o_rd_wren,
    output logic o_BrUn,
    output logic o_a_sel,
    output logic o_b_sel,
    output logic [3:0] o_alu_sel,
    output logic o_lsu_wren,
    output logic [1:0] o_wb_sel
);

    always_comb begin
        case (inst[6:2])
        // R-type
            5'b01100: begin
                case({inst[30],inst[14:12]})                                 
                    5'b0000:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd0,1'b0,2'b01}; // ADD
                    5'b1000:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd1,1'b0,2'b01}; // SUB
                    5'b0001:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd2,1'b0,2'b01}; // SLL
                    5'b0101:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd3,1'b0,2'b01}; // SRL
                    5'b0100:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd4,1'b0,2'b01}; // XOR
                    5'b0111:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd5,1'b0,2'b01}; // AND
                    5'b0110:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd6,1'b0,2'b01}; // OR
                    5'b0010:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd7,1'b0,2'b01}; // SLT
                    5'b0011:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd8,1'b0,2'b01}; // SLTU
                    5'b1101:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b0,4'd9,1'b0,2'b01}; // SRA

                    default:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b0,4'd0,1'b0,2'b00};             
                endcase
            end 
        // I-type
            5'b00100: begin
                case({inst[30],inst[14:12]})
                    5'b0000:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd0,1'b0,2'b01}; // ADDI
                    5'b0010:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd7,1'b0,2'b01}; // SLTI
                    5'b0011:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd8,1'b0,2'b01}; // SLTIU
                    5'b0100:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd4,1'b0,2'b01}; // XORI
                    5'b0110:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd6,1'b0,2'b01}; // ORI
                    5'b0111:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd5,1'b0,2'b01}; // ANDI
                    5'b0001:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd2,1'b0,2'b01}; // SLLI
                    5'b0101:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd3,1'b0,2'b01}; // SRLI
                    5'b1101:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd9,1'b0,2'b01}; // SRAI
                    default:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b0,4'd0,1'b0,2'b00};             
                endcase
            end
        // L-type
            5'b00000:begin
                case(inst[14:12])
                    3'b000:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd0,1'b0,2'b00}; // LB
                    3'b001:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd0,1'b0,2'b00}; // LH
                    3'b010:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd0,1'b0,2'b00}; // LW
                    3'b011:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd0,1'b0,2'b00}; // LBU
                    3'b101:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd0,1'b0,2'b00}; // LHU
                    default:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b0,4'd0,1'b0,2'b00};             
                endcase
            end
        // S-type
            5'b01000:begin
                case(inst[14:12])
                    3'b000:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b1,4'd0,1'b1,2'b00}; // SB
                    3'b001:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b1,4'd0,1'b1,2'b00}; // SH
                    3'b010:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b1,4'd0,1'b1,2'b00}; // SW
                    default:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b0,4'd0,1'b0,2'b00};             
                endcase
            end
        // B-type
            5'b11000:begin
                case(inst[14:12])
                    3'b000:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={(i_BrEq  ? 1'b1 : 1'b0), 1'b0,1'b0,1'b1,1'b1,4'd0,1'b0,2'b00}; // BEQ
                    3'b001:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={(!i_BrEq ? 1'b1 : 1'b0),1'b0,1'b0,1'b1,1'b1,4'd0,1'b0,2'b00}; // BNQ
                    3'b100:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={(i_BrLT  ? 1'b1 : 1'b0),1'b0,1'b0,1'b1,1'b1,4'd0,1'b0,2'b00}; // BLT
                    3'b101:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={(!i_BrLT ? 1'b1 : 1'b0), 1'b0,1'b0,1'b1,1'b1,4'd0,1'b0,2'b00}; // BGT
                    3'b110:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={(i_BrLT  ? 1'b1 : 1'b0), 1'b0,1'b1,1'b1,1'b1,4'd0,1'b0,2'b00}; // BLUT
                    3'b111:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={(!i_BrLT ? 1'b1 : 1'b0),1'b0,1'b1,1'b1,1'b1,4'd0,1'b0,2'b00}; // BGEU
                    default:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b0,4'd0,1'b0,2'b00};             
                endcase
            end
        // JAL
            5'b11011:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}=(inst[14:12]==3'b000) ? {1'b1,1'b1,1'b0,1'b1,1'b1,4'd0, 1'b0,2'b10}:{1'b0,1'b0,1'b0,1'b0,1'b0,4'd0,1'b0,2'b00} ;   
        // JALR
            5'b11001:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b1,1'b1,1'b0,1'b0,1'b1,4'd0, 1'b0,2'b10};   
        // LUI
            5'b01101:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b0,1'b1,4'd10,1'b0,2'b01};
        // AUIPC
            5'b00101:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b1,1'b0,1'b1,1'b1,4'd0,1'b0,2'b01};   
            default:{o_pc_sel,o_rd_wren,o_BrUn,o_a_sel,o_b_sel,o_alu_sel,o_lsu_wren,o_wb_sel}={1'b0,1'b0,1'b0,1'b0,1'b0,4'd0,1'b0,2'b00};             
        endcase
    end
endmodule
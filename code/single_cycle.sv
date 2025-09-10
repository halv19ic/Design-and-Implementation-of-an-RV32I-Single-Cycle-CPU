module single_cycle (

   // Inputs:
   input  logic        i_clk,
   input  logic        i_rst,
   input  logic [31:0] i_io_sw,
   input  logic [3:0]  i_io_btn,

   // Outputs:

   output logic [31:0] o_io_ledr,
   output logic [31:0] o_io_ledg,
   output logic [6:0]  o_io_hex0,
   output logic [6:0]  o_io_hex1,
   output logic [6:0]  o_io_hex2,
   output logic [6:0]  o_io_hex3,
   output logic [6:0]  o_io_hex4,
   output logic [6:0]  o_io_hex5,
   output logic [6:0]  o_io_hex6,
   output logic [6:0]  o_io_hex7,
   output logic [31:0] o_io_lcd
        
);

//-------------------INTERNAL SIGNAL-------------------------//
wire [31:0] net_i_pc, net_o_next_pc;
wire [31:0] net_o_pc;
wire [31:0] net_o_inst; 
wire [31:0] net_o_alu;              
wire net_i_pc_sel;

wire [4:0] rs1_addr, rs2_addr, rd_addr;
wire [31:0] net_o_rs1_data, net_o_rs2_data;
wire [31:0] net_o_immGen;
wire net_i_BrUn;
wire net_o_BrEq;
wire net_o_BrLT;
wire net_i_rd_wren;

wire [31:0] net_i_rs1_ALU, net_i_rs2_ALU;
wire [3:0] net_i_alu_sel;
wire i_A_sel,i_B_sel;

wire net_o_lsu_wren;
wire [1:0] net_o_wb_sel;
wire [31:0] wb_data;
logic [31:0] ld_data;

//-----------------------------------FETCH-----------------//
pc PC(
   .i_clk(i_clk),
   .i_rst(i_rst),
   .i_pc(net_i_pc),
   .o_pc(net_o_pc)
);
pc_plus4 PC_PLUS4(
    .i_pc_plus4(net_o_pc),
    .o_next_pc(net_o_next_pc)
);
mux2to1 MUX2TO1(
   .i_0(net_o_next_pc),
   .i_1(net_o_alu),
   .i_sel(net_i_pc_sel),
   .o_mux(net_i_pc)
);
inst_mem IMEM(
  .i_addr(net_o_pc),
  .o_inst(net_o_inst)
  );
//--------------------------DECODE-------------------//
assign rs1_addr = net_o_inst[19:15];
assign rs2_addr = net_o_inst[24:20];
assign rd_addr = net_o_inst[11:7];
reg_file REGISTER_FILE(
    .i_rd_data(wb_data),
    .i_rd_addr(rd_addr),
    .i_rs1_addr(rs1_addr),
    .i_rs2_addr(rs2_addr),
    .i_rd_wren(net_i_rd_wren),
    .i_rst(i_rst),
    .i_clk(i_clk),

    .o_rs1_data(net_o_rs1_data),
    .o_rs2_data(net_o_rs2_data)
);
imm_gen IMMEDIATE_GENERATION(
    .i_inst(net_o_inst),
    .o_immGen(net_o_immGen)
);
branch BRANCH(
    .i_rs1_data(net_o_rs1_data),
    .i_rs2_data(net_o_rs2_data),
    .i_BrUn(net_i_BrUn),
    .o_BrEq(net_o_BrEq),
    .o_BrLT(net_o_BrLT)
);


//-------------------EXECUTE-------------------//
mux2to1 input_rs1_ALU(
   .i_0(net_o_rs1_data),
   .i_1(net_o_pc),
   .i_sel(i_A_sel),
   .o_mux(net_i_rs1_ALU)   
);
mux2to1 input_rs2_ALU(
   .i_0(net_o_rs2_data),
   .i_1(net_o_immGen),
   .i_sel(i_B_sel),
   .o_mux(net_i_rs2_ALU)    
);
alu ALU(
    .i_rs1_data(net_i_rs1_ALU),
    .i_rs2_data(net_i_rs2_ALU),
    .i_alu_sel(net_i_alu_sel),
    .o_result_alu(net_o_alu)

);

//-------------------------LSU-----------------------------//

lsu LSU (
    .i_clk      (i_clk),
    .i_rst      (i_rst),
    .i_lsu_op   (net_o_inst[14:12]),
    .i_lsu_addr (net_o_alu),
    .i_st_data  (net_o_rs2_data),
    .i_lsu_wren (net_o_lsu_wren),
    .i_io_sw    (i_io_sw),
    .i_io_btn   (i_io_btn),
    .o_ld_data  (ld_data),
    .o_io_ledr  (o_io_ledr),
    .o_io_ledg  (o_io_ledg),
    .o_io_hex0  (o_io_hex0),
    .o_io_hex1  (o_io_hex1),
    .o_io_hex2  (o_io_hex2),
    .o_io_hex3  (o_io_hex3),
    .o_io_hex4  (o_io_hex4),
    .o_io_hex5  (o_io_hex5),
    .o_io_hex6  (o_io_hex6),
    .o_io_hex7  (o_io_hex7),
    .o_io_lcd   (o_io_lcd)
);

mux3to1 Mux_WB_data (
    .i_0   (ld_data),
    .i_1   (net_o_alu),
    .i_2   (net_o_next_pc),
    .i_sel (net_o_wb_sel),
    .o_mux (wb_data)
);

//-----------------CONTROL_UNIT-------------------
ctrl_unit CTRL_UNIT(
.i_BrEq(net_o_BrEq),
.i_BrLT(net_o_BrLT),
.inst(net_o_inst),

.o_pc_sel(net_i_pc_sel),
.o_rd_wren(net_i_rd_wren),
.o_BrUn(net_i_BrUn),
.o_a_sel(i_A_sel),
.o_b_sel(i_B_sel),
.o_alu_sel(net_i_alu_sel),
.o_lsu_wren(net_o_lsu_wren),
.o_wb_sel(net_o_wb_sel)
);


endmodule
module lsu (
   // Inputs:
   input logic i_clk,
   input logic i_rst,
   input logic [2:0] i_lsu_op,
   input logic [31:0] i_lsu_addr,
   input logic [31:0] i_st_data,
   input logic i_lsu_wren,
   input logic [31:0] i_io_sw,
   input logic [3:0] i_io_btn,
   // Outputs:
   output logic [31:0] o_ld_data,
   output logic [31:0] o_io_ledr,
   output logic [31:0] o_io_ledg,
   output logic [6:0] o_io_hex0,
   output logic [6:0] o_io_hex1,
   output logic [6:0] o_io_hex2,
   output logic [6:0] o_io_hex3,
   output logic [6:0] o_io_hex4,
   output logic [6:0] o_io_hex5,
   output logic [6:0] o_io_hex6,
   output logic [6:0] o_io_hex7,
   output logic [31:0] o_io_lcd
);

//-------------------------------- Internal signals --------------------------------

   // LSU address:
   logic [15:0] internal_addr;
   logic [4:0] offset;

   // DMEM signal:
   logic [31:0] dmem_data;
   logic [3:0] dmem_wren;

   // Output Peripherals signal:
   logic [31:0] o_periph_data;
   logic [3:0] o_buffer_wren;

   // Input Peripherals signal:
   logic [31:0] i_periph_data;

//-------------------------- Using 16-bit address for LSU --------------------------

   assign internal_addr = i_lsu_addr[15:0];

//------------------------------- DMEM instantiation -------------------------------

   dmem DMEM (
      .i_clk (i_clk),
      .i_rst (i_rst),
      .i_dmem_addr (internal_addr),
      .i_wr_data (i_st_data),
      .i_dmem_wren (dmem_wren),
      .o_ld_data (dmem_data)
   );

//-------------------------- Output Buffer instantiation ---------------------------

   output_buffer Output_Peripherals (
      .i_clk (i_clk),
      .i_rst (i_rst),
      .i_addr (internal_addr),
      .i_wr_data (i_st_data),
      .i_wr_en (o_buffer_wren),
      .o_ld_data (o_periph_data),
      .o_io_ledr (o_io_ledr),
      .o_io_ledg (o_io_ledg),
      .o_io_hex0 (o_io_hex0),
      .o_io_hex1 (o_io_hex1),
      .o_io_hex2 (o_io_hex2),
      .o_io_hex3 (o_io_hex3),
      .o_io_hex4 (o_io_hex4),
      .o_io_hex5 (o_io_hex5),
      .o_io_hex6 (o_io_hex6),
      .o_io_hex7 (o_io_hex7),
      .o_io_lcd (o_io_lcd)
   );

//--------------------------- Input Buffer instantiation ---------------------------

   input_buffer Input_Peripherals (
      .i_addr (internal_addr),
      .i_io_sw (i_io_sw),
      .i_io_btn (i_io_btn),
      .o_ld_data (i_periph_data)
   );

//-------------------------------- Address decoding --------------------------------

   always_comb begin
      offset = ({3'b0, i_lsu_addr[1:0]} << 3);

      //--- DMEM ---
      if ((internal_addr[15:12] == 4'h2) || (internal_addr[15:12] == 4'h3)) begin

         if (!i_lsu_wren) begin //Load (read data)
            case (i_lsu_op)
               3'b000: o_ld_data = {{24{dmem_data[offset + 7]}}, dmem_data[offset +:8]};    //LB
               3'b001: o_ld_data = {{16{dmem_data[offset + 15]}}, dmem_data[offset +:16]};  //LH
               3'b010: o_ld_data = dmem_data;                                               //LW              
               3'b100: o_ld_data = {24'b0, dmem_data[offset +:8]};                          //LBU
               3'b101: o_ld_data = {16'b0, dmem_data[offset +:16]};                         //LHU   
               default: o_ld_data = 32'b0;
            endcase
            dmem_wren = 4'b0;
         end

         else begin //Store (write data)
            case (i_lsu_op)
               3'b000: dmem_wren = (4'b0001) << i_lsu_addr[1:0];  //SB
               3'b001: dmem_wren = (4'b0011) << i_lsu_addr[1:0];  //SH
               3'b010: dmem_wren = 4'b1111;                       //SW                                              
               default: dmem_wren = 4'b0;
            endcase
            o_ld_data = 32'b0;
         end
         o_buffer_wren = 4'b0;
      end

      //--- Output Peripherals ---
      else if ((internal_addr >= 16'h7000) && (internal_addr <= 16'h703F)) begin

         if (!i_lsu_wren) begin //Load (read data)
            case (i_lsu_op)
               3'b000: o_ld_data = {{24{o_periph_data[offset + 7]}}, o_periph_data[offset +:8]};    //LB
               3'b001: o_ld_data = {{16{o_periph_data[offset + 15]}}, o_periph_data[offset +:16]};  //LH
               3'b010: o_ld_data = o_periph_data;                                                   //LW              
               3'b100: o_ld_data = {24'b0, o_periph_data[offset +:8]};                              //LBU
               3'b101: o_ld_data = {16'b0, o_periph_data[offset +:16]};                             //LHU   
               default: o_ld_data = 32'b0;
            endcase
            o_buffer_wren = 4'b0;
         end

         else begin //Write 
            case (i_lsu_op)
               3'b000: o_buffer_wren = (4'b0001) << i_lsu_addr[1:0];  //SB
               3'b001: o_buffer_wren = (4'b0011) << i_lsu_addr[1:0];  //SH
               3'b010: o_buffer_wren = 4'b1111;                       //SW                                              
               default: o_buffer_wren = 4'b0;
            endcase
            o_ld_data = 32'b0;
         end
         dmem_wren = 4'b0;
      end

      //--- Input Peripherals ---
      else if ((internal_addr >= 16'h7800) && (internal_addr <= 16'h781F)) begin
         if (!i_lsu_wren) begin //Load (read data)
            case (i_lsu_op)
               3'b000: o_ld_data = {{24{i_periph_data[offset + 7]}}, i_periph_data[offset +:8]};    //LB
               3'b001: o_ld_data = {{16{i_periph_data[offset + 15]}}, i_periph_data[offset +:16]};  //LH
               3'b010: o_ld_data = i_periph_data;                                                   //LW
               3'b100: o_ld_data = {24'b0, i_periph_data[offset +:8]};                              //LBU
               3'b101: o_ld_data = {16'b0, i_periph_data[offset +:16]};                             //LHU
               default: o_ld_data = 32'b0;
            endcase
         end
         else begin
            o_ld_data = 32'h0;
         end
         o_buffer_wren = 4'h0;
         dmem_wren = 4'h0;
      end

      //--- Default ---
      else begin
         o_buffer_wren = 4'b0;
         dmem_wren = 4'b0;
         o_ld_data = 32'b0;
      end
   end

endmodule
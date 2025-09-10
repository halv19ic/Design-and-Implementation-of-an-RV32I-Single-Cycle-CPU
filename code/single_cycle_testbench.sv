`timescale 1ns / 1ps

module tb_single_cycle;

  // Inputs
  logic clk;
  logic rst;
  logic [31:0] io_sw;
  logic [3:0] io_btn;

  // Outputs
  logic [31:0] io_ledr;
  logic [31:0] io_ledg;
  logic [6:0] io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7;
  logic [31:0] io_lcd;

  // Instantiate the DUT
  single_cycle dut (
    .i_clk      (clk),
    .i_rst      (rst),
    .i_io_sw    (io_sw),
    .i_io_btn   (io_btn),
    .o_io_ledr  (io_ledr),
    .o_io_ledg  (io_ledg),
    .o_io_hex0  (io_hex0),
    .o_io_hex1  (io_hex1),
    .o_io_hex2  (io_hex2),
    .o_io_hex3  (io_hex3),
    .o_io_hex4  (io_hex4),
    .o_io_hex5  (io_hex5),
    .o_io_hex6  (io_hex6),
    .o_io_hex7  (io_hex7),
    .o_io_lcd   (io_lcd)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Stimulus
  initial begin
    // Initialize Inputs
    rst = 1;
    io_sw = 32'h00000000;
    io_btn = 4'b0000;

    // Wait for global reset to finish
    #20;
    rst = 0;

    $display("------------------------------------------------------------------------------------------------------------------------------------------");
    $display("| Time    | PC        | Inst      | ImmGen    | rd | rs1 | rs2 | rs1_data | rs2_data | A_in     | B_in     | ALU_out  |");
    $display("------------------------------------------------------------------------------------------------------------------------------------------");

    repeat (50) begin
      @(posedge clk);
      #1;
      $display("| %7t | %08h | %08h | %08h | %2d | %3d | %3d | %08h | %08h | %08h | %08h | %08h |",
        $time,
        dut.net_o_pc,
        dut.net_o_inst,
        dut.net_o_immGen,
        dut.rd_addr,
        dut.rs1_addr,
        dut.rs2_addr,
        dut.net_o_rs1_data,
        dut.net_o_rs2_data,
        dut.net_i_rs1_ALU,
        dut.net_i_rs2_ALU,
        dut.net_o_alu
      );

      // Nếu lệnh là SW (opcode 0100011)
      if (dut.net_o_inst[6:0] == 7'b0100011) begin
        $display(">>> [SW] Time: %t | Store MEM[%08h] <= %08h",
          $time,
          dut.net_o_alu,        // địa chỉ bộ nhớ
          dut.net_o_rs2_data    // giá trị cần ghi
        );
      end
    end

    $display("------------------------------------------------------------------------------------------------------------------------------------------");

    $stop;
  end

endmodule

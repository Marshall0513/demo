//------------------------------------------------------------------------------
// I2C UVM Testbench Top
//   - Clock generation, DUT instantiation, interface wiring
//   - Calls run_test() to start UVM
//------------------------------------------------------------------------------

module i2c_tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // ─── Clock & Reset ────────────────────────────────────────────────────────
  logic clk;
  logic rst_n;

  parameter CLK_PERIOD = 10;  // 100 MHz

  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst_n = 1;
    repeat (2) @(posedge clk);
    rst_n = 0;
    repeat (5) @(posedge clk);
    rst_n = 1;
  end

  // ─── Interface ────────────────────────────────────────────────────────────
  i2c_if i2c_if_inst (
    .clk   (clk),
    .rst_n (rst_n)
  );

  // ─── DUT (I2C Master) ─────────────────────────────────────────────────────
  i2c_master dut (
    .clk    (clk),
    .rst_n  (rst_n),
    .start  (1'b0),
    .stop   (1'b0),
    .addr   (7'h0),
    .rw     (1'b0),
    .wdata  (8'h0),
    .rdata  (),
    .done   (),
    .ack_err(),
    .scl    (i2c_if_inst.scl),
    .sda    (i2c_if_inst.sda)
  );

  // ─── Set interface into UVM config DB ─────────────────────────────────────
  initial begin
    uvm_config_db #(virtual i2c_if)::set(null, "uvm_test_top.env.agent.*", "vif", i2c_if_inst);
  end

  // ─── Start UVM ────────────────────────────────────────────────────────────
  initial begin
    run_test();
  end

  // ─── Wave dump ────────────────────────────────────────────────────────────
  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0, i2c_tb_top);
  end

endmodule : i2c_tb_top

//------------------------------------------------------------------------------
// I2C Master Controller (DUT)
//   - Placeholder — replace with actual RTL
//------------------------------------------------------------------------------

module i2c_master (
  input  logic       clk,
  input  logic       rst_n,
  // Control / status interface
  input  logic       start,
  input  logic       stop,
  input  logic [6:0] addr,
  input  logic       rw,
  input  logic [7:0] wdata,
  output logic [7:0] rdata,
  output logic       done,
  output logic       ack_err,
  // I2C bus
  inout  wire        scl,
  inout  wire        sda
);

  // ─── TODO: Implement I2C master FSM ──────────────────────────────────────

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done    <= 1'b0;
      ack_err <= 1'b0;
      rdata   <= '0;
    end else begin
      // Placeholder: pulse done on start
      done <= start;
    end
  end

  // Tristate drivers (placeholder)
  assign scl = 1'bz;
  assign sda = 1'bz;

endmodule : i2c_master

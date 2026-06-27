//------------------------------------------------------------------------------
// I2C Interface
//   - Connects DUT pins to the UVM testbench
//   - Includes clocking blocks for driver / monitor synchronization
//------------------------------------------------------------------------------

interface i2c_if (input bit clk, input bit rst_n);

  // ─── I2C Signals ──────────────────────────────────────────────────────────
  logic        scl;          // Serial clock (master drives)
  wire         sda;          // Serial data (bidirectional, open-drain)

  // ─── SDA control (tri-state) ──────────────────────────────────────────────
  logic        sda_drive;    // Value to drive when sda_en is high
  logic        sda_en;       // Enable: 1=drive, 0=high-Z
  assign sda = sda_en ? sda_drive : 1'bz;

  // ─── Clocking block: Driver (master) ─────────────────────────────────────
  clocking drv_cb @(posedge clk);
    output scl, sda_drive, sda_en;
    input  sda;
  endclocking : drv_cb

  // ─── Clocking block: Monitor ─────────────────────────────────────────────
  clocking mon_cb @(posedge clk);
    input scl, sda;
  endclocking : mon_cb

  // ─── Modports ─────────────────────────────────────────────────────────────
  modport driver_mp  (clocking drv_cb,  input clk, rst_n);
  modport monitor_mp (clocking mon_cb,  input clk, rst_n);

  // ─── Assertions (placeholder) ─────────────────────────────────────────────
  // TODO: Add I2C protocol assertions
  // - START condition: SDA falling while SCL high
  // - STOP condition:  SDA rising while SCL high
  // - SCL period / duty cycle checks

endinterface : i2c_if

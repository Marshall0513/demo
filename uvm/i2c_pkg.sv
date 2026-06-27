//------------------------------------------------------------------------------
// I2C UVM Testbench Package
//   - Compile all UVM components in the correct order
//------------------------------------------------------------------------------

package i2c_pkg;

  // UVM library (imported by simulator via compile switch)
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // ─── Transaction ────────────────────────────────────────────────────────
  `include "../uvm/i2c_transaction.sv"

  // ─── Agent components ───────────────────────────────────────────────────
  `include "../uvm/agent/i2c_sequencer.sv"
  `include "../uvm/agent/i2c_driver.sv"
  `include "../uvm/agent/i2c_monitor.sv"

  // ─── Environment components ─────────────────────────────────────────────
  `include "../uvm/env/i2c_agent.sv"
  `include "../uvm/env/i2c_coverage.sv"
  `include "../uvm/env/i2c_ref_model.sv"
  `include "../uvm/env/i2c_scoreboard.sv"
  `include "../uvm/env/i2c_env.sv"

  // ─── Sequences ──────────────────────────────────────────────────────────
  `include "../uvm/seq/i2c_base_seq.sv"
  `include "../uvm/seq/i2c_simple_seq.sv"

  // ─── Tests ──────────────────────────────────────────────────────────────
  `include "../uvm/test/i2c_base_test.sv"
  `include "../uvm/test/i2c_simple_test.sv"

endpackage : i2c_pkg

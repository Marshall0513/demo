//------------------------------------------------------------------------------
// I2C Base Test
//------------------------------------------------------------------------------

class i2c_base_test extends uvm_test;

  `uvm_component_utils(i2c_base_test)

  // Environment ──────────────────────────────────────────────────────────────
  i2c_env env;

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // ─── Build phase ──────────────────────────────────────────────────────────
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = i2c_env::type_id::create("env", this);
  endfunction : build_phase

  // ─── End-of-test phase ────────────────────────────────────────────────────
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

endclass : i2c_base_test

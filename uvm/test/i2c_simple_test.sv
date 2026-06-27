//------------------------------------------------------------------------------
// I2C Simple Test
//   - Runs the I2C simple sequence on the agent's sequencer
//------------------------------------------------------------------------------

class i2c_simple_test extends i2c_base_test;

  `uvm_component_utils(i2c_simple_test)

  function new(string name = "i2c_simple_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // ─── Run phase ────────────────────────────────────────────────────────────
  virtual task run_phase(uvm_phase phase);
    i2c_simple_seq seq;

    phase.raise_objection(this);

    seq = i2c_simple_seq::type_id::create("seq");
    seq.randomize();
    seq.start(env.agent.sequencer);

    phase.drop_objection(this);
  endtask : run_phase

endclass : i2c_simple_test

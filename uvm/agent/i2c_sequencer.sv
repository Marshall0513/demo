//------------------------------------------------------------------------------
// I2C Sequencer
//------------------------------------------------------------------------------

class i2c_sequencer extends uvm_sequencer #(i2c_transaction);

  `uvm_component_utils(i2c_sequencer)

  function new(string name = "i2c_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass : i2c_sequencer

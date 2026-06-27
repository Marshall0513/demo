//------------------------------------------------------------------------------
// I2C Agent
//   - Encapsulates driver, sequencer, monitor
//   - Active mode:  driver + sequencer + monitor
//   - Passive mode: monitor only
//------------------------------------------------------------------------------

class i2c_agent extends uvm_agent;

  `uvm_component_utils(i2c_agent)

  // Agent components ─────────────────────────────────────────────────────────
  i2c_driver     driver;
  i2c_sequencer  sequencer;
  i2c_monitor    monitor;

  // Configuration ────────────────────────────────────────────────────────────
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // ─── Build phase ──────────────────────────────────────────────────────────
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    monitor = i2c_monitor::type_id::create("monitor", this);

    if (is_active == UVM_ACTIVE) begin
      driver    = i2c_driver::type_id::create("driver", this);
      sequencer = i2c_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  // ─── Connect phase ────────────────────────────────────────────────────────
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Driver pulls from sequencer via TLM port (built into uvm_driver)
  endfunction : connect_phase

endclass : i2c_agent

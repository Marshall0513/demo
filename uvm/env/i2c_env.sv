//------------------------------------------------------------------------------
// I2C UVM Environment
//   - Top-level environment that instantiates and connects:
//       agent → reference model → scoreboard → coverage
//------------------------------------------------------------------------------

class i2c_env extends uvm_env;

  `uvm_component_utils(i2c_env)

  // Environment components ───────────────────────────────────────────────────
  i2c_agent       agent;
  i2c_ref_model   ref_model;
  i2c_scoreboard  scoreboard;
  i2c_coverage    coverage;

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // ─── Build phase ──────────────────────────────────────────────────────────
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent      = i2c_agent::type_id::create("agent", this);
    ref_model  = i2c_ref_model::type_id::create("ref_model", this);
    scoreboard = i2c_scoreboard::type_id::create("scoreboard", this);
    coverage   = i2c_coverage::type_id::create("coverage", this);
  endfunction : build_phase

  // ─── Connect phase ────────────────────────────────────────────────────────
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Agent monitor → Reference model
    agent.monitor.mon_ap.connect(ref_model.rm_export);

    // Agent monitor → Scoreboard (actual)
    agent.monitor.mon_ap.connect(scoreboard.sb_actual_export);

    // Reference model → Scoreboard (expected)
    ref_model.rm_ap.connect(scoreboard.sb_expected_export);

    // Agent monitor → Coverage
    agent.monitor.mon_ap.connect(coverage.analysis_export);
  endfunction : connect_phase

endclass : i2c_env

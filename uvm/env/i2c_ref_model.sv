//------------------------------------------------------------------------------
// I2C Reference Model
//   - Behaves as an I2C slave device
//   - Receives transactions from master agent monitor
//   - Emits predicted transaction to scoreboard
//------------------------------------------------------------------------------

class i2c_ref_model extends uvm_component;

  `uvm_component_utils(i2c_ref_model)

  // Ports ────────────────────────────────────────────────────────────────────
  uvm_analysis_export #(i2c_transaction) rm_export;
  uvm_analysis_port  #(i2c_transaction)  rm_ap;

  // Internal fifo for analysis
  uvm_tlm_analysis_fifo #(i2c_transaction) rm_fifo;

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_ref_model", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // ─── Build phase ──────────────────────────────────────────────────────────
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rm_export = new("rm_export", this);
    rm_ap     = new("rm_ap", this);
    rm_fifo   = new("rm_fifo", this);
  endfunction : build_phase

  // ─── Connect phase ────────────────────────────────────────────────────────
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm_export.connect(rm_fifo.analysis_export);
  endfunction : connect_phase

  // ─── Run phase ────────────────────────────────────────────────────────────
  // TODO: Implement reference model logic
  //   - Pop transactions from rm_fifo
  //   - Execute the I2C slave behavior model
  //   - Write expected result to rm_ap
  task run_phase(uvm_phase phase);
    i2c_transaction tr;
    forever begin
      rm_fifo.get(tr);
      // TODO: process transaction through reference model
      `uvm_info(get_type_name(), $sformatf("RM received: %s", tr.convert2string()), UVM_MEDIUM)

      // Forward predicted result
      rm_ap.write(tr);
    end
  endtask : run_phase

endclass : i2c_ref_model

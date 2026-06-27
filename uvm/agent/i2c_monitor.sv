//------------------------------------------------------------------------------
// I2C Monitor
//   - Observes I2C bus transactions on the virtual interface
//   - Publishes collected transactions to the analysis port
//------------------------------------------------------------------------------

class i2c_monitor extends uvm_monitor;

  `uvm_component_utils(i2c_monitor)

  // Virtual interface ────────────────────────────────────────────────────────
  virtual i2c_if vif;

  // Analysis port (broadcast to env / scoreboard / coverage) ─────────────────
  uvm_analysis_port #(i2c_transaction) mon_ap;

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // ─── Build phase ──────────────────────────────────────────────────────────
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
    if (!uvm_config_db #(virtual i2c_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "i2c_monitor: vif not found in config DB")
  endfunction : build_phase

  // ─── Run phase ────────────────────────────────────────────────────────────
  task run_phase(uvm_phase phase);
    monitor_bus();
  endtask : run_phase

  // ─── Monitor the I2C bus forever ─────────────────────────────────────────
  // TODO: Implement I2C protocol monitoring (detect START, sample address,
  //       data, ACK, STOP)
  task monitor_bus();
    i2c_transaction tr;
    forever begin
      // Wait for START condition
      // @(posedge vif.sda iff (vif.sda == 0 && vif.scl == 1));

      tr = i2c_transaction::type_id::create("tr");

      // Sample address + R/W
      // for (int i = 6; i >= 0; i--) begin
      //   @(posedge vif.scl); tr.addr[i] = vif.sda;
      // end
      // @(posedge vif.scl); tr.read_not_write = vif.sda;

      // Sample ACK
      // @(posedge vif.scl); tr.ack[0] = vif.sda;

      // Sample data bytes
      // foreach (tr.data[i]) begin
      //   for (int b = 7; b >= 0; b--) begin
      //     @(posedge vif.scl); tr.data[i][b] = vif.sda;
      //   end
      //   @(posedge vif.scl); tr.ack[i] = vif.sda;
      // end

      // Detect STOP
      // @(negedge vif.sda iff (vif.sda == 1 && vif.scl == 1));

      mon_ap.write(tr);
      `uvm_info(get_type_name(), $sformatf("Monitored: %s", tr.convert2string()), UVM_MEDIUM)
    end
  endtask : monitor_bus

endclass : i2c_monitor

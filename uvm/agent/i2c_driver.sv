//------------------------------------------------------------------------------
// I2C Driver
//   - Receives i2c_transaction from sequencer
//   - Drives virtual interface (SCL / SDA)
//------------------------------------------------------------------------------

class i2c_driver extends uvm_driver #(i2c_transaction);

  `uvm_component_utils(i2c_driver)

  // Virtual interface ────────────────────────────────────────────────────────
  virtual i2c_if vif;

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // ─── Build phase ──────────────────────────────────────────────────────────
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Retrieve virtual interface from config DB
    if (!uvm_config_db #(virtual i2c_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "i2c_driver: vif not found in config DB")
  endfunction : build_phase

  // ─── Run phase ────────────────────────────────────────────────────────────
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), $sformatf("Driving: %s", req.convert2string()), UVM_MEDIUM)
      drive_transaction(req);
      seq_item_port.item_done();
    end
  endtask : run_phase

  // ─── Drive one transaction onto the I2C bus ──────────────────────────────
  // TODO: Implement I2C protocol driving (START, address, R/W, data,
  //       ACK/NACK, STOP/RESTART)
  task drive_transaction(i2c_transaction tr);
    // ── START condition ──
    // vif.sda <= 1; vif.scl <= 1; #delay; vif.sda <= 0; #delay;

    // ── Address + R/W ──
    // for (int i = 6; i >= 0; i--) begin
    //   vif.sda <= tr.addr[i];  toggle_scl();
    // end
    // vif.sda <= tr.read_not_write;  toggle_scl();
    // sample_ack();

    // ── Data bytes ──
    // foreach (tr.data[i]) begin
    //   for (int b = 7; b >= 0; b--) begin
    //     vif.sda <= tr.data[i][b];  toggle_scl();
    //   end
    //   sample_ack();
    // end

    // ── STOP condition ──
    // vif.sda <= 0; vif.scl <= 1; #delay; vif.sda <= 1; #delay;

    `uvm_info(get_type_name(), $sformatf("Driven: %s", tr.convert2string()), UVM_HIGH)
  endtask : drive_transaction

endclass : i2c_driver

//------------------------------------------------------------------------------
// I2C Functional Coverage
//   - Collects coverage on I2C transaction fields
//------------------------------------------------------------------------------

class i2c_coverage extends uvm_subscriber #(i2c_transaction);

  `uvm_component_utils(i2c_coverage)

  // Covergroups ──────────────────────────────────────────────────────────────

  // I2C address coverage
  covergroup cg_addr;
    cp_addr: coverpoint tr.addr {
      bins known_addrs[] = { [7'h00:7'h7F] };
      bins reserved  = { 7'h00, 7'h01, 7'h02, 7'h03, 7'h04, 7'h05, 7'h06, 7'h07 };
    }
  endgroup : cg_addr

  // I2C direction coverage
  covergroup cg_dir;
    cp_dir: coverpoint tr.read_not_write;
  endgroup : cg_dir

  // I2C data value coverage
  covergroup cg_data;
    cp_byte: coverpoint tr.data[0] {
      bins zero  = { 8'h00 };
      bins ones  = { 8'hFF };
      bins other = default;
    }
    cp_len: coverpoint tr.data.size() {
      bins single = { 1 };
      bins multi  = { [2:8] };
      bins burst  = { [9:16] };
    }
  endgroup : cg_data

  // Cross coverage
  covergroup cg_addr_dir;
    cross tr.addr, tr.read_not_write;
  endgroup : cg_addr_dir

  // Transaction reference (sampled by subscriber)
  protected i2c_transaction tr;

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_coverage", uvm_component parent = null);
    super.new(name, parent);
    cg_addr    = new();
    cg_dir     = new();
    cg_data    = new();
    cg_addr_dir = new();
  endfunction : new

  // ─── Write (called when analysis port broadcasts) ─────────────────────────
  function void write(i2c_transaction t);
    tr = t;
    cg_addr.sample();
    cg_dir.sample();
    cg_data.sample();
    cg_addr_dir.sample();
  endfunction : write

  // ─── Report function ──────────────────────────────────────────────────────
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Coverage: addr=%0.2f%% dir=%0.2f%% data=%0.2f%%",
        cg_addr.get_inst_coverage(),
        cg_dir.get_inst_coverage(),
        cg_data.get_inst_coverage()), UVM_MEDIUM)
  endfunction : report_phase

endclass : i2c_coverage

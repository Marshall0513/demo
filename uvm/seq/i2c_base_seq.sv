//------------------------------------------------------------------------------
// I2C Base Sequence
//------------------------------------------------------------------------------

class i2c_base_seq extends uvm_sequence #(i2c_transaction);

  `uvm_object_utils(i2c_base_seq)

  function new(string name = "i2c_base_seq");
    super.new(name);
  endfunction : new

  // ─── Body ──────────────────────────────────────────────────────────────────
  virtual task body();
    `uvm_info(get_type_name(), "Base sequence starting", UVM_LOW)
    // Raise objection to keep simulation running
    if (starting_phase != null)
      starting_phase.raise_objection(this);
  endtask : body

  // ─── Post body ────────────────────────────────────────────────────────────
  task post();
    if (starting_phase != null)
      starting_phase.drop_objection(this);
    `uvm_info(get_type_name(), "Base sequence done", UVM_LOW)
  endtask : post

  // ─── Helper: create a simple I2C write transaction ────────────────────────
  function i2c_transaction create_write(bit [6:0] addr, bit [7:0] data[]);
    i2c_transaction tr;
    tr = i2c_transaction::type_id::create("write_tr");
    tr.addr            = addr;
    tr.read_not_write  = 0;  // write
    tr.data            = data;
    tr.phase           = I2C_START;
    return tr;
  endfunction : create_write

  // ─── Helper: create a simple I2C read transaction ─────────────────────────
  function i2c_transaction create_read(bit [6:0] addr, int num_bytes = 1);
    i2c_transaction tr;
    tr = i2c_transaction::type_id::create("read_tr");
    tr.addr            = addr;
    tr.read_not_write  = 1;  // read
    tr.data            = new[num_bytes];
    tr.phase           = I2C_START;
    return tr;
  endfunction : create_read

endclass : i2c_base_seq

//------------------------------------------------------------------------------
// I2C Simple Sequence
//   - Sends a basic write + read sequence on the I2C bus
//------------------------------------------------------------------------------

class i2c_simple_seq extends i2c_base_seq;

  `uvm_object_utils(i2c_simple_seq)

  // Randomizable fields
  rand bit [6:0] slave_addr;
  rand int       num_bytes;

  constraint c_default {
    slave_addr inside { [7'h08:7'h77] };
    num_bytes   inside { [1:4] };
  }

  function new(string name = "i2c_simple_seq");
    super.new(name);
  endfunction : new

  // ─── Body ──────────────────────────────────────────────────────────────────
  virtual task body();
    i2c_transaction tr;

    super.body();

    `uvm_info(get_type_name(), $sformatf("Starting I2C sequence: addr=0x%02x", slave_addr), UVM_LOW)

    // ── Write phase ──
    tr = create_write(slave_addr, '{8'hA5, 8'h5A, 8'hFF, 8'h00});
    `uvm_do_with(tr, { data.size() == num_bytes; })

    // ── Read phase ──
    tr = create_read(slave_addr, num_bytes);
    `uvm_do_with(tr, { data.size() == num_bytes; })

    `uvm_info(get_type_name(), "I2C sequence complete", UVM_LOW)
  endtask : body

endclass : i2c_simple_seq

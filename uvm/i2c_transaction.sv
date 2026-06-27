//------------------------------------------------------------------------------
// I2C Transaction - UVM Sequence Item
//------------------------------------------------------------------------------

typedef enum bit [1:0] {
  I2C_START  = 2'b00,
  I2C_DATA   = 2'b01,
  I2C_STOP   = 2'b10,
  I2C_RESTART = 2'b11
} i2c_phase_e;

class i2c_transaction extends uvm_sequence_item;

  // ─── I2C fields ───────────────────────────────────────────────────────────
  rand bit [6:0]  addr;          // 7-bit I2C slave address
  rand bit        read_not_write; // 1=read, 0=write
  rand bit [7:0]  data[];        // data payload
  rand int        delay;         // inter-byte delay (clocks)

  // Control / status
  bit             ack[];         // ACK per byte (driven by slave)
  i2c_phase_e     phase;         // START / DATA / STOP / RESTART

  // ─── Constraints ─────────────────────────────────────────────────────────
  constraint c_default {
    soft delay inside {[0:10]};
    data.size() inside {[1:16]};
    ack.size() == data.size();
  }

  `uvm_object_utils_begin(i2c_transaction)
    `uvm_field_int(addr,            UVM_DEFAULT)
    `uvm_field_int(read_not_write,  UVM_DEFAULT)
    `uvm_field_array_int(data,      UVM_DEFAULT)
    `uvm_field_int(delay,           UVM_DEFAULT)
    `uvm_field_array_int(ack,       UVM_DEFAULT)
    `uvm_field_enum(i2c_phase_e, phase, UVM_DEFAULT)
  `uvm_object_utils_end

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_transaction");
    super.new(name);
  endfunction : new

  // ─── Helper: string for log messages ─────────────────────────────────────
  function string convert2string();
    string s;
    s = $sformatf("addr=0x%02x %s data=%p",
                  addr, read_not_write ? "RD" : "WR", data);
    return s;
  endfunction : convert2string

endclass : i2c_transaction

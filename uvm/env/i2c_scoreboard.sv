//------------------------------------------------------------------------------
// I2C Scoreboard
//   - Compares actual DUT transactions (from agent monitor) against
//     expected transactions (from reference model)
//------------------------------------------------------------------------------

typedef enum {
  MATCH,
  MISMATCH,
  UNMATCHED_ACTUAL,
  UNMATCHED_EXPECTED
} compare_result_e;

class i2c_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(i2c_scoreboard)

  // Analysis exports ─────────────────────────────────────────────────────────
  uvm_analysis_export #(i2c_transaction) sb_actual_export;
  uvm_analysis_export #(i2c_transaction) sb_expected_export;

  // Internal fifos
  uvm_tlm_analysis_fifo #(i2c_transaction) actual_fifo;
  uvm_tlm_analysis_fifo #(i2c_transaction) expected_fifo;

  // Statistics ───────────────────────────────────────────────────────────────
  int num_matches;
  int num_mismatches;
  int num_unmatched_actual;
  int num_unmatched_expected;

  // ─── Constructor ──────────────────────────────────────────────────────────
  function new(string name = "i2c_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // ─── Build phase ──────────────────────────────────────────────────────────
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_actual_export   = new("sb_actual_export", this);
    sb_expected_export = new("sb_expected_export", this);
    actual_fifo        = new("actual_fifo", this);
    expected_fifo      = new("expected_fifo", this);
  endfunction : build_phase

  // ─── Connect phase ────────────────────────────────────────────────────────
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_actual_export.connect(actual_fifo.analysis_export);
    sb_expected_export.connect(expected_fifo.analysis_export);
  endfunction : connect_phase

  // ─── Run phase ────────────────────────────────────────────────────────────
  task run_phase(uvm_phase phase);
    compare_loop();
  endtask : run_phase

  // ─── Compare loop ─────────────────────────────────────────────────────────
  // TODO: Implement comparison logic (blocking get from both fifos)
  task compare_loop();
    i2c_transaction actual, expected;
    forever begin
      // Simplistic: compare one actual vs one expected in order
      // In real design, use a lookup table (e.g., tag by address)
      actual_fifo.get(actual);
      expected_fifo.get(expected);

      if (actual.addr == expected.addr &&
          actual.data == expected.data) begin
        num_matches++;
        `uvm_info(get_type_name(), $sformatf("MATCH [%0d]: %s",
                     num_matches, actual.convert2string()), UVM_MEDIUM)
      end else begin
        num_mismatches++;
        `uvm_error(get_type_name(), $sformatf("MISMATCH [%0d]:\n  actual=%s\n  expected=%s",
                    num_mismatches, actual.convert2string(), expected.convert2string()))
      end
    end
  endtask : compare_loop

  // ─── Report phase ─────────────────────────────────────────────────────────
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf(
        "SCB Report: MATCHES=%0d  MISMATCHES=%0d  UNMATCHED_ACT=%0d  UNMATCHED_EXP=%0d",
        num_matches, num_mismatches, num_unmatched_actual, num_unmatched_expected), UVM_LOW)
  endfunction : report_phase

endclass : i2c_scoreboard

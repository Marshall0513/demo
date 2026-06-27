#===============================================================================
# Makefile — I2C UVM Simulation
#   Targets:
#     make run          Compile & run with default test
#     make run TEST=i2c_simple_test
#     make compile      Compile only
#     make waves        View waves (Verilator: GTKWave; commercial: DVE/SimVision)
#     make clean
#===============================================================================

# ─── Simulator selection ─────────────────────────────────────────────────────
# Supported: VCS / QUESTA / VIVADO_XSIM / VERILATOR
SIM ?= VCS

# ─── Test selection ──────────────────────────────────────────────────────────
TEST ?= i2c_simple_test
SEED ?= 1

# ─── UVM verbosity ───────────────────────────────────────────────────────────
UVM_VERBOSITY ?= UVM_MEDIUM

# ─── Directories ─────────────────────────────────────────────────────────────
TB_DIR     := ../tb
UVM_DIR    := ../uvm
RTL_DIR    := ../rtl
SIM_DIR    := .

# ==============================================================================
# VCS
# ==============================================================================
ifeq ($(SIM), VCS)

VCS_FLAGS := -sverilog \
             +incdir+$(TB_DIR)+$(UVM_DIR) \
             -l vcs_compile.log \
             -timescale=1ns/1ps \
             -debug_acc+pp \
             -debug_region+cell+encrypt \
             +UVM_TESTNAME=$(TEST) \
             +UVM_VERBOSITY=$(UVM_VERBOSITY)

VCS_RUN_FLAGS := -l vcs_sim.log \
                 +ntb_random_seed=$(SEED)

vcs_compile:
	vcs $(VCS_FLAGS) \
	    $(TB_DIR)/i2c_tb_top.sv \
	    $(UVM_DIR)/i2c_pkg.sv \
	    $(RTL_DIR)/i2c_master.sv

vcs_run:
	./simv $(VCS_RUN_FLAGS)

run: vcs_compile vcs_run

endif

# ==============================================================================
# QuestaSim / Modelsim
# ==============================================================================
ifeq ($(SIM), QUESTA)

QUESTA_FLAGS := -64 -suppress 13487,30000 \
                -voptargs="+acc" \
                +UVM_TESTNAME=$(TEST) \
                +UVM_VERBOSITY=$(UVM_VERBOSITY) \
                -do "log -r /*; run -all; quit"

run:
	vlib work
	vlog -sv -work work \
	     +incdir+$(TB_DIR)+$(UVM_DIR) \
	     $(TB_DIR)/i2c_tb_top.sv \
	     $(UVM_DIR)/i2c_pkg.sv \
	     $(RTL_DIR)/i2c_master.sv
	vsim -c work.i2c_tb_top $(QUESTA_FLAGS)

endif

# ==============================================================================
# Common targets
# ==============================================================================

clean:
	rm -rf work *.log *.vcd simv* csrc *.key *.h *.daidir

.PHONY: run clean compile

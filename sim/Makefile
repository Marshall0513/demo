#===============================================================================
# Makefile — I2C UVM Simulation
#   Targets:
#     make run             Compile & run with default test
#     make run TEST=... SEED=...
#     make regress         Run regression (multiple seeds)
#     make debug           Run & open DVE/Verdi
#     make check           Parse sim log for pass/fail (exit code)
#     make clean
#===============================================================================

# ─── Simulator selection ─────────────────────────────────────────────────────
# Supported: VCS / QUESTA
SIM ?= VCS

# ─── Test selection ──────────────────────────────────────────────────────────
TEST ?= i2c_simple_test
SEED ?= 1

# ─── UVM verbosity ───────────────────────────────────────────────────────────
# UVM_NONE / UVM_LOW / UVM_MEDIUM / UVM_HIGH / UVM_FULL / UVM_DEBUG
UVM_VERBOSITY ?= UVM_MEDIUM

# ─── Additional UVM command-line options ────────────────────────────────────
# e.g. +UVM_TIMEOUT=1000000, +UVM_MAX_QUIT_COUNT=10
UVM_OPTIONS ?=

# ─── Directories ─────────────────────────────────────────────────────────────
TB_DIR     := ../tb
UVM_DIR    := ../uvm
RTL_DIR    := ../rtl
SIM_DIR    := .
LOG_DIR    := $(SIM_DIR)/logs

# ==============================================================================
# VCS
# ==============================================================================
ifeq ($(SIM), VCS)

VCS_FLAGS := -sverilog \
             +incdir+$(TB_DIR)+$(UVM_DIR) \
             -l $(SIM_DIR)/vcs_compile.log \
             -timescale=1ns/1ps \
             -full64 \
             -debug_access+all \
             -kdb \
             +define+UVM_REG_DATA_WIDTH=8 \
             +incdir+$(UVM_HOME)/src \
             $(UVM_HOME)/src/uvm.sv

VCS_RUN_FLAGS := -l $(LOG_DIR)/$(TEST)_seed$(SEED).log \
                 +ntb_random_seed=$(SEED) \
                 +UVM_TESTNAME=$(TEST) \
                 +UVM_VERBOSITY=$(UVM_VERBOSITY) \
                 $(UVM_OPTIONS)

# ─── Compile ─────────────────────────────────────────────────────────────────
vcs_compile: | $(LOG_DIR)
	cd $(SIM_DIR) && vcs $(VCS_FLAGS) \
	    $(TB_DIR)/i2c_tb_top.sv \
	    $(UVM_DIR)/i2c_pkg.sv \
	    $(RTL_DIR)/i2c_master.sv

# ─── Run ─────────────────────────────────────────────────────────────────────
vcs_run: | $(LOG_DIR)
	cd $(SIM_DIR) && ./simv $(VCS_RUN_FLAGS)
	$(MAKE) check

# ─── Compile + Run ───────────────────────────────────────────────────────────
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
                $(UVM_OPTIONS)

QUESTA_DO_CMD := "log -r /*; run -all; quit"

vlog_compile: | $(LOG_DIR)
	vlib $(SIM_DIR)/work
	vlog -sv -work $(SIM_DIR)/work \
	     +incdir+$(TB_DIR)+$(UVM_DIR) \
	     $(TB_DIR)/i2c_tb_top.sv \
	     $(UVM_DIR)/i2c_pkg.sv \
	     $(RTL_DIR)/i2c_master.sv

vsim_run: | $(LOG_DIR)
	vsim -c work.i2c_tb_top $(QUESTA_FLAGS) \
	     -do $(QUESTA_DO_CMD) \
	     -l $(LOG_DIR)/$(TEST)_seed$(SEED).log

run: vlog_compile vsim_run

endif

# ==============================================================================
# Post-run check — parse log for UVM errors
# ==============================================================================
CHECK_LOG = $(LOG_DIR)/$(TEST)_seed$(SEED).log

check:
	@echo "══════════════════════════════════════════════════"
	@echo " Checking: $(TEST)  seed=$(SEED)"
	@echo " Log:      $(CHECK_LOG)"
	@echo "══════════════════════════════════════════════════"
	@grep -q "UVM_FATAL\|UVM_ERROR" $(CHECK_LOG) 2>/dev/null && \
	  (echo " ❌ FAIL — UVM_ERROR/FATAL found" && exit 1) || \
	  (echo " ✅ PASS — No UVM_ERROR/FATAL" && exit 0)

# ==============================================================================
# Debug — compile with full debug and open DVE
# ==============================================================================
DEBUG_LOG = $(LOG_DIR)/$(TEST)_debug_seed$(SEED).log

debug: vcs_compile
	cd $(SIM_DIR) && ./simv $(VCS_RUN_FLAGS) -l $(DEBUG_LOG) -gui &

# ==============================================================================
# Regression — run same test with multiple seeds
# ==============================================================================
SEEDS ?= 1 2 3 4 5 10 50 100

regress: REGRESS_LOG := $(LOG_DIR)/regression_$(TEST).log
regress: | $(LOG_DIR)
	@rm -f $(REGRESS_LOG)
	@echo "Regression: $(TEST)" | tee -a $(REGRESS_LOG)
	@echo "═══════════════════════════════════" | tee -a $(REGRESS_LOG)
	@total=0; pass=0; fail=0; \
	for s in $(SEEDS); do \
	  total=$$((total+1)); \
	  echo -n "  seed=$$s ... "; \
	  $(MAKE) run TEST=$(TEST) SEED=$$s SIM=$(SIM) 2>&1 >> $(REGRESS_LOG); \
	  if [ $$? -eq 0 ]; then \
	    echo "✅ PASS"; pass=$$((pass+1)); \
	  else \
	    echo "❌ FAIL"; fail=$$((fail+1)); \
	  fi; \
	done; \
	echo "═══════════════════════════════════" | tee -a $(REGRESS_LOG); \
	echo " Total: $$total  Pass: $$pass  Fail: $$fail" | tee -a $(REGRESS_LOG)

# ==============================================================================
# Log directory
# ==============================================================================
$(LOG_DIR):
	mkdir -p $(LOG_DIR)

# ==============================================================================
# Clean
# ==============================================================================
clean:
	rm -rf $(SIM_DIR)/simv* $(SIM_DIR)/csrc $(SIM_DIR)/DVEfiles \
	       $(SIM_DIR)/vc_hdrs.h $(SIM_DIR)/*.key $(SIM_DIR)/*.log \
	       $(SIM_DIR)/work $(SIM_DIR)/transcript $(SIM_DIR)/*.vstf \
	       $(SIM_DIR)/urgReport $(LOG_DIR)
	$(MAKE) -C $(TB_DIR) clean 2>/dev/null; true

distclean: clean
	rm -rf $(LOG_DIR)

.PHONY: run compile vcs_compile vcs_run check debug regress clean distclean

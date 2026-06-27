#!/bin/bash
#===============================================================================
# Regression Runner — I2C UVM
#   Usage:
#     ./regress.sh                          # Run all tests, all seeds
#     ./regress.sh -t i2c_simple_test       # Specific test
#     ./regress.sh -s 5                     # Loop 5 times instead of seed list
#     ./regress.sh -f                       # Fast mode (1 seed per test)
#===============================================================================

SIM=${SIM:-VCS}
SEEDS=(1 2 3 5 10 50 100)
TESTS=(
  i2c_simple_test
)
LOOP_COUNT=0
FAST=0

while [[ $# -gt 0 ]]; do
  case $1 in
    -t) TESTS=("$2");       shift 2 ;;
    -s) LOOP_COUNT=$2;      shift 2 ;;
    -f) FAST=1;             shift  ;;
    *)  echo "Unknown: $1"; exit 1 ;;
  esac
done

if [ $FAST -eq 1 ]; then
  SEEDS=(1)
fi

PASS=0
FAIL=0
TOTAL=0

for test in "${TESTS[@]}"; do
  if [ $LOOP_COUNT -gt 0 ]; then
    echo "═══ Loop mode: $LOOP_COUNT iterations of $test ═══"
    for ((i=1; i<=LOOP_COUNT; i++)); do
      TOTAL=$((TOTAL+1))
      echo -n "[$TOTAL] $test seed=$i ... "
      make run TEST=$test SEED=$i SIM=$SIM -s 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✅ PASS"; PASS=$((PASS+1))
      else
        echo "❌ FAIL"; FAIL=$((FAIL+1))
      fi
    done
  else
    for seed in "${SEEDS[@]}"; do
      TOTAL=$((TOTAL+1))
      echo -n "[$TOTAL] $test seed=$seed ... "
      make run TEST=$test SEED=$seed SIM=$SIM -s 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✅ PASS"; PASS=$((PASS+1))
      else
        echo "❌ FAIL"; FAIL=$((FAIL+1))
      fi
    done
  fi
done

echo "═══════════════════════════════════════"
echo "  Total: $TOTAL  Pass: $PASS  Fail: $FAIL"
echo "═══════════════════════════════════════"
exit $FAIL

#!/bin/bash
set -euo pipefail

OUT=/tmp/vllm_profile

ncu --section LaunchStats \
    --target-processes all \
    --profile-from-start on \
    -o vllm_profile -f \
    python run_inference.py

ncu --replay-mode kernel --target-processes all --launch-count 1 \
  --profile-from-start on --csv --print-kernel-base demangled \
  bash -lc 'python vllm_profile.py >/dev/null 2>&1' \
  | awk -F',' 'NR>1 && $4!="" {gsub(/^"|"$/,"",$4); print $4}' \
  | sort -u

echo "Nsight Compute report is at: ${OUT}.ncu-rep"
echo "Top kernels:"

ncu --import "${OUT}.ncu-rep" --page summary | head -80 || true

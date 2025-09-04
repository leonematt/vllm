#!/bin/bash
set -euo pipefail

OUT=/tmp/vllm_profile

# Collect report
ncu --section LaunchStats \
    --target-processes all \
    --profile-from-start on \
    -o "$OUT" -f \
    python run_inference.py

echo "Nsight Compute report is at: ${OUT}.ncu-rep"

echo
echo "Top kernels (mangled):"
ncu --import "${OUT}.ncu-rep" \
    --csv \
    --print-kernel-base mangled \
| tail -n +2 | cut -d',' -f5 | tr -d '"' | sort -u

echo
echo "Top kernels (demangled):"
ncu --import "${OUT}.ncu-rep" \
    --csv \
    --print-kernel-base demangled \
| tail -n +2 | cut -d',' -f5 | tr -d '"' | sort -u

echo
echo "Summary:"
ncu --import "${OUT}.ncu-rep" --page summary | head -80 || true

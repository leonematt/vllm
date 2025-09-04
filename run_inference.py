#!/usr/bin/env python3

import os
import sys

if os.getcwd() in sys.path:
    sys.path.remove(os.getcwd())

os.environ.setdefault("VLLM_USE_V1", "0")
os.environ.setdefault("VLLM_USE_CUDAGRAPH", "0")  # no cuda graphs

from vllm import LLM, SamplingParams

print("Loading model...")
llm = LLM(
    "llama-3.2-3b-instruct-hf",
    gpu_memory_utilization=0.5,
    max_model_len=512,
    enforce_eager=True,
)

print("Running inference...")
outs = llm.generate(["What is software?"], SamplingParams(max_tokens=10, temperature=0.7))
print("Generated:", outs[0].outputs[0].text)
print("Done.")

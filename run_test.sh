export VLLM_ATTENTION_BACKEND=FLASH_ATTN
export VLLM_USE_FLASHINFER=0
export VLLM_USE_TRITON_FLASH_ATTN=0
# If you only instrumented FA2 or FA3, force it:
# export VLLM_FLASH_ATTN_VERSION=2   # or 3

python run_inference.py
 
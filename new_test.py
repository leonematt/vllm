from vllm import LLM, SamplingParams
import gc
import signal
import sys

def signal_handler(sig, frame):
    print('\nGracefully shutting down...')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

try:
    # Initialize with slightly lower GPU memory to avoid cleanup issues
    llm = LLM('llama-3.2-3b-instruct-hf', 
              gpu_memory_utilization=0.7, 
              max_model_len=4096)
    
    # Generate with your sampling parameters
    sampling_params = SamplingParams(max_tokens=300, temperature=0.7)
    outputs = llm.generate(['What is machine learning?'], sampling_params)
    
    # Print results
    print('✅ Compiled vLLM works:', outputs[0].outputs[0].text)
    
finally:
    # Proper cleanup to prevent engine shutdown errors
    try:
        del llm
    except:
        pass
    gc.collect()
    print("🧹 Cleanup completed")

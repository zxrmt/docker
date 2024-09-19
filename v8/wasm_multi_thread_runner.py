import os
import random
import glob
import multiprocessing
import time
import sys

FILELIST = glob.glob(sys.argv[1])
BINARY = "/v8/out/cov/d8"
COMPILE_DIR = "/v8/out/cov/"
RUNNER_JS = "/root/zx/wasm_runner.js"
PWD = os.getcwd() 
os.environ["LLVM_PROFILE_FILE"] = "/root/cov.%4m%c.profraw"

def extract_coverage(files):
    processed = 0
    for file_name in files:
        os.system(f"{BINARY} {RUNNER_JS} -- {file_name} ")
        processed += 1
        if processed % 10 == 0:
            print(processed, len(files))

# Create threads to process the files
size =len(FILELIST)
print("Total", size)
step = 200
args_list = []
for i in range(0,size, step):
    x = i
    args_list.append(FILELIST[x:x+step])
print(len(args_list))

processes = []
for arg in args_list:
    p = multiprocessing.Process(target=extract_coverage, args=(arg,))
    processes.append(p)
    p.start()

# Wait for all processes to finish
for p in processes:
    p.join()

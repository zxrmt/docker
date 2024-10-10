import os
import random
import glob
import multiprocessing
import time

FILELIST = glob.glob("/root/zx/output/*")
BINARY = "/v8/out/cov/d8"
COMPILE_DIR = "/v8/out/cov"
PWD = os.getcwd()

os.system("mkdir -p test/mjsunit/wasm/")
os.system("mkdir -p /v8/v8/test/mjsunit/wasm/")
os.system("cp /root/zx/wasm-module-builder.js test/mjsunit/wasm/")
os.system("cp /root/zx/wasm-module-builder.js /v8/v8/test/mjsunit/wasm/")

def extract_coverage(files):
    for file_name in files:
        print("Processing ",file_name)
        PATH = f"{PWD}/cov{random.randint(0, 1000000) * time.time()}"

        os.environ["LLVM_PROFILE_FILE"] = f"{PATH}/cov.%4m%c.profraw"

        os.system(f"mkdir {PATH}")
        # cp /root/final_corpus/0 /root/cov0/0
        os.system(f"cp {file_name} {PATH}/")

        os.system(f"timeout 0.5 {BINARY} {file_name}")
        print("Merge cove data")
        #llvm-profdata-19 merge -o /root/coverage.profdata /root/*.profraw\n
        os.system(f"llvm-profdata-20 merge -o {PATH}/coverage.profdata {PATH}/*.profraw")

        print("Export cov")
        os.system(f"llvm-cov-20 export -instr-profile={PATH}/coverage.profdata {BINARY} -format=lcov -compilation-dir={COMPILE_DIR} /v8/src/wasm > {PATH}/coverage.info")
        #./minimize cov0/coverage.info cov0/minimized.coverage.info\n
        os.system(f"/root/zx/minimize {PATH}/coverage.info {PATH}/minimized.coverage.info")
        os.system(f"rm -rf {PATH}/*.profraw")
        os.system(f"rm -rf {PATH}/*.profdata")
        os.system(f"rm -rf {PATH}/coverage.info")
        os.system(f"rm core*")



# Create threads to process the files
size =len(FILELIST)
print("Total", size)
step = 200
args_list = []
for i in range(0,size, step):
    x = i
    args_list.append(FILELIST[x:x+step])
print(len(args_list))
if 1:
    processes = []
    for arg in args_list:
        p = multiprocessing.Process(target=extract_coverage, args=(arg,))
        processes.append(p)
        p.start()

    # Wait for all processes to finish
    for p in processes:
        p.join()
else:
    processFiles(sys.argv[1] + "/0")

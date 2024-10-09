export LLVM_PROFILE_FILE="/root/cov.%4m%c.profraw"
mkdir -p test/mjsunit/wasm/
mkdir -p /v8/v8/test/mjsunit/wasm/

cp /root/zx/wasm-module-builder.js test/mjsunit/wasm/
cp /root/zx/wasm-module-builder.js /v8/v8/test/mjsunit/wasm/
for f in /root/zx/output/* ; do
        echo $f
#if [ ${f:-5} == ".wasm" ]; then
#    /v8/out/cov/d8 --allow-natives-syntax --future --wasm-staging /root/zx/wasm_runner.js -- $f;
#else
    timeout 1 /v8/out/cov/d8 --allow-natives-syntax --future --wasm-staging $f;
#fi
done

llvm-profdata-20  merge -o /root/coverage.profdata /root/*.profraw
llvm-cov-20 show -output-dir=/root/zx/cov -instr-profile=/root/coverage.profdata /v8/out/cov/d8  -format=html -compilation-dir=/v8/out/cov
llvm-cov-20 report -instr-profile=/root/coverage.profdata /v8/out/cov/d8 > /root/zx/report.txt

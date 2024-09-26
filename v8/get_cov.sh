export LLVM_PROFILE_FILE="/root/cov.%4m%c.profraw"
for f in /root/zx/minimize/*.wasm; do /v8/out/cov/d8 --allow-natives-syntax --future --wasm-staging /root/zx/wasm_runner.js -- $f;done
llvm-profdata-20  merge -o /root/coverage.profdata /root/*.profraw
llvm-cov-20 show -output-dir=/root/cov -instr-profile=/root/coverage.profdata /v8/out/cov/d8  -format=html -compilation-dir=/v8/out/cov
llvm-cov-20 report -instr-profile=/root/coverage.profdata /v8/out/cov/d8 > /root/zx/report.txt

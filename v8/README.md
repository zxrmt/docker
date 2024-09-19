```bash
export LLVM_PROFILE_FILE="/root/cov.%4m%c.profraw"
for r in /root/minimize/*; do /v8/v8/out/cov/d8 --allow-natives-syntax /root/test.js -- $f;done
llvm-profdata-20  merge -o /root/coverage.profdata /root/*.profraw
llvm-cov-20 show -output-dir=/root/cov -instr-profile=/root/coverage.profdata /v8/out/cov/d8  -format=html -compilation-dir=/v8/out/cov
llvm-cov-20 report -instr-profile=/root/coverage.profdata /v8/out/cov/d8
```

```
 - Filename          Regions    Missed Regions     Cover   Functions  Missed Functions  Executed       Lines      Missed Lines     Cover    Branches   Missed Branches     Cover
 - TOTAL              983004            917748     6.64%       75910             67585    10.97%      777498            728172     6.34%      429144            411226     4.18%#1 file
 - TOTAL              983004            919664     6.44%       75910             67832    10.64%      777498            730065     6.10%      429144            411849     4.03%
```

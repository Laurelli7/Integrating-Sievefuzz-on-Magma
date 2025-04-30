#!/bin/bash
set -e 

export FUZZER="$FUZZER/repo"
export EVAL_DATA="$FUZZER/eval/data"
export BENCHMARKS="$FUZZER/benchmarks"
export PREP="$FUZZER/eval/prep_target.sh"
export NAME=$(basename "$TARGET")

echo "[*] instrument.sh"
echo "    FUZZER = $FUZZER"
echo "    TARGET = $TARGET"
echo "    MAGMA  = $MAGMA"
echo "    OUT    = $OUT"


echo "[*] placing $TARGET → $EVAL_DATA"
cp -r "$TARGET" $EVAL_DATA

echo "[*] building target for sievefuzz"

export OUT="$OUT/sievefuzz"
mkdir -p "$OUT"
export LDFLAGS="-L$OUT $LDFLAGS"

"$MAGMA/build.sh"
sed -i 's|\$DATA/sievefuzz_setup\.sh|"$TARGET/build.sh"|' $PREP
echo "[*] finishing magam build"

OUTDIR="$BENCHMARKS/out_${NAME}/sievefuzz/bin"
BITCODE_DIR="$BENCHMARKS/out_${NAME}/BITCODE"
mkdir -p "$BITCODE_DIR"
mkdir -p "$(dirname "$OUTDIR")"
# don't need to put target in eval/data anymore just put the built target binary in benchmark/out_target/sievefuzz/bin                                
rm -rf "$OUTDIR"
ln -s "$OUT" "$OUTDIR" 

ENTRY="locs[\"$NAME\"]=\"$BITCODE_DIR/$NAME\""

grep -qxF "$ENTRY" "$PREP" || echo "$ENTRY" >> "$PREP"
echo "[*] finish updating prep_target.sh"


bash "$PREP" "$TARGET" bitcode
echo "[*] finishing prep_target.sh bitcode"

bash "$PREP" "$TARGET" sievefuzz
echo "[*] finishing prep_target.sh sievefuzz"

CONFIG="$FUZZER/eval/$NAME.config"
SEED=$(basename "$PROGRAM")
echo "[*] writing config → $CONFIG"
mkdir -p "$SHARED/findings"
mkdir -p "$(dirname "$CONFIG")"  
cat > "$CONFIG" << EOJ
[
  {
    "mode": "sievefuzz",
    "static": "$FUZZER/third_party/SVF/Release-build/bin/svf-ex",
    "get_indirect": "true",
    "fn_indices": "$BENCHMARKS/out_${NAME}/sievefuzz/fn_indices.txt",
    "bitcode": "$BITCODE_DIR/$NAME",
    "tagdir": "$FUZZER/results/$NAME/sievefuzz",
    "dump_stats": "true",
    "function": "cgc_process_msg",
    "input": "$TARGET/corpus/$SEED",
    "target": "$OUTDIR",
    "cmdline": "",
    "output": "$SHARED/findings",
    "fuzztimeout": "300",
    "fuzzer": "$FUZZER/repo/third_party/sievefuzz/afl-fuzz",
    "jobcount": 1,
    "start_port": 6200,
    "afl_margs": "",
    "mem_limit": "none",
    "env": {"AFL_NO_UI":"1"}
  }
]
EOJ

echo "[*] finish updating config"

echo "[*] finishing instrument.sh"

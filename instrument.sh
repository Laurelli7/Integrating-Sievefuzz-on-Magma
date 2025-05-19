#!/bin/bash
set -e 
export PREP="$FUZZER/prep_target.sh"

export NAME=$(basename "$TARGET")

echo "[*] instrument.sh"
echo "    FUZZER = $FUZZER"
echo "    TARGET = $TARGET"
echo "    MAGMA  = $MAGMA"
echo "    OUT    = $OUT"
echo "    PREP   = $PREP"


echo "[*] building target for sievefuzz"


export LDFLAGS="-L$OUT $LDFLAGS"
"$MAGMA/build.sh"


mkdir -p "$OUT/sievefuzz"

set +e
bash "$PREP" "$TARGET" bitcode
echo "[*] finishing prep_target.sh bitcode"

bash "$PREP" "$TARGET" sievefuzz
echo "[*] finishing prep_target.sh sievefuzz"
set -e

echo "[*] finishing magam build"
CONFIG="$FUZZER/repo/eval/$NAME.config"
SEED=$(basename "$PROGRAM")
echo "[*] writing config → $CONFIG"
mkdir -p "$SHARED/findings/SVF"
mkdir -p "$(dirname "$CONFIG")" 
cat > "$CONFIG" << EOJ
[
  {
    "mode": "sievefuzz",
    "static": "$FUZZER/repo/third_party/SVF/Release-build/bin/svf-ex",
    "get_indirect": "true",
    "fn_indices": "$OUT/sievefuzz/fn_indices.txt",
    "bitcode": "$OUT/BITCODE/tiffcp.bc", #modify based on program name
    "tagdir": "$SHARED/findings/SVF",
    "dump_stats": "true",
    "function": "main", #modify based on function list
    "input": "$TARGET/corpus/tiffcp", #modify based on program name
    "target": "$OUT/tiffcp",  #modify based on program name
    "cmdline": "",
    "output": "$SHARED/findings",
    "fuzztimeout": "1800",
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

#!/bin/bash
set -e
: "${FUZZER:=/magma/fuzzers/sievefuzz}"
export FUZZER="$FUZZER/repo"
echo "[*] Cloning SieveFuzz into $FUZZER..."
git clone --depth 1 https://github.com/HexHive/SieveFuzz.git "$FUZZER"
echo "[*] Stripping sudo from setup script..."
sed -i ’s/^sudo //g’ "$FUZZER/eval/setup_fuzzer_env.sh"
echo "[*] Running fuzzer runtime setup (no sudo)..."
pushd "$FUZZER/eval" >/dev/null
./setup_fuzzer_env.sh
popd >/dev/null


echo "fetch.sh complete."

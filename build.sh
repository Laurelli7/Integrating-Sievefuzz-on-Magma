#!/bin/bash
set -e

export FUZZER="$FUZZER/repo"

echo "[*] Building SieveFuzz…"
pushd "$FUZZER" >/dev/null
./build.sh || echo "    → ignoring SVF test failures"
popd >/dev/null

echo "[*] Copying gllvm_bins…"
mkdir -p "$FUZZER/third_party/SVF/Release-build/bin"
cp "$FUZZER/gllvm_bins/"* "$FUZZER/third_party/SVF/Release-build/bin/"

echo "[*] Patching helper scripts under eval/…"
for script in prep_target.sh get_sample_target.sh sanitycheck_run.sh; do
  SCRIPT_PATH="$FUZZER/eval/$script"
  if [[ -f "$SCRIPT_PATH" ]]; then
    sed -i "s|^ROOT=.*|ROOT=\"$FUZZER\"|"         "$SCRIPT_PATH"
    sed -i "s|^TARGET_DIR=.*|TARGET_DIR=\"$FUZZER\"|" "$SCRIPT_PATH"
    sed -i "s|^OUTDIR=.*|OUTDIR=\"$FUZZER\"|"     "$SCRIPT_PATH"
    sed -i "s|^DATA=.*|DATA=\"$FUZZER\"|"         "$SCRIPT_PATH"
    echo "    → patched $script"
  fi
done

echo "[✓] build.sh complete."

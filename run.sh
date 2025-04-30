#!/bin/bash
set -e

NAME=$(basename "$TARGET")
CONFIG="$FUZZER/repo/eval/$NAME.config"


echo "[*] finish updating config"
echo "[DEBUG] TARGET is '$TARGET'"
echo "[DEBUG] FUZZER = '$FUZZER'"
echo "[DEBUG] NAME   = '$NAME'"
echo "[DEBUG] CONFIG = '$CONFIG'"


beanstalkd &    
python3 "$FUZZER/repo/eval/create_fuzz_script.py" -c "$CONFIG" -n 15 --flush
python3 "$FUZZER/repo/eval/create_fuzz_script.py" -c "$CONFIG" -n 15 --flush
python3 "$FUZZER/repo/eval/create_fuzz_script.py" -c "$CONFIG" -n 15 --flush
echo "[DEBUG] finish flushing"

python3 "$FUZZER/repo/eval/create_fuzz_script.py" -c "$CONFIG" -n 15 --put
echo "[DEBUG] finish putting"

python3 "$FUZZER/repo/eval/create_fuzz_script.py" -c "$CONFIG" -n 15 --get  
echo "[DEBUG] finish getting"

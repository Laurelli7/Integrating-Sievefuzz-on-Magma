# Integrating-Sievefuzz-on-Magma

1) Create a subdirectory sievefuzz under magma/fuzzers
2) Add those scripts to sievefuzz
3) modify the $CONFIG json file in instrument to adjust fuzzing timeout
4) Need to manually set the program name eg. tiffcp in the scripts (config and prep_target.sh)
5) Need to manually set the function name eg. main in the config

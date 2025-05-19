#!/bin/bash
set -e

export TIMELIMIT=0.1s

run_limited()
{
    ${@:1}
    test $? -lt 128
}
export -f run_limited

args="${ARGS/@@/"$1"}"
if [ -z "$args" ]; then
    args="$1"
fi

timeout -s KILL --preserve-status $TIMELIMIT bash -c \
    "run_limited '$OUT/sievefuzz/$PROGRAM' $args"

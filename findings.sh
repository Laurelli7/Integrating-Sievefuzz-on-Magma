#!/bin/bash
set -e
CRASH_DIR="$SHARED/findings"

find "$CRASH_DIR" -type f -name 'id:*' -print

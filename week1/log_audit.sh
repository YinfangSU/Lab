#!/usr/bin/env bash

set -euo pipefail

folder="${1:-}"
scanned=0
flagged=0

if [[ ! -d "$folder" ]]; then
    exit 3
fi

for file in "$folder"/*.log; do
    error_count=$(grep "ERROR" "$file" | wc -l)
    echo "$error_count errors found in $file"

if [[$error-count > 10]]; then
    flagged=$((flagged+1))
fi

log(){
    scanned=$((scanned+1))
    echo "[INFO] $*"
}
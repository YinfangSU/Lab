#!/usr/bin/env bash

set -euo pipefail

log(){
    scanned=$((scanned+1))
    echo "[INFO] $*"
}

die(){
    log "[ERROR] $1"
    exit "$2"
}

scanned=0
flagged=0

scanned=$((scanned+1))

if [[ "$#" -ne 1 ]]; then
    die "Usage: $0 <folder>" 1
fi

folder="$1"

if [[ ! -d "$folder" || ! -r "$folder" ]]; then
    exit 3
fi

for file in "$folder"/*.log; do
    error_count=$(grep "ERROR" "$file" | wc -l)
    echo "$error_count errors found in $file"

if [[ $error_count -gt 10 ]]; then
    flagged=$((flagged+1))
fi


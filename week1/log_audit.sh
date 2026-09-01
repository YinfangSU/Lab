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

# Check if the folder exists and is readable
if [[ ! -d "$folder" || ! -r "$folder" ]]; then
    die "Folder does not exist or is not readable" 3
fi

for file in "$folder"/*.log; do
    # In case there are no .log files, the loop will still run once with file set to the literal string "$folder/*.log"
    [[ -f "$file" ]] || continue

        error_count=$(grep "ERROR" "$file" | wc -l)
        echo "$error_count errors found in $file"

if [[ $error_count -gt 10 ]]; then
    flagged=$((flagged+1))
fi


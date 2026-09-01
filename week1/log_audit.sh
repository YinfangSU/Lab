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
        # Count the number of lines containing "ERROR" in the log file
        # If there is no error, we use "|| true" to prevent the script from exiting due to "set -e"
        error_count=$(grep -c "ERROR" "$file" || true)
        log "$(basename "$file"): $error_count errors"
done

if [[ "$error_count" -gt 10 ]]; then
    # Create a directory for flagged logs if it doesn't exist
    mkdir -p "$review_dir"
    # Copy the flagged log file to the review directory
    # -- "$file" is used to handle filenames like -rf or -i
    cp -- "$file" "$review_dir/"
    flagged=$((flagged+1))
    log "Scanned $scanned files, flagged $flagged files"
fi


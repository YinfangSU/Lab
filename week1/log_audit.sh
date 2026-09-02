#!/usr/bin/env bash

set -euo pipefail

log(){
    # Variable "$*" will pass to %s
    printf '[INFO] %s\n' "$*"
}

die(){
    # $1 is the first argument passed to the function, which is the error message
    log "[ERROR] $1"
    # $2 is the second argument passed to the function, which is the exit code
    exit "$2"
}

# Check if the correct number of arguments is provided
# Only one argument is expected, which is the folder to scan
if [[ "$#" -ne 1 ]]; then
    die "Usage: $0 <folder>" 2
fi

# Pass the first argument to the variable folder as the folder to scan
folder="$1"

# Check if the folder exists and is readable
if [[ ! -d "$folder" || ! -r "$folder" ]]; then
    die "Folder does not exist or is not readable" 3
fi

scanned=0
flagged=0

# Create a directory for flagged logs and save it in the variable review_dir
review_dir="$folder/review"

# Enable nullglob so that the for loop doesn't run if there are no any .log files
shopt -s nullglob

for file in "$folder"/*.log; do
    
    scanned=$((scanned+1))
    # Count the number of lines containing "ERROR" in the log file
    # If there is no error, we use "|| true" to prevent the script from exiting due to "set -e"
    error_count=$(grep -c "ERROR" "$file" || true)
    log "$(basename "$file"): $error_count errors"

    if [[ "$error_count" -gt 10 ]]; then
        # Create a directory for flagged logs if it doesn't exist
        mkdir -p "$review_dir"
        # Copy the flagged log file to the review directory
        # -- "$file" is used to handle filenames like -rf or -i
        cp -- "$file" "$review_dir/"
        flagged=$((flagged+1))
            
    fi
done

log "Scanned $scanned files, flagged $flagged files"

if [[ "$flagged" -gt 0 ]]; then
    exit 1
fi

exit 0
#!/bin/bash

time_str="$1"

# Function to convert time string to seconds
t2s() {
   sed 's/d/*24*3600 +/g; s/h/*3600 +/g; s/m/*60 +/g; s/s/\+/g; s/+[ ]*$//g' <<< "$1" | bc
}

# Call the function to get the time in seconds
time_in_seconds=$(t2s "$time_str")

# Use the sleep command with the converted time in seconds
echo "Sleeping for ${time_str}..."
echo  "Time in seconds ${time_in_seconds}..."

total_height=7000

bps=$(awk "BEGIN {printf \"%.2f\", $total_height / $time_in_seconds}")

echo "Bytes per Second (bps): $bps"

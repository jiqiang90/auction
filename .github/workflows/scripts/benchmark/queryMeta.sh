#!/bin/bash

input_duration=$1

convert_to_seconds() {
  seconds=0
  # Extract hours, minutes, and seconds from the time string using grep and sed
  hours=$(echo "$input_duration" | grep -o '[0-9]\+h' | sed 's/h//')
  minutes=$(echo "$input_duration" | grep -o '[0-9]\+m' | sed 's/m//')
  seconds=$(echo "$input_duration" | grep -o '[0-9]\+s' | sed 's/s//')
  # If hours, minutes, and/or seconds are present, calculate total seconds
  if [ -n "$hours" ]; then
    seconds=$((hours * 3600))
  fi
  if [ -n "$minutes" ]; then
    seconds=$((seconds + minutes * 60))
  fi
  if [ -n "$seconds" ]; then
    seconds=$((seconds + seconds))
  fi
  echo "$seconds"
}

# Query the database and store the result in variables
runner_node=$(psql -h postgres -d postgres -U postgres -c "SELECT value FROM app._metadata WHERE key = 'runnerNode';" | awk 'NR == 3 {print $1}' | tr -d '"')
indexer_version=$(psql -h postgres -d postgres -U postgres -c "SELECT value FROM app._metadata WHERE key = 'indexerNodeVersion';" | awk 'NR == 3 {print $1}' | tr -d '"')
start_height=$(psql -h postgres -d postgres -U postgres -c "SELECT value::integer FROM app._metadata WHERE key = 'startHeight';" | awk 'NR == 3 {print $1}')
last_processed_height=$(psql -h postgres -d postgres -U postgres -c "SELECT value::integer FROM app._metadata WHERE key = 'lastProcessedHeight';" | awk 'NR == 3 {print $1}')
total_height=$((last_processed_height-start_height+1))
time_in_seconds=$(convert_to_seconds "$input_duration")
bps=$((total_height / time_in_seconds))
# Set outputs for subsequent steps
echo "::set-output name=runner_node::$runner_node"
echo "::set-output name=indexer_version::$indexer_version"
echo "::set-output name=start_height::$start_height"
echo "::set-output name=last_processed_height::$last_processed_height"
echo "::set-output name=total_height::$total_height"
echo "::set-output name=bps::$bps"

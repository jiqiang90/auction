#!/bin/bash

# Get input parameters passed from the GitHub Action workflow
# Testing time
input_duration=$1
input_deployment=$2
input_endpoint=$3
input_batch_size=$4
input_workers=$5
input_disableHistorical=$6
input_others=$7


start_app() {
  subql-node -f ipfs://$input_deployment --network-endpoint=$input_endpoint --batch-size=$input_batch_size --workers=$input_workers --disable-historical=$input_disableHistorical $input_others --ipfs='https://unauthipfs.subquery.network/ipfs/api/v0' --output-fmt=json > indexing.log 2>&1 &
}

# Set the timeout in seconds
timeout_duration=$((input_duration * 60))

# Start the app in the background
start_app &

# Get the process ID (PID) of the app
app_pid=$!

# Wait for the app to finish or timeout
if ! timeout $timeout_duration wait $app_pid; then
  # If the timeout occurred, send a SIGTERM to the process to exit gracefully
  echo "Finishing benchmarking..."
  kill $app_pid
  # Optionally, wait for the app to exit after sending the signal
  wait $app_pid
fi

# Exit the bash script
exit 0

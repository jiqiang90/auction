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

# Start the Node.js application in the background
subql-node -f ipfs://$input_deployment --network-endpoint=$input_endpoint --batch-size=$input_batch_size --workers=$input_workers --disable-historical=$input_disableHistorical $input_others --ipfs='https://unauthipfs.subquery.network/ipfs/api/v0' --output-fmt=json > indexing.log 2>&1 &

# Get the process ID of the Node.js application
pid=$!

# Timeout value in seconds
timeout=$((input_duration * 60))

# Wait for the Node.js application to finish or timeout
timeout $timeout bash -c "while kill -0 $pid >/dev/null 2>&1; do sleep 1; done"

# Check if the process is still running
if kill -0 $pid >/dev/null 2>&1; then
  # Process is still running, so terminate it
  kill -9 $pid
  exit 0
fi

# The process finished before the timeout, so exit with the actual exit code
wait $pid
exit $?

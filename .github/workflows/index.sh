#!/bin/bash

# Get input parameters passed from the GitHub Action workflow
# Testing time
input_duration=$0
input_deployment=$1
input_endpoint=$2
input_batch_size=$3
input_workers=$4
input_disableHistorical=$5
input_others=$6

timeout_duration=$((input_duration * 60))

# Start Node.js app with input parameters and redirect logs to a file
timeout timeout_duration subql-node -f ipfs://$input_deployment --network-endpoint=$input_endpoint --batch-size=$input_batch_size --workers=$input_workers --disable-historical=$input_disableHistorical $input_others --ipfs='https://unauthipfs.subquery.network/ipfs/api/v0' --output-fmt=json > indexing.log 2>&1 &

# Wait for the app to start (adjust the sleep duration as needed)
sleep 30

# Filter logs containing "benchmark" and save to benchmark.log
grep "benchmark" indexing.log > benchmark.log

# Optionally, you can also print the filtered logs to the terminal
cat benchmark.log

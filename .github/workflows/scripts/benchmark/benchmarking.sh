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

# Clean docker container history
output_dir="/app/output/benchmark/"
. cleanHistory.sh $output_dir


echo "DB_USER: $DB_USER"
echo "DB_PASS: $DB_PASS"
echo "DB_DATABASE: $DB_DATABASE"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"

echo "Test db connection"
apt-get update
apt-get install --yes postgresql-client
psql -h "$DB_HOST" -d "$DB_DATABASE" -U "$DB_USER" -p "$DB_PORT" -c "SELECT schema_name FROM information_schema.schemata;"




# Start the Node.js app in the background and save its PID
#subql-node -f ipfs://$input_deployment --network-endpoint=$input_endpoint --batch-size=$input_batch_size --workers=$input_workers --disable-historical=$input_disableHistorical $input_others --ipfs='https://unauthipfs.subquery.network/ipfs/api/v0' --db-schema=app > /app/output/benchmark/indexing.log 2>&1 &

subql-node -f ipfs://$input_deployment --network-endpoint=$input_endpoint --debug --ipfs='https://unauthipfs.subquery.network/ipfs/api/v0' --db-schema=app > /app/output/benchmark/indexing.log 2>&1 &

APP_PID=$!


echo "Benchmarking timeout: $input_duration"
# Wait for timeout
sleep $input_duration

# Terminate the Node.js app
pkill -P $APP_PID || true

cat /app/output/benchmark/indexing.log

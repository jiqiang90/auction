FROM node:18

COPY benchmarking.sh /app/benchmarking.sh
RUN chmod +x /app/benchmarking.sh


RUN apt-get update
RUN apt-get install --yes postgresql-client
RUN psql -h "$DB_HOST" -d "$DB_DATABASE" -U "$DB_USER" -p "$DB_PORT" -c "SELECT schema_name FROM information_schema.schemata;"

# Set the entrypoint of the container
ENTRYPOINT ["/bin/bash", "/app/benchmarking.sh"]

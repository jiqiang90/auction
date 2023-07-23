FROM node:18

COPY benchmarking.sh /app/benchmarking.sh
RUN chmod +x /app/benchmarking.sh


RUN apt-get update
RUN apt-get install --yes postgresql-client
RUN psql -h postgres -d postgres -U postgres -p 5432 -c "SELECT schema_name FROM information_schema.schemata;"

# Set the entrypoint of the container
#ENTRYPOINT ["/bin/bash", "/app/benchmarking.sh"]

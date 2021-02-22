#!/usr/bin/env bash

set -e

echo "=== Hello from postgres entrypoint"
echo "=== Parameters: $*"
echo "=== Databases: ${DATABASES}"

initDatabases() {

    export PGUSER=postgres

    until psql -l &>/dev/null
    do
        echo "=== Waiting for postgres start ... "
        sleep 1
    done

    echo "=== Postgres started"

    IFS=',' read -ra DBS <<< "${DATABASES}"
    for DB_NAME in "${DBS[@]}"; do
        if ! psql -U postgres -l | awk '{print $1}' | grep "^${DB_NAME}\$" &>/dev/null; then
            echo "=== Create database: ${DB_NAME}"
            psql <<- EOSQL
    CREATE USER ${DB_NAME};
    CREATE DATABASE ${DB_NAME};
    ALTER DATABASE ${DB_NAME} OWNER TO ${DB_NAME};
    GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_NAME};
EOSQL
        fi
    done
}

init() {
    for ((i=0; i < 10; i++)) do
        initDatabases && break
    done
    /docker-entrypoint-initdb.d/setup-master.sh
    echo "=== Database is ready to serve"
}

init &

/docker-entrypoint.sh $*

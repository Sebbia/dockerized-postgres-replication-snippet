#!/bin/bash

REPLICATION_MARK="Replication enabled"

if grep "${REPLICATION_MARK}" "${PGDATA}/pg_hba.conf"; then 
    echo "=== Node is already replication master"
    exit
fi

echo "=== Setup replication master for user $PG_REP_USER ..."

echo -e "# ${REPLICATION_MARK}\nhost replication all 0.0.0.0/0 md5" >> "${PGDATA}/pg_hba.conf"

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
EOSQL

cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = hot_standby
archive_mode = on
archive_command = 'cd .'
max_wal_senders = 8
wal_keep_segments = 8
hot_standby = on
EOF

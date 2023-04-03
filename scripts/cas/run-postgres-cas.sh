#!/bin/zsh

POSTGRES=/usr/local/opt/postgresql@9.6/bin/postgres
DATA_DIR=/usr/local/var/postgresql@9.6/data
PORT_CAS=54321

$POSTGRES -D $DATA_DIR -p $PORT_CAS

# Init DB
#
# INITDB=/usr/local/opt/postgresql@9.6/bin/initdb
# $INITDB $DATA_DIR

# Run DB
#
# PGCTL=/usr/local/opt/postgresql@9.6/bin/pg_ctl
# $PGCTL -D $DATA_DIR -l logfile start

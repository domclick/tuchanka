LC_NUMERIC=en_US.UTF-8 PGUSER='heartbeat' PGPASSWORD='ChangeMe' watch -n 0.1 --exec psql -h krogan1s1 heartbeat -c "select beat from heartbeat"

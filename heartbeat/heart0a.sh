LC_NUMERIC=en_US.UTF-8 PGUSER='heartbeat' PGPASSWORD='ChangeMe' watch -n 0.1 --exec psql -p 5433 -h krogan0a heartbeat -c "update heartbeat set beat=now() returning beat"

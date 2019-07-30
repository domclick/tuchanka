LC_NUMERIC=en_US.UTF-8 watch -n 0.1 --exec psql \
	--dbname="postgresql://heartbeat:ChangeMe@krogan0a:5433/heartbeat?connect_timeout=2&application_name=heart0a.sh&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=read-write" \
	--command='update heartbeat set beat=now() returning beat' \
	--no-align --quiet --tuples-only --no-psqlrc

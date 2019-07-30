LC_NUMERIC=en_US.UTF-8 watch -n 0.1 --exec psql \
	--dbname="postgresql://heartbeat:ChangeMe@krogan1s1/heartbeat?connect_timeout=2&application_name=reader1.sh&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=any" \
	--command='select beat from heartbeat' \
	--no-align --quiet --tuples-only --no-psqlrc

# $1 cluster ID to test
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'wait_ready'
then
	function wait_ready {
		local cluster_id=$1
		local db master slaves slave date
		for db in ${cluster_dbs[${cluster_id}]}
		do
			master="${float_name[$db]}:${db_port[$db]}"
			# В случае ошибок - ожидание
			until date="$(psql --no-align --quiet --tuples-only --no-psqlrc \
				--dbname="postgresql://heartbeat:ChangeMe@${master}/heartbeat?connect_timeout=2&application_name=wait_ready.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=read-write" \
				--command="update heartbeat set beat=LOCALTIME(1) returning beat")"
			do
				sleep 5
			done
			# Убеждаемся, что БД работают, проверка репликации по любому рабу
			slaves=''
			for slave in ${db_slaves[$db]}
			do
				slaves="${slaves},${slave}:${db_port[$db]}"
			done;unset slave
			# remove leading ','
			slaves="${slaves#,}"
			if [ -n "$slaves" ]
			then
				# В случае ошибок - ожидание
				until test "$(psql --no-align --quiet --tuples-only --no-psqlrc \
					--dbname="postgresql://heartbeat:ChangeMe@${slaves}/heartbeat?connect_timeout=2&application_name=wait_ready.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=any" \
					--command="select beat>='${date}' from heartbeat")" = 't'
				do
					# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
					sleep 5
				done
			fi
		done;unset db
	}
	readonly -f wait_ready
fi

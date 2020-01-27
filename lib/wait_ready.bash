# $1 cluster to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/heartbeat.bash"
if is_function_absent 'wait_ready'
then
	function wait_ready {
		local c=$1
		local db master slaves slave date
		for db in ${cluster_dbs[$c]}
		do
			master="${float_name[$db]}:${db_port[$db]}"
			# В случае ошибок - ожидание
			until date="$(psql --no-align --quiet --tuples-only --no-psqlrc \
				--dbname="postgresql://heartbeat:ChangeMe@${master}/heartbeat?connect_timeout=2&application_name=wait_ready.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=read-write" \
				--command="select heart()")"
			do
				sleep 5
			done
			# Убеждаемся, что БД работают, проверка репликации по любому рабу
			slaves="$(slaves4URL $db)"
			if [ -n "$slaves" ]
			then
				# В случае ошибок - ожидание
				until test "$(psql --no-align --quiet --tuples-only --no-psqlrc \
					--dbname="postgresql://heartbeat:ChangeMe@${slaves}/heartbeat?connect_timeout=2&application_name=wait_ready.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=any" \
					--command="select beat()>='${date}'")" = 't'
				do
					# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
					sleep 5
				done
			fi
		done;unset db
	}
	readonly -f wait_ready
fi

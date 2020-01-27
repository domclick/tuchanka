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
			until date="$(heartbeat_psql "${master}" 'wait_ready.bash' 'read-write' 'select heart()')"
			do
				sleep 5
			done
			# Убеждаемся, что БД работают, проверка репликации по любому рабу
			slaves="$(slaves4URL $db)"
			if [ -n "$slaves" ]
			then
				# В случае ошибок - ожидание
				until test "$(heartbeat_psql "${slaves}" 'wait_ready.bash' 'any' "select beat()>='${date}'")" = 't'
				do
					# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
					sleep 5
				done
			fi
		done;unset db
	}
	readonly -f wait_ready
fi

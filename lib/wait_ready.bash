# $1 cluster to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/heartbeat.bash"
if is_function_absent 'wait_ready'
then
	function wait_ready {
		local c=$1
		local db master slaves slave date i
		for ((i=0;i<5;i++)) # several times to sure that result is stable
		do
			for db in ${cluster_dbs[$c]}
			do
				master="${float_ip[$db]}:${db_port[$db]}"
				# В случае ошибок - ожидание
				until date="$(heartbeat_psql "${master}" 'wait_ready.bash' 'read-write' 'select heart()')"
				do
					sleep 1
				done
				# Убеждаемся, что БД работают, проверка репликации по любому рабу
				slaves="$(slaves4URL $db)"
				if [ -n "$slaves" ]
				then
					# В случае ошибок - ожидание
					until test "$(heartbeat_psql "${slaves}" 'wait_ready.bash' 'any' "select beat()>='${date}'")" = 't'
					do
						# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
						sleep 1
					done
				fi
			done;unset db
			sleep 1
		done;unset i
	}
	readonly -f wait_ready
fi

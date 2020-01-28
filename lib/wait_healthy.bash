# $1 cluster to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/vm_ssh.bash"
. "${lib_dir}/wait_stable.bash"
. "${lib_dir}/heartbeat.bash"
if is_function_absent 'wait_healthy'
then
	function wait_healthy {
		local c=$1
		local db master slaves slave date h is
		# check that the cluster has all nodes
		for h in ${cluster_vms[$c]}
		do
			# Ожидание как в случае ошибок ssh так и ненулевого crm_mon
			until vm_ssh $h "/usr/sbin/crm_mon --simple-status"
			do
				sleep 5
			done;
		done;unset h
		wait_stable $c
		# Убеждаемся, что БД работают, проверка репликации по всем рабам
		for db in ${cluster_dbs[$c]}
		do
			master="${float_ip[$db]}:${db_port[$db]}"
			date="$(heartbeat_psql "${master}" 'wait_healthy.bash' 'read-write' 'select heart()')"
			if [ -n "${db_slaves[$db]}" ]
			then
				for h in ${db_slaves[$db]}
				do
					slaves+=" ${float_ip[$h]}"
				done; unset h
			else
				# По сути костыль для Tuchanka1, официальных slave там нет, но есть неофициальные
				# и их тоже, по хорошему, надо проверять в случае wait_healthy.
				# По скольку Tuchanka1 возвращается к исходному состоянию, то можно использовать
				# адреса со стадии setup при wait_healthy.
				for h in ${db_setup_slaves[$db]}
				do
					slaves+=" ${vm_ip[$h]}"
				done; unset h
			fi
			# remove leading ' '
			slaves="${slaves#' '}"
			for slave in ${slaves}
			do
				slave+=":${db_port[$db]}"
				# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
				while true
				do
					is="$(heartbeat_psql "${slave}" 'wait_healthy.bash' 'any' "select beat()>='${date}'")"
					[ "$is" = 't' ] && break
					sleep 5
				done
			done;unset slave
		done;unset db
		# History of errors must be clean
		for h in ${cluster_vms[$c]}
		do
			is="$(vm_ssh $h 'pcs resource failcount show')"
			test 'No failcounts' = "$is"
		done;unset h
	}
	readonly -f wait_healthy
fi

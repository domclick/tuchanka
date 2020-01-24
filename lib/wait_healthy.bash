# $1 cluster to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/vm_ssh.bash"
. "${lib_dir}/wait_stable.bash"
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
			master="${float_name[$db]}:${db_port[$db]}"
			date="$(psql --no-align --quiet --tuples-only --no-psqlrc \
				--dbname="postgresql://heartbeat:ChangeMe@${master}/heartbeat?connect_timeout=2&application_name=wait_healthy.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=read-write" \
				--command="select heart()")"
			if [ -n "${db_slaves[$db]}" ]
			then
				slaves="${db_slaves[$db]}"
			else
				# По сути костыль для Tuchanka1, официальных slave там нет, но есть неофициальные
				# и их тоже, по хорошему, надо проверять в случае wait_healthy.
				# По скольку Tuchanka1 возвращается к исходному состоянию, то можно использовать
				# адреса со стадии setup при wait_healthy.
				for h in ${db_setup_slaves[$db]}
				do
					slaves+=" ${vm_name[$h]}"
				done; unset h
				# remove leading ' '
				slaves="${slaves#' '}"
			fi
			for slave in ${slaves}
			do
				slave+=":${db_port[$db]}"
				# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
				while true
				do
					is="$(psql --no-align --quiet --tuples-only --no-psqlrc \
						--dbname="postgresql://heartbeat:ChangeMe@${slave}/heartbeat?connect_timeout=2&application_name=wait_healthy.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=any" \
						--command="select beat()>='${date}'")"
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

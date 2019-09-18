# $1 cluster ID to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/vm_ssh.bash"
. "${lib_dir}/wait_stable.bash"
if is_function_absent 'wait_healthy'
then
	function wait_healthy {
		local cluster_id=$1
		local db master slave date h is
		# check that the cluster has all nodes
		for h in ${cluster_vms[${cluster_id}]}
		do
			# Ожидание как в случае ошибок ssh так и ненулевого crm_mon
			until vm_ssh "$h" "/usr/sbin/crm_mon --simple-status"
			do
				sleep 5
			done;
		done;unset h
		wait_stable $cluster_id
		# Убеждаемся, что БД работают, проверка репликации по всем рабам
		for db in ${cluster_dbs[${cluster_id}]}
		do
			master="${float_name[$db]}:${db_port[$db]}"
			date="$(psql --no-align --quiet --tuples-only --no-psqlrc \
				--dbname="postgresql://heartbeat:ChangeMe@${master}/heartbeat?connect_timeout=2&application_name=wait_healthy.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=read-write" \
				--command="update heartbeat set beat=LOCALTIME(1) returning beat")"
			for slave in ${db_slaves[$db]}
			do
				slave="${slave}:${db_port[$db]}"
				# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
				while true
				do
					is="$(psql --no-align --quiet --tuples-only --no-psqlrc \
						--dbname="postgresql://heartbeat:ChangeMe@${slave}/heartbeat?connect_timeout=2&application_name=wait_healthy.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=any" \
						--command="select beat>='${date}' from heartbeat")"
					[ "$is" = 't' ] && break
					sleep 5
				done
			done;unset slave
		done;unset db
		# History of errors must be clean
		for h in ${cluster_vms[${cluster_id}]}
		do
			is="$(vm_ssh "$h" 'pcs resource failcount show')"
			test 'No failcounts' = "$is"
		done;unset h
	}
	readonly -f wait_healthy
fi

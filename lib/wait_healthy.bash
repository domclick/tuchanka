# $1 cluster ID to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/vm_ssh.bash"
. "${lib_dir}/wait_stable.bash"
if is_function_absent 'wait_healthy'
then
	function wait_healthy {
		local cluster_id=$1
		local db master slave date h
		# check that the cluster has all nodes
		for h in ${cluster_vms[${cluster_id}]}
		do
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
				--command="update heartbeat set beat=now() returning beat")"
			for slave in ${db_slaves[$db]}
			do
				slave="${slave}:${db_port[$db]}"
				until test 't' = "$(psql --no-align --quiet --tuples-only --no-psqlrc \
					--dbname="postgresql://heartbeat:ChangeMe@${slave}/heartbeat?connect_timeout=2&application_name=wait_healthy.bash&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=any" \
					--command="select beat>='${date}' from heartbeat")"
				do
					# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
					sleep 5
				done
			done;unset slave
		done;unset db
		# History of errors must be clean
		for h in ${cluster_vms[${cluster_id}]}
		do
			test 'No failcounts' = "$(vm_ssh "$h" 'pcs resource failcount show')"
		done;unset h
	}
	readonly -f wait_healthy
fi

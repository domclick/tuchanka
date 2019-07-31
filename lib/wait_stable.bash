# $1 cluster ID to test
# $2 (optional) "broken" vm, don't test
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'wait_stable'
then
	function wait_stable {
		local cluster_id="$1" broken="${2:-''}"
		local h db
		for h in ${cluster_vms[${cluster_id}]}
		do
			if [ "$h" = "$broken" ]
			then
				continue;
			fi
			# check that the cluster is stable for more then 25s
			until test $(vm_ssh "$h" "echo \$((\$(date +%s)-\$(stat --printf='%Y' '${cib}')))") -gt 25
			do
				sleep 5
			done
			# Проверка что все атрибуты отвечающие за репликацию >0 (нет ошибок репликации)
			for db in ${cluster_dbs[${cluster_id}]}
			do
				attribute="master-${float_name[${db}]}DB"
				until test $(vm_ssh "$h" "pcs node attribute '${h}' --name '${attribute}'|tail -n 1|cut -f 2 -d '='") -gt 0
				do
					sleep 5
				done
			done;unset db
		done;unset h
	}
	readonly -f wait_stable
fi

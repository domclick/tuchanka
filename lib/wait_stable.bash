# $1 cluster to test
# $2 (optional) "broken" vm, don't test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/now.bash"
if is_function_absent 'wait_stable'
then
	function wait_stable {
		local c=$1 broken=${2:-''}
		local h db is attribute
		for h in ${cluster_vms[$c]}
		do
			if [ "$h" = "$broken" ]
			then
				continue;
			fi
			# check that the cluster is stable for more then 25s
			while true
			do
				is=$(($(now)-$(vm_ssh $h "stat --printf='%Y' '${cib}'")))
				[ $is -gt 25 ] && break
				sleep 5
			done; unset is
			# Проверка что все атрибуты отвечающие за репликацию >0 (нет ошибок репликации)
			for db in ${cluster_dbs[$c]}
			do
				attribute="master-${float_name[$db]}DB"
				while true
				do
					is=$(vm_ssh $h "pcs node attribute '${vm_name[$h]}' --name '${attribute}'|tail -n 1|cut -f 2 -d '='")
					[ $is -gt 0 ] && break
					sleep 5
				done
			done;unset db attribute is
		done;unset h
	}
	readonly -f wait_stable
fi

# $1 snapshot name
# остальные - VM имена, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_grep.bash"

if is_function_absent 'delete_snapshot'
then
	function delete_snapshot {
		local snapshot_name="$1"
		shift 1
		local vms="${*:-"${vm_name[*]}"}"
		local vm is

		for vm in $vms
		do
			# VBoxManage snapshot возвращает 1 если нет снэпшотов
			# перехватываю ошибку и игнорирую.
			is=$({ VBoxManage snapshot "$vm" list --machinereadable || [ $? -eq 1 ];} | is_grep "^SnapshotName\(-[[:digit:]]\+\)\?=\"${snapshot_name}\"\$")
			if $is
			then
				VBoxManage snapshot "$vm" delete "$snapshot_name"
			fi
		done;unset vm
	}
	readonly -f delete_snapshot
fi

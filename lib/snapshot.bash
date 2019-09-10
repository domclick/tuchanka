# $1 snapshot name
# $2 snapshot description
# остальные - VM имена, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/shut_down.bash"

if is_function_absent 'snapshot'
then
	function snapshot {
		local snapshot_name="$1" snapshot_description="$2"
		shift 2
		local vms="${*:-"${vm_name[*]}"}"
		local vm grep_count

		shut_down $vms

		for vm in $vms
		do
			echo "Snapshot ${vm} as \"${snapshot_name}\""
			# VBoxManage snapshot возвращает 1 если нет снэпшотов
			# grep возвращает 1 если нет нахождений строк
			# перехватываю ошибку и игнорирую.
			grep_count=$(VBoxManage snapshot "$vm" list --machinereadable|grep --count --extended-regexp "^SnapshotName[-[:digit:]]*=\"$snapshot_name\"\$" || [ $? -eq 1 ])
			if [ $grep_count -ne 0 ]
			then
				VBoxManage snapshot "$vm" delete "$snapshot_name"
			fi
			VBoxManage snapshot "$vm" take "$snapshot_name" --description "$snapshot_description"
			sleep 1
		done;unset vm
	}
	readonly -f snapshot
fi

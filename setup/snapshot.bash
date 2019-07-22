# $1 snapshot name
# $2 snapshot description
. "${setup_dir}/is_function_absent.bash"
. "${setup_dir}/soft_off.bash"
if is_function_absent 'snapshot'
then
	function snapshot {
		soft_off
		local snapshot_name="$1" snapshot_description="$2"
		local grep_count i
		for i in "${!vm_name[@]}"
		do
			echo "Snapshot ${vm_name[$i]} as \"$snapshot_name\""
			# VBoxManage snapshot возвращает 1 если нет снэпшотов
			# grep возвращает 1 если нет нахождений строк
			# перехватываю ошибку и игнорирую.
			grep_count=$(VBoxManage snapshot "${vm_name[$i]}" list --machinereadable|grep --count --extended-regexp "^SnapshotName[-[:digit:]]*=\"$snapshot_name\"\$" || [ $? -eq 1 ])
			if [ $grep_count -ne 0 ]
			then
				VBoxManage snapshot "${vm_name[$i]}" delete "$snapshot_name"
			fi
			VBoxManage snapshot "${vm_name[$i]}" take "$snapshot_name" --description "$snapshot_description"
		done
	}
	readonly -f snapshot
fi

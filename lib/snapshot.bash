# $1 snapshot name
# $2 snapshot description
# остальные - VM имена, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/shut_down.bash"
. "${lib_dir}/delete_snapshot.bash"

if is_function_absent 'snapshot'
then
	function snapshot {
		local snapshot_name="$1" snapshot_description="$2"
		shift 2
		local vms="${*:-"${vm_name[*]}"}"
		local vm

		shut_down $vms

		for vm in $vms
		do
			echo "Snapshot ${vm} as \"${snapshot_name}\""
			delete_snapshot "$snapshot_name" "$vm"
			VBoxManage snapshot "$vm" take "$snapshot_name" --description "$snapshot_description"
			sleep 1
		done;unset vm
	}
	readonly -f snapshot
fi

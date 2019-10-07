# $1 snapshot name
# остальные - VM имена, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_snapshot.bash"

if is_function_absent 'delete_snapshot'
then
	function delete_snapshot {
		local snapshot_name="$1"
		shift 1
		local vms="${*:-"${vm_name[*]}"}"
		local vm is

		for vm in $vms
		do
			is=$(is_snapshot "$snapshot_name" "$vm")
			if $is
			then
				VBoxManage snapshot "$vm" delete "$snapshot_name"
			fi
		done;unset vm
	}
	readonly -f delete_snapshot
fi

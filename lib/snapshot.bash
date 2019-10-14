# $1 snapshot name
# $2 snapshot description
# остальные - список VM, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/shut_down.bash"
. "${lib_dir}/delete_snapshot.bash"

if is_function_absent 'snapshot'
then
	function snapshot {
		local snapshot_name="$1" snapshot_description="$2"
		shift 2
		local hosts="${*:-"${!vm_name[*]}"}"
		local h

		shut_down $hosts

		for h in $hosts
		do
			echo "Snapshot ${vm_name[$h]} as \"${snapshot_name}\""
			delete_snapshot "${snapshot_name}" $h
			VBoxManage snapshot "${vm_name[$h]}" take "${snapshot_name}" --description "${snapshot_description}"
			sleep 1
		done;unset h
	}
	readonly -f snapshot
fi

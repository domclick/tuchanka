# $1 snapshot name
# остальные - список VM, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_snapshot.bash"

if is_function_absent 'delete_snapshot'
then
	function delete_snapshot {
		local snapshot_name="$1"
		shift 1
		local hosts="${*:-"${!vm_name[*]}"}"
		local h is

		for h in $hosts
		do
			is=$(is_snapshot "${snapshot_name}" $h)
			if $is
			then
				VBoxManage snapshot "${vm_name[$h]}" delete "${snapshot_name}"
			fi
		done;unset h
	}
	readonly -f delete_snapshot
fi

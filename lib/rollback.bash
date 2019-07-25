# $1 snapshot name
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/hard_off.bash"
if is_function_absent 'rollback'
then
	function rollback {
		local snapshot_name="$1"
		local i
		hard_off
		for i in "${!vm_name[@]}"
		do
			echo "Rollback ${vm_name[$i]} to \"${snapshot_name}\""
			VBoxManage snapshot "${vm_name[$i]}" restore "${snapshot_name}"
		done;unset i
	}
	readonly -f rollback
fi

# $1 snapshot name
# остальные - VM, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/power_off.bash"

if is_function_absent 'rollback'
then
	function rollback {
		local snapshot_name="$1"
		shift
		local hosts="${*:-"${!vm_name[*]}"}"
		local h

		power_off $hosts

		for h in $hosts
		do
			echo "Rollback ${vm_name[$h]} to \"${snapshot_name}\""
			VBoxManage snapshot "${vm_name[$h]}" restore "${snapshot_name}"
			sleep 1
		done;unset h
	}
	readonly -f rollback
fi

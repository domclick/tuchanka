# $1 snapshot name
# остальные - VM имена, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/power_off.bash"

if is_function_absent 'rollback'
then
	function rollback {
		local snapshot_name="$1"
		shift
		local vms="${*:-"${vm_name[*]}"}"
		local vm

		power_off $vms

		for vm in $vms
		do
			echo "Rollback ${vm} to \"${snapshot_name}\""
			VBoxManage snapshot "$vm" restore "${snapshot_name}"
			sleep 1
		done;unset vm
	}
	readonly -f rollback
fi

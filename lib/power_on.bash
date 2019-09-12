# $@ список VM, которые надо включить, если пустой, то все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"

if is_function_absent 'power_on'
then
	function power_on {
		local vms="${*:-"${vm_name[*]}"}"
		local vm
		for vm in $vms
		do
			if ! is_vm_running "$vm"
			then
				echo "Start ${vm}"
				VBoxManage startvm "$vm"
			fi
		done;unset vm
		for vm in $vms
		do
			echo "Waiting for system on ${vm}"
			until vm_ssh "$vm" 'systemctl is-system-running' 2>/dev/null
			do
				sleep 5
			done
		done;unset vm
		sleep 1
	}
	readonly -f power_on
fi

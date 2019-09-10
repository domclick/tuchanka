# $@ список VM, которые надо отключить, если пустой, то все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"

if is_function_absent 'power_off'
then
	function power_off {
		local vms="${*:-"${vm_name[*]}"}"
		local vm
		for vm in $vms
		do
			if is_vm_running "$vm"
			then
				VBoxManage controlvm "$vm" poweroff
			fi
		done;unset vm
		for vm in $vms
		do
			echo "Waiting power_off of ${vm}"
			while is_vm_running "$vm"
			do
				sleep 5
			done
		done;unset vm
		sleep 1
	}
	readonly -f power_off
fi

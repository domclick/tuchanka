# $@ список VM, которые надо включить, если пустой, то все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"

if is_function_absent 'power_on'
then
	function power_on {
		local vms="${*:-"${vm_name[*]}"}"
		local vm is
		for vm in $vms
		do
			is=$(is_vm_running "$vm")
			if ! $is
			then
				echo "Start ${vm}"
				VBoxManage startvm "$vm"
			fi
		done;unset vm
		for vm in $vms
		do
			echo "Waiting for system on ${vm}"
			# Тут как ошибки ssh так и ненулевой возврат systemctl is-system-running
			# должны приводить к дальнейшему ожиданию
			until vm_ssh "$vm" 'systemctl is-system-running'
			do
				sleep 5
			done
		done;unset vm
		sleep 5
	}
	readonly -f power_on
fi

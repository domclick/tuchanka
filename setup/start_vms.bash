. "${setup_dir}/is_function_absent.bash"
. "${setup_dir}/is_vm_running.bash"
. "${setup_dir}/vm_ssh.bash"
if is_function_absent 'start_vms'
then
	function start_vms {
		local i
		for i in "${!vm_name[@]}"
		do
			if ! is_vm_running "${vm_name[$i]}"
			then
				echo "Start ${vm_name[$i]}"
				VBoxManage startvm "${vm_name[$i]}"
			fi
		done
		for i in "${!vm_name[@]}"
		do
			echo "Waiting for system on ${vm_name[$i]}"
			until vm_ssh "${vm_hostname[$i]}" 'systemctl is-system-running' 2>/dev/null
			do
				sleep 1
			done
		done
		sleep 5
	}
	readonly -f start_vms
fi

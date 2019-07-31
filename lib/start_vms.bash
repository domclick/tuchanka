. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"
if is_function_absent 'start_vms'
then
	function start_vms {
		local h
		for h in "${vm_name[@]}"
		do
			if ! is_vm_running "$h"
			then
				echo "Start $h"
				VBoxManage startvm "$h"
			fi
		done;unset h
		for h in "${vm_name[@]}"
		do
			echo "Waiting for system on $h"
			until vm_ssh "$h" 'systemctl is-system-running' 2>/dev/null
			do
				sleep 5
			done
		done;unset h
		sleep 5
	}
	readonly -f start_vms
fi

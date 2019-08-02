# $1 VM name to start
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"
if is_function_absent 'start_node'
then
	function start_node {
		local h="$1"
		if ! is_vm_running "$h"
		then
			echo "Start ${h}"
			VBoxManage startvm "$h"
		fi
		echo "Waiting for system on ${h}"
		until vm_ssh "${h}" 'systemctl is-system-running' 2>/dev/null
		do
			sleep 5
		done
		sleep 5
	}
	readonly -f start_node
fi

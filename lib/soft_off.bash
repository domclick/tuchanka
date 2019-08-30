# работает только если OS уже полностью загружена
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"
if is_function_absent 'soft_off'
then
	function soft_off {
		local h
		for h in "${vm_name[@]}"
		do
			if is_vm_running "$h"
			then
				VBoxManage controlvm "$h" acpipowerbutton
				sleep 1
			fi
		done;unset h
		for h in "${vm_name[@]}"
		do
			echo "Waiting Off of $h"
			while is_vm_running "$h"
			do
				sleep 5
			done
		done;unset h
		sleep 5
	}
	readonly -f soft_off
fi

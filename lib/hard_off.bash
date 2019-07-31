. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
if is_function_absent 'hard_off'
then
	function hard_off {
		local h
		for h in "${vm_name[@]}"
		do
			if is_vm_running "$h"
			then
				VBoxManage controlvm "$h" poweroff
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
	readonly -f hard_off
fi

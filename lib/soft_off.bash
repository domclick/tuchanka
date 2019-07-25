# работает только если OS уже полностью загружена
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"
if is_function_absent 'soft_off'
then
	function soft_off {
		local i
		for i in "${!vm_name[@]}"
		do
			if is_vm_running "$i"
			then
				VBoxManage controlvm "${vm_name[$i]}" acpipowerbutton
			fi
		done;unset i
		for i in "${!vm_name[@]}"
		do
			echo "Waiting Off of ${vm_name[$i]}"
			while is_vm_running "$i"
			do
				sleep 1
			done
		done;unset i
		sleep 5
	}
	readonly -f soft_off
fi

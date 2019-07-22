# работает только если OS уже полностью загружена
. "${setup_dir}/is_function_absent.bash"
. "${setup_dir}/is_vm_running.bash"
. "${setup_dir}/vm_ssh.bash"
if is_function_absent 'soft_off'
then
	function soft_off {
		local i
		for i in "${!vm_name[@]}"
		do
			if is_vm_running "${vm_name[$i]}"
			then
				VBoxManage controlvm "${vm_name[$i]}" acpipowerbutton
			fi
		done
		for i in "${!vm_name[@]}"
		do
			echo "Waiting Off of ${vm_name[$i]}"
			while is_vm_running "${vm_name[$i]}"
			do
				sleep 1
			done
		done
		sleep 5
	}
	readonly -f soft_off
fi

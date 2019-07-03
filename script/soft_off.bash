# работает только если OS уже полностью загружена
. "${script_dir}/is_function_absent.bash"
. "${script_dir}/is_vm_running.bash"
if is_function_absent 'soft_off'
then
	function soft_off {
		local i
		for i in "${!vm_name[@]}"
		do
			if is_vm_running "${vm_name[$i]}"
			then
				echo "Off ${vm_name[$i]}"
				VBoxManage controlvm "${vm_name[$i]}" acpipowerbutton
				while is_vm_running "${vm_name[$i]}"
				do
					sleep 1
				done
			fi
		done
		sleep 5
	}
	readonly -f soft_off
fi

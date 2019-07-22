. "${setup_dir}/is_function_absent.bash"
. "${setup_dir}/is_vm_running.bash"
if is_function_absent 'hard_off'
then
	function hard_off {
		local i
		for i in "${!vm_name[@]}"
		do
			if is_vm_running "${vm_name[$i]}"
			then
				VBoxManage controlvm "${vm_name[$i]}" poweroff
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
	readonly -f hard_off
fi

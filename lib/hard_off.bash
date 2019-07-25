. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
if is_function_absent 'hard_off'
then
	function hard_off {
		local i
		for i in "${!vm_name[@]}"
		do
			if is_vm_running "$i"
			then
				VBoxManage controlvm "${vm_name[$i]}" poweroff
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
	readonly -f hard_off
fi

# $@ список VM, которые надо отключить, если пустой, то все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"

if is_function_absent 'power_off'
then
	function power_off {
		local hosts="${*:-"${!vm_name[*]}"}"
		local h is
		for h in $hosts
		do
			is=$(is_vm_running $h)
			if $is
			then
				echo "PowerOff ${vm_name[$h]}"
				VBoxManage controlvm "${vm_name[$h]}" poweroff
			fi
		done;unset h
		for h in $hosts
		do
			echo "Waiting power_off of ${vm_name[$h]}"
			while true
			do
				is=$(is_vm_running $h)
				$is || break
				sleep 5
			done
		done;unset h
		sleep 1
	}
	readonly -f power_off
fi

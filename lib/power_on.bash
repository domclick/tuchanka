# $@ список VM, которые надо включить, если пустой, то все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"

if is_function_absent 'power_on'
then
	function power_on {
		local hosts="${*:-"${!vm_name[*]}"}"
		local h is
		for h in $hosts
		do
			is=$(is_vm_running $h)
			if ! $is
			then
				echo "Start ${vm_name[$h]}"
				VBoxManage startvm "${vm_name[$h]}"
			fi
		done;unset h
		for h in $hosts
		do
			echo "Waiting for system on ${vm_name[$h]}"
			# Тут как ошибки ssh так и ненулевой возврат systemctl is-system-running
			# должны приводить к дальнейшему ожиданию
			until vm_ssh $h -o 'ConnectTimeout 1' 'systemctl is-system-running'
			do
				sleep 5
			done
		done;unset h
		sleep 5
	}
	readonly -f power_on
fi

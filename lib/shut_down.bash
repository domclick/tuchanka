# $@ список VM, которые надо выключить, если пустой, то все
# работает только если OS уже полностью загружена
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"

if is_function_absent 'shut_down'
then
	function shut_down {
		local hosts="${*:-"${!vm_name[*]}"}"
		local h is
		for h in $hosts
		do
			is=$(is_vm_running $h)
			if $is
			then
				#VBoxManage controlvm "${vm_name[$h]}" acpipowerbutton
				# Выкинет с ненулевым кодом
				vm_ssh $h "poweroff" || true
				sleep 1 # обхожу баг с ошибочными мессаджами в GUI
			fi
		done;unset h
		for h in $hosts
		do
			echo "Waiting shut_down of ${vm_name[$h]}"
			while true
			do
				is=$(is_vm_running $h)
				$is || break
				sleep 5
			done
		done;unset h
		sleep 1
	}
	readonly -f shut_down
fi

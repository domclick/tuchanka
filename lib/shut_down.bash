# $@ список VM, которые надо выключить, если пустой, то все
# работает только если OS уже полностью загружена
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"

if is_function_absent 'shut_down'
then
	function shut_down {
		local vms="${*:-"${vm_name[*]}"}"
		local vm
		for vm in $vms
		do
			if is_vm_running "$vm"
			then
				VBoxManage controlvm "$vm" acpipowerbutton
				sleep 1 # обхожу баг с ошибочными мессаджами в GUI
			fi
		done;unset vm
		for vm in $vms
		do
			echo "Waiting shut_down of ${vm}"
			while is_vm_running "$vm"
			do
				sleep 5
			done
		done;unset vm
		sleep 1
	}
	readonly -f shut_down
fi
# $@ список VM, которые надо выключить, если пустой, то все
# работает только если OS уже полностью загружена
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"

if is_function_absent 'shut_down'
then
	function shut_down {
		local vms="${*:-"${vm_name[*]}"}"
		local vm is
		for vm in $vms
		do
			is=$(is_vm_running "$vm")
			if $is
			then
				VBoxManage controlvm "$vm" acpipowerbutton
				sleep 1 # обхожу баг с ошибочными мессаджами в GUI
			fi
		done;unset vm
		for vm in $vms
		do
			echo "Waiting shut_down of ${vm}"
			is=$(is_vm_running "$vm")
			while $is
			do
				sleep 5
				is=$(is_vm_running "$vm")
			done
		done;unset vm
		sleep 1
	}
	readonly -f shut_down
fi

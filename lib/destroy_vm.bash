# $@ список VM, которые надо отключить, если пустой, то все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_grep.bash"
. "${lib_dir}/power_off.bash"

if is_function_absent 'destroy_vm'
then
	function destroy_vm {
		local vms="${*:-"${vm_name[*]}"}"
		local vm is
		power_off $vms
		for vm in $vms
		do
			is=$(VBoxManage list vms | is_grep "^\"${vm}\" ")
			if $is
			then
				echo "Destroy ${vm}"
				VBoxManage unregistervm "${vm}" --delete
			fi
		done;unset vm is
	}
	readonly -f destroy_vm
fi

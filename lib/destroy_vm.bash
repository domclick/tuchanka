# $@ список VM, которые надо отключить, если пустой, то все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_grep.bash"
. "${lib_dir}/power_off.bash"

if is_function_absent 'destroy_vm'
then
	function destroy_vm {
		local hosts="${*:-"${!vm_name[*]}"}"
		local h is
		power_off $hosts
		for h in $hosts
		do
			is=$(VBoxManage list vms | is_grep "^\"${vm_name[$h]}\" ")
			if $is
			then
				echo "Destroy ${vm_name[$h]}"
				VBoxManage unregistervm "${vm_name[$h]}" --delete
			fi
		done;unset h is
	}
	readonly -f destroy_vm
fi

# $1 VM name to test
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'is_vm_running'
then
	function is_vm_running {
		local vm="$1"
		test 0 -ne $(VBoxManage list runningvms | { grep --count --fixed-strings "\"${vm}\"" || [ $? -eq 1 ]; })
	}
	readonly -f is_vm_running
fi
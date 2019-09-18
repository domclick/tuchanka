# $1 VM name to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/grep_count.bash"
if is_function_absent 'is_vm_running'
then
	function is_vm_running {
		local vm="$1"
		local gc
		gc=$(VBoxManage list runningvms | grep_count --fixed-strings "\"${vm}\"")
		test 0 -ne $gc
	}
	readonly -f is_vm_running
fi

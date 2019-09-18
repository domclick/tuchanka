# $1 VM name to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_grep.bash"
if is_function_absent 'is_vm_running'
then
	function is_vm_running {
		local vm="$1"
		VBoxManage list runningvms | is_grep "^\"${vm}\" "
	}
	readonly -f is_vm_running
fi

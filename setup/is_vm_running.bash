# $1 VM name to test
. "${setup_dir}/is_function_absent.bash"
if is_function_absent 'is_vm_running'
then
	function is_vm_running {
		test 0 -ne $(VBoxManage list runningvms | { grep --count --fixed-strings "\"$1\"" || [ $? -eq 1 ]; })
	}
	readonly -f is_vm_running
fi

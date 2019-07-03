# $1 snapshot name
. "${script_dir}/is_function_absent.bash"
if is_function_absent 'rollback'
then
	function rollback {
		local i
		for i in "${!vm_name[@]}"
		do
			echo "Rollback ${vm_name[$i]} to \"${1}\""
			VBoxManage snapshot "${vm_name[$i]}" restore "${1}"
		done
	}
	readonly -f rollback
fi

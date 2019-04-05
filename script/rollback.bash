# $1 snapshot name
function rollback {
	local i
	for i in "${!vm_name[@]}"
	do
		echo "Rollback ${vm_name[$i]} to \"${1}\""
		VBoxManage snapshot "${vm_name[$i]}" restore "${1}"
	done
}
readonly -f rollback

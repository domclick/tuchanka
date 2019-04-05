# ssh for virtual machines
function vm_ssh
{
	ssh -F "${ssh_config}" -o "UserKnownHostsFile=${ssh_known_hosts}" "$@"
}
function vm_cp
{
	local host="$1" from_path="$2" to_path="$3"
	scp -F "${ssh_config}" -o "UserKnownHostsFile=${ssh_known_hosts}" -q "${from_path}" "${host}:${to_path}"
}
function vm_cp2pgsql {
	local host="$1" from_path="$2" to_path="$3"
	vm_ssh "${host}" "su postgres -c \"umask 0177 && cat >'${to_path}'\"" <"${from_path}"
}
readonly -f vm_ssh vm_cp vm_cp2pgsql

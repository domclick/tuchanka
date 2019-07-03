# ssh for virtual machines
. "${script_dir}/is_function_absent.bash"
if is_function_absent 'vm_ssh'
then
	function vm_ssh
	{
		ssh -F "${ssh_config}" -o "UserKnownHostsFile=${ssh_known_hosts}" "$@"
	}
	readonly -f vm_ssh
fi
if is_function_absent 'vm_cp'
then
	function vm_cp
	{
		local host="$1" from_path="$2" to_path="$3"
		scp -F "${ssh_config}" -o "UserKnownHostsFile=${ssh_known_hosts}" -q "${from_path}" "${host}:${to_path}"
	}
	readonly -f vm_cp
fi
if is_function_absent 'vm_cp2pgsql'
then
	function vm_cp2pgsql {
		local host="$1" from_path="$2" to_path="$3"
		vm_ssh "${host}" "su postgres -c \"umask 0177 && cat >'${to_path}'\"" <"${from_path}"
	}
	readonly -f vm_cp2pgsql
fi

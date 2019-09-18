# ssh for virtual machines
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/grep_count.bash"
if is_function_absent 'vm_ssh_add'
then
	readonly vm_ssh_add_key_prefix='# ssh key fingerprint '
	function vm_ssh_add
	{
		local ssh_fingerprint=
		local gc
		# Если опция пуста, отключается автоматическая загрузка ключей
		if [ -z "$vm_ssh_load_key" ]
		then
			return 0
		fi
		# on first run in the setup/install the ssh_config is abscent yet
		if [ -f "${ssh_config}" ]
		then
			ssh_fingerprint="$(sed -n "/^${vm_ssh_add_key_prefix}/{s///p;q;}" "${ssh_config}")"
		fi
		if [ -z "$ssh_fingerprint" ]
		then
			return 0
		fi
		# ssh-add -l return 1 on empty
		gc=$({ ssh-add -l || [ $? -eq 1 ];} | grep_count --fixed-strings "$ssh_fingerprint")
		if [ $gc -eq 0 ]
		then
			$vm_ssh_load_key
		fi
	}
	readonly -f vm_ssh_add
	# run on load
	vm_ssh_add
fi
if is_function_absent 'vm_ssh'
then
	function vm_ssh
	{
		# $@ передается ssh
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
		vm_ssh "${host}" "su postgres -c \"umask 0177 && cat >|'${to_path}'\"" <"${from_path}"
	}
	readonly -f vm_cp2pgsql
fi

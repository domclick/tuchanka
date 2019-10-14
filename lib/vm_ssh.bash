# ssh for virtual machines
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_grep.bash"
if is_function_absent 'vm_ssh_add'
then
	readonly vm_ssh_add_key_prefix='# ssh key fingerprint '
	function vm_ssh_add
	{
		local is ssh_fingerprint=
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
		is=$({ ssh-add -l || [ $? -eq 1 ];} | is_grep --fixed-strings " $ssh_fingerprint ")
		if ! $is
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
	# $1 VM
	# остальное передается ssh
	function vm_ssh {
		local h=$1 r
		shift
		[ -t 1 ] && echo -ne "\\0033[38;5;${vm_prompt[$h]}m"
		ssh -F "${ssh_config}" -o "UserKnownHostsFile=\"${ssh_known_hosts}\"" "${vm_name[$h]}" "$@"
		r=$?
		[ -t 1 ] && echo -ne '\0033[m'
		return $r
	}
	readonly -f vm_ssh
fi
if is_function_absent 'vm_cp'
then
	function vm_cp
	{
		local h=$1 from_path="$2" to_path="$3"
		scp -F "${ssh_config}" -o "UserKnownHostsFile=\"${ssh_known_hosts}\"" -q "${from_path}" "${vm_name[$h]}:${to_path}"
	}
	readonly -f vm_cp
fi
if is_function_absent 'vm_cp2pgsql'
then
	function vm_cp2pgsql {
		local h=$1 from_path="$2" to_path="$3"
		vm_ssh $h "su postgres -c \"umask 0177 && cat >|'${to_path}'\"" <"${from_path}"
	}
	readonly -f vm_cp2pgsql
fi

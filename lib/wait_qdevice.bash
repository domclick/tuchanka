# Ожидание, когда поднимется quorum device
# Нужно в распараллелиных скриптах

. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/vm_ssh.bash"

if is_function_absent 'wait_qdevice'
then
	function wait_qdevice {
		until vm_ssh $Witness "/usr/bin/corosync-qnetd-tool -s"
		do
			sleep 5
		done
	}
	readonly -f wait_qdevice
fi

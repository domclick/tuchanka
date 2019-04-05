function start_vms {
	local grep_count i
	for i in "${!vm_name[@]}"
	do
		grep_count=$(VBoxManage list runningvms | { grep --count --fixed-strings "\"${vm_name[$i]}\"" || [ $? -eq 1 ]; })
		if [ $grep_count -eq 0 ]
		then
			echo "Start ${vm_name[$i]}"
			VBoxManage startvm "${vm_name[$i]}"
		fi
	done
	for i in "${!vm_name[@]}"
	do
		echo "Waiting for ssh on ${vm_name[$i]}"
		until vm_ssh "${vm_hostname[$i]}" 'true' 2>/dev/null
		do
			sleep 1
		done
	done
}
readonly -f start_vms

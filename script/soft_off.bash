# работает только если OS уже полностью загружена
function soft_off {
	local grep_count i
	for i in "${!vm_name[@]}"
	do
		grep_count=$(VBoxManage list runningvms | { grep --count --fixed-strings "\"${vm_name[$i]}\"" || [ $? -eq 1 ]; })
		if [ $grep_count -ne 0 ]
		then
			echo "Off ${vm_name[$i]}"
			VBoxManage controlvm "${vm_name[$i]}" acpipowerbutton
			while [ $grep_count -ne 0 ]
			do
				sleep 1
				grep_count=$(VBoxManage list runningvms | { grep --count --fixed-strings "\"${vm_name[$i]}\"" || [ $? -eq 1 ]; })
			done
		fi
	done
}
readonly -f soft_off

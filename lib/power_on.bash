# Copyright Ⓒ 2020 "Sberbank Real Estate Center" Limited Liability Company.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

# $@ список VM, которые надо включить, если пустой, то все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_vm_running.bash"
. "${lib_dir}/vm_ssh.bash"

if is_function_absent 'power_on'
then
	function power_on {
		local hosts="${*:-"${!vm_name[*]}"}"
		local h is
		for h in $hosts
		do
			is=$(is_vm_running $h)
			if ! $is
			then
				echo "PowerOn ${vm_name[$h]}"
				VBoxManage startvm "${vm_name[$h]}"
			fi
		done;unset h
		for h in $hosts
		do
			echo "Waiting for system on ${vm_name[$h]}"
			# Тут как ошибки ssh так и ненулевой возврат systemctl is-system-running
			# должны приводить к дальнейшему ожиданию
			until vm_ssh $h -o 'ConnectTimeout 1' 'systemctl is-system-running'
			do
				sleep 5
			done
		done;unset h
		sleep 5
	}
	readonly -f power_on
fi

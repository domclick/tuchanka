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

# $1 snapshot name
# $2 snapshot description
# остальные - список VM, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/shut_down.bash"
. "${lib_dir}/delete_snapshot.bash"

if is_function_absent 'snapshot'
then
	function snapshot {
		local snapshot_name="$1" snapshot_description="$2"
		shift 2
		local hosts="${*:-"${!vm_name[*]}"}"
		local h

		shut_down $hosts

		for h in $hosts
		do
			echo "Snapshot ${vm_name[$h]} as \"${snapshot_name}\""
			delete_snapshot "${snapshot_name}" $h
			VBoxManage snapshot "${vm_name[$h]}" take "${snapshot_name}" --description "${snapshot_description}"
			sleep 1
		done;unset h
	}
	readonly -f snapshot
fi

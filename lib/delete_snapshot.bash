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
# остальные - список VM, которые надо откатить, если пусто - все
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_snapshot.bash"

if is_function_absent 'delete_snapshot'
then
	function delete_snapshot {
		local snapshot_name="$1"
		shift 1
		local hosts="${*:-"${!vm_name[*]}"}"
		local h is

		for h in $hosts
		do
			is=$(is_snapshot "${snapshot_name}" $h)
			if $is
			then
				VBoxManage snapshot "${vm_name[$h]}" delete "${snapshot_name}"
			fi
		done;unset h
	}
	readonly -f delete_snapshot
fi

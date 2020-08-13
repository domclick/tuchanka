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

# $1 snapshot name to test
# $2 VM to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_grep.bash"
if is_function_absent 'is_snapshot'
then
	function is_snapshot {
		local snapshot="$1" h=$2
		# VBoxManage snapshot возвращает 1 если нет снэпшотов
		# перехватываю ошибку и игнорирую.
		{ VBoxManage snapshot "${vm_name[$h]}" list --machinereadable || [ $? -eq 1 ];} | is_grep "^SnapshotName\([-[:digit:]]\+\)\?=\"${snapshot}\"\$"
	}
	readonly -f is_snapshot
fi

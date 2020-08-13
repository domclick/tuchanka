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

# $1 cluster to test
# $2 (optional) "broken" vm, don't test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/now.bash"
if is_function_absent 'wait_stable'
then
	function wait_stable {
		local c=$1 broken=${2:-''}
		local h db is attribute
		for h in ${cluster_vms[$c]}
		do
			if [ "$h" = "$broken" ]
			then
				continue;
			fi
			# check that the cluster is stable for more then 25s
			while true
			do
				is=$(($(now)-$(vm_ssh $h "stat --printf='%Y' '${cib}'")))
				[ $is -gt 25 ] && break
				sleep 5
			done; unset is
			# Проверка что все атрибуты отвечающие за репликацию >0 (нет ошибок репликации)
			for db in ${cluster_dbs[$c]}
			do
				attribute="master-${float_name[$db]}DB"
				while true
				do
					is=$(vm_ssh $h "pcs node attribute '${vm_name[$h]}' --name '${attribute}'|tail -n 1|cut -f 2 -d '='")
					[ $is -gt 0 ] && break
					sleep 5
				done
			done;unset db attribute is
		done;unset h
	}
	readonly -f wait_stable
fi

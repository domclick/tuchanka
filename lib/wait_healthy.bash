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
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/vm_ssh.bash"
. "${lib_dir}/wait_stable.bash"
. "${lib_dir}/heartbeat.bash"
if is_function_absent 'wait_healthy'
then
	function wait_healthy {
		local c=$1
		local db master slaves slave date h is
		# check that the cluster has all nodes
		for h in ${cluster_vms[$c]}
		do
			# Ожидание как в случае ошибок ssh так и ненулевого crm_mon
			until vm_ssh $h "/usr/sbin/crm_mon --simple-status"
			do
				sleep 5
			done;
		done;unset h
		wait_stable $c
		# Убеждаемся, что БД работают, проверка репликации по всем рабам
		for db in ${cluster_dbs[$c]}
		do
			master="${float_ip[$db]}:${db_port[$db]}"
			date="$(heartbeat_psql "${master}" 'wait_healthy.bash' 'read-write' 'select heart()')"
			if [ -n "${db_slaves[$db]}" ]
			then
				for h in ${db_slaves[$db]}
				do
					slaves+=" ${float_ip[$h]}"
				done; unset h
			else
				# По сути костыль для Tuchanka1, официальных slave там нет, но есть неофициальные
				# и их тоже, по хорошему, надо проверять в случае wait_healthy.
				# По скольку Tuchanka1 возвращается к исходному состоянию, то можно использовать
				# адреса со стадии setup при wait_healthy.
				for h in ${db_setup_slaves[$db]}
				do
					slaves+=" ${vm_ip[$h]}"
				done; unset h
			fi
			# remove leading ' '
			slaves="${slaves#' '}"
			for slave in ${slaves}
			do
				slave+=":${db_port[$db]}"
				# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
				while true
				do
					is="$(heartbeat_psql "${slave}" 'wait_healthy.bash' 'any' "select beat()>='${date}'")"
					[ "$is" = 't' ] && break
					sleep 5
				done
			done;unset slave
		done;unset db
		# History of errors must be clean
		for h in ${cluster_vms[$c]}
		do
			is="$(vm_ssh $h 'pcs resource failcount show')"
			test 'No failcounts' = "$is"
		done;unset h
	}
	readonly -f wait_healthy
fi

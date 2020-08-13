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
. "${lib_dir}/heartbeat.bash"
if is_function_absent 'wait_ready'
then
	function wait_ready {
		local c=$1
		local db master slaves slave date i
		for ((i=0;i<5;i++)) # several times to sure that result is stable
		do
			for db in ${cluster_dbs[$c]}
			do
				master="${float_ip[$db]}:${db_port[$db]}"
				# В случае ошибок - ожидание
				until date="$(heartbeat_psql "${master}" 'wait_ready.bash' 'read-write' 'select heart()')"
				do
					sleep 1
				done
				# Убеждаемся, что БД работают, проверка репликации по любому рабу
				slaves="$(slaves4URL $db)"
				if [ -n "$slaves" ]
				then
					# В случае ошибок - ожидание
					until test "$(heartbeat_psql "${slaves}" 'wait_ready.bash' 'any' "select beat()>='${date}'")" = 't'
					do
						# репликация может быть ассинхронной, поэтому обновление может прийти не сразу
						sleep 1
					done
				fi
			done;unset db
			sleep 1
		done;unset i
	}
	readonly -f wait_ready
fi

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

# Библиотечка функций для работы с hearbeat
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'slaves4URL'
then
# Возвращает список ip рабов (вместе с портами) через запятую, нужен для передачи в URL psql,
# означает что коннекшин можно сделать к любому.
# $1 DB ID
	function slaves4URL {
		local db=$1
		local s slaves=''
		for s in ${db_slaves[$db]}
		do
			slaves+=",${float_ip[$s]}:${db_port[$db]}"
		done;unset s
		# remove leading ','
		slaves="${slaves#,}"
		echo "${slaves}"
	}
	readonly -f slaves4URL
fi
if is_function_absent 'heartbeat_psql'
then
# Вызов psql для запроса hearbeat
# Содержит оптимизирующие параметры уменьшающие время реакции, в случае если сервер не отвечает
	function heartbeat_psql {
		# $1 Содержит либо ip:port к БД, либо список разделенный запятыми
		# должны быть ip, а не hostname, так как не факт, что имена хостов будут добавлены в /etc/hosts
		local ip_port="$1"
		# $2 application name для передачи БД
		local application_name="$2"
		# $3 target_session_attrs: например any или read-write
		local target_session_attrs="$3"
		# $4 sql запрос к hearbeat
		local query="$4"
		psql --no-psqlrc --quiet --no-align --tuples-only \
			--dbname="postgresql://heartbeat:ChangeMe@${ip_port}/heartbeat?connect_timeout=2&application_name=${application_name}&keepalives=1&keepalives_idle=1&keepalives_interval=1&keepalives_count=1&target_session_attrs=${target_session_attrs}" \
			--command="${query}" \
			|| return $?
	}
	readonly -f heartbeat_psql
fi

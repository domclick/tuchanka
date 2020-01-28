# Библиотечка функций для работы с hearbeat
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'slaves4URL'
then
# Возвращает список рабов (вместе с портами) через запятую, нужен для передачи в URL psql,
# означает что коннекшин можно сделать к любому.
# $1 DB ID
	function slaves4URL {
		local db=$1
		local slave slaves=''
		for slave in ${db_slaves[$db]}
		do
			slaves+=",${slave}:${db_port[$db]}"
		done;unset slave
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

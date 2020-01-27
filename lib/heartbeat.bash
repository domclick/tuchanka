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

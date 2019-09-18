# Поиск строки в потоке stdin
# Возвращает 'true' если есть, 'false' если нет.
# $@ передаются grep
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'is_grep'
then
	function is_grep {
		local gc
		# on count=0 grep returns 1, ignore it
		gc=$(grep --count "$@" || [ $? -eq 1 ])
		if [ $gc -eq 0 ]
		then
			echo 'false'
		else
			echo 'true'
		fi
	}
	readonly -f is_grep
fi

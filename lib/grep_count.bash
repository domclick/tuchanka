# grep --count с игнором ненулевого кода в случае отсутствия нахождения
# $@ передаются grep
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'grep_count'
then
	function grep_count {
		# on count=0 grep returns 1, ignore it
		grep --count "$@" || [ $? -eq 1 ]
	}
	readonly -f grep_count
fi

# $@ список слов, возвращает одно из них, выбранное случайным образом
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'random_word'
then
	function random_word {
		local a=("$@")
		echo "${a[$RANDOM % ${#a[@]}]}"
	}
	readonly -f random_word
fi

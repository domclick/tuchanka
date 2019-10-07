# $@ список слов, возвращает их количество
# Должно существовать хотя бы одно слово
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'count_words'
then
	function count_words { echo $#;}
	readonly -f count_words
fi

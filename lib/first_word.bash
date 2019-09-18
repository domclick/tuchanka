# $@ список слов, возвращает первое из них
# Должно существовать хотя бы одно слово
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'first_word'
then
	function first_word { echo "$1";}
	readonly -f first_word
fi

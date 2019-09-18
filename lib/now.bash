# Возвращает текущее время в виде количества секунд с начала эпохи
# Используется для измерения временных интервалов
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'now'
then
	function now { date '+%s';}
	readonly -f now
fi

# Очистка: закрытие tmux сервера и завершение виртуалок.
# Создана для trap cleanup EXIT
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/tmux.bash"
. "${lib_dir}/power_off.bash"

if is_function_absent 'cleanup'
then
	function cleanup {
		tmux_cleanup
		power_off
	} &>/dev/null
# Перенаправление в /dev/null, иначе проблемы, когда есть вложенный tmux и внешний tmux сервер
# закрывается раньше, чем отрабатывает cleanup на внутреннем.
	readonly -f cleanup
fi

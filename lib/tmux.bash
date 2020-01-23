# Функции обертки для tmux
. "${lib_dir}/is_function_absent.bash"
# Позволит сделать вложенные tmux, например на случай если пользователь уже работает в tmux.
if is_function_absent 'tmux'
then
	function tmux {
		command tmux -L "${tmux_socket}" "$@"
	}
	readonly -f tmux
fi
if is_function_absent 'tmux_cleanup'
then
	function tmux_cleanup {
		# Закрывать сервер должен тот же процесс, что его и открыл
		# Такое сочетание переменных обеспечивает такое условие
		# В случае открытия первого сервере или вложенного, TMUX не будет
		# (не должен) быть определен в том процессе, который открывает.
		if [ -n "${tmux_socket:-}" -a -z "${TMUX:-}" ]
		then
			(tmux kill-server) || true # ignore error
		fi
	}
	readonly -f tmux_cleanup
fi
if is_function_absent 'tmux_init'
then
	function tmux_init {
		export tmux_socket="${tmux_socket:-${tmux_default_socket}}"
		export tmux_session tmux_window
		if [ -n "${TMUX:-}" ]
		then # tmux уже используется, значит делаем вложенный
			if [[ "${TMUX}" == *"/${tmux_socket},"* ]]
			then
				tmux_socket="${tmux_socket}+"
			fi
			unset TMUX TMUX_PANE
			# Какие-то проблемы с tmux, потому приходится прописывать TERM явно.
			# Проблема выглядят так, что во вложенном tmux нет всей палитры цветов.
			TERM='tmux-256color'
		fi
		# Cleanup in case of unclean previous finish
		tmux_cleanup
		tmux start-server ';' source-file "${lib_dir}/init.tmux"
	}
	readonly -f tmux_init
fi
if is_function_absent 'tmux_attach'
then
	function tmux_attach {
		tmux select-pane -t '{bottom-right}' ';' attach-session -t "=${tmux_session}"
		#сброс к дефолтному цвету, вдруг надо
		echo -ne '\0033[m'
		tmux_cleanup
	}
	readonly -f tmux_attach
fi

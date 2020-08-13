# Copyright Ⓒ 2020 "Sberbank Real Estate Center" Limited Liability Company.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

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
		#сброс к дефолтному цвету, вдруг надо
		echo -ne '\0033[m'
		# Закрывать сервер должен тот же процесс, что его и открыл
		# Такое сочетание переменных обеспечивает такое условие
		# В случае открытия первого сервере или вложенного, TMUX не будет
		# (не должен) быть определен в том процессе, который открывает.
		if [ -n "${tmux_socket:-}" -a -z "${TMUX:-}" ]
		then
			(tmux kill-server) || true # ignore error
			sleep 1 # видимо kill-server выполняется асинхронно
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
	}
	readonly -f tmux_attach
fi

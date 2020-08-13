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

# Для обоих функций:
# $@ опциональный комментарий к tick
# $tick_destination указывает в какую tmux pane выводить tick:
# pane id, то в этот tmux pane
# если неопределен или пустой, то stdout

# Идея этой функции сделать своеобразный progress meter для тестов выполняемых в цикле
# Пишет в номер текущей итерации и время, так же, опционально, можно добавить комментарий
# в качестве аргумента к функции tick.

# Номер тика хранится в глобальной переменной tick_counter.

. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/tmux.bash"

if is_function_absent 'tick'
then
	# Инициализирую счетчик
	declare -i tick_counter=0
	# функция для вывода тика, в качестве опционального аргумента может быть сообщение (комментарий)
	# параметры вызова см выше
	function tick {
		if [ -n "${tick_destination}" ]
		then # destination is pane id
			echo -ne "\n${tick_counter} $(date '+%T') $*"|tmux display-message -t "${tick_destination}" -I
		else
			echo "${tick_counter} $(date '+%T') $*"
		fi
	}
	readonly -f tick
fi
if is_function_absent 'tick+'
then
	# функция для инкремента счетчика и вывода тика, в качестве опционального аргумента может быть сообщение (комментарий)
	# параметры вызова см выше
	function tick+ {
		let tick_counter=$tick_counter+1
		tick "$@"
	}
	readonly -f tick+
fi

# $1 function name to test
if ! declare -F 'is_function_absent' &>/dev/null
then
	function is_function_absent {
		! declare -F "$1" &>/dev/null
	}
	readonly -f is_function_absent
fi

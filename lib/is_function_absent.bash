# $1 function name to test
if ! declare -F 'is_function_absent' &>/dev/null
then
	function is_function_absent {
		local function_name="$1"
		! declare -F "${function_name}" &>/dev/null
	}
	readonly -f is_function_absent
fi

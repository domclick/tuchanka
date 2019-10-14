# $1 snapshot name to test
# $2 VM to test
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/is_grep.bash"
if is_function_absent 'is_snapshot'
then
	function is_snapshot {
		local snapshot="$1" h=$2
		# VBoxManage snapshot возвращает 1 если нет снэпшотов
		# перехватываю ошибку и игнорирую.
		{ VBoxManage snapshot "${vm_name[$h]}" list --machinereadable || [ $? -eq 1 ];} | is_grep "^SnapshotName\(-[[:digit:]]\+\)\?=\"${snapshot}\"\$"
	}
	readonly -f is_snapshot
fi

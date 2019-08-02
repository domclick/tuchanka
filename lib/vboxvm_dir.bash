# $1 VM name
# Возвращает директорию, где лежат файлы этой виртуальной машины
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'vboxvm_dir'
then
	function vboxvm_dir {
		local vm="$1"
		dirname "$(VBoxManage showvminfo "${vm}"|sed -nE '/^Config file:[[:space:]]+(\/.+\.vbox)$/ s//\1/p')"
	}
	readonly -f vboxvm_dir
fi

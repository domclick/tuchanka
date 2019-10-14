# $1 VM
# Возвращает директорию, где лежат файлы этой виртуальной машины
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'vboxvm_dir'
then
	function vboxvm_dir { dirname "$(VBoxManage showvminfo "${vm_name[$1]}"|sed -nE '/^Config file:[[:space:]]+(\/.+\.vbox)$/ s//\1/p')";}
	readonly -f vboxvm_dir
fi

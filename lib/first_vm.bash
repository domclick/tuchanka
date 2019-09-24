# Возвращает первую виртуалку кластера
# $1 cluster ID
. "${lib_dir}/is_function_absent.bash"
. "${lib_dir}/first_word.bash"
if is_function_absent 'first_vm'
then
	function first_vm { first_word ${cluster_vms[$1]};}
	readonly -f first_vm
fi

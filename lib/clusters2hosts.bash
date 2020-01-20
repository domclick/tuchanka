# Позвращает список ID виртуалок которые составляют указаные кластера (группы)
# $@ Список ID кластеров
. "${lib_dir}/is_function_absent.bash"
if is_function_absent 'clusters2hosts'
then
	function clusters2hosts {
		local clusters_="$*"
		# Список имен хостов в кластере
		local hosts_=''
		for c in $clusters_
		do
			hosts_="${hosts_} ${cluster_vms[$c]}"
		done; unset c
		# remove leading ' '
		hosts_="${hosts_#' '}"
		echo "${hosts_}"
	}
	readonly -f clusters2hosts
fi

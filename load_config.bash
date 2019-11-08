# default_config.bash дефолтный конфиг из git, рабочий и достаточный
# если нужно внести изменения, то скопировать default_config.bash в config.bash и его уже править

# проверка на то, что конфиг еще не был загружен
if ! declare -p 'vboxnet_hostip' &>/dev/null
then
	if [ -s "${root_dir}/config.bash" ]
	then
		. "${root_dir}/config.bash"
	else
		. "${root_dir}/default_config.bash"
	fi
fi

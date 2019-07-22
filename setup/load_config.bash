# default_config.bash дефолтный конфиг из git, рабочий и достаточный
# если нужно внести изменения, то скопировать default_config.bash в config.bash и его уже править

# проверка на то, что конфиг еще не был загружен
if ! declare -p 'autoVirtualBox' &>/dev/null
then
	if [ -s "${setup_dir}/config.bash" ]
	then
		. "${setup_dir}/config.bash"
	else
		. "${setup_dir}/default_config.bash"
	fi
fi

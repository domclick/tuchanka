if [ -n "$PATH" ]
then
	PATH="${PATH}:/usr/pgsql-11/bin"
else
	export PATH='/usr/pgsql-11/bin'
fi

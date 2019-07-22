# default_config.bash дефолтный конфиг из git, рабочий и достаточный
# если нужно внести изменения, то скопировать default_config.bash в config.bash и его уже править

# $setup_dir уже должен быть определен (как правило используется для подключения этого конфига)

# Установка может идти в VirtualBox, в этом случае скрипты запускают
# команды VirtualBox (такие как создание скиншотов файловой системы, запуск и остановка виртуалок)
# автоматический. Для этого в config.bash должена быть раскомментирована строка autoVirtualBox='true'.
# Или при autoVirtualBox='false' установка не будет выполнять команды VirtualBox
# и сисадмин должен будет выполнять аналогичные действия вручную. Это нужно, например, для создания
# стенда на ноутах.
readonly autoVirtualBox='true'
#readonly autoVirtualBox='false'

# Местоположение внутренних файлов
readonly cib='/var/lib/pacemaker/cib/cib.xml'
# Версия PostgeSQL, используется в качестве суффикса в URL, названиях пакетов, путях у этих пакетов
readonly postgresql_version=11
# Мне выделили 192.168.89/24 подсетку для экспериментов, будет использоваться для связи серверов внутри кластера:
readonly vboxnet_prefix='192.168.89'
# Для хоста назначаю 192.168.89.254:
readonly vboxnet_hostip="${vboxnet_prefix}.254"
# ОЗУ и диск
readonly RAM_MiB=1024 VRAM_MiB=10 HDD_MiB=5120
# files
readonly common_dir="${setup_dir}/../common" pcs_dir="${setup_dir}/../pcs" heartbeat_dir="${setup_dir}/../heartbeat"
readonly ssh_config="${setup_dir}/ssh_config" ssh_known_hosts="${setup_dir}/ssh_known_hosts" hosts="${common_dir}/hosts"
readonly hacluster_password='ChangeMe'

Witness=251
vm_ip[$Witness]="${vboxnet_prefix}.${Witness}"
vm_name[$Witness]='Witness4Tuchanka'
vm_hostname[$Witness]='witness'
vm_groups[$Witness]='/Tuchanka'
vm_desc[$Witness]='Witness server for the Tuchanka cluster'

Tuchanka0a=1
vm_ip[$Tuchanka0a]="${vboxnet_prefix}.${Tuchanka0a}"
vm_name[$Tuchanka0a]='Tuchanka0a'
vm_hostname[$Tuchanka0a]='tuchanka0a'
vm_groups[$Tuchanka0a]='/Tuchanka/Tuchanka0'
vm_desc[$Tuchanka0a]='Tuchanka0a node of the Tuchanka0 cluster'

Tuchanka0b=2
vm_ip[$Tuchanka0b]="${vboxnet_prefix}.${Tuchanka0b}"
vm_name[$Tuchanka0b]='Tuchanka0b'
vm_hostname[$Tuchanka0b]='tuchanka0b'
vm_groups[$Tuchanka0b]='/Tuchanka/Tuchanka0'
vm_desc[$Tuchanka0b]='Tuchanka0b node of the Tuchanka0 cluster'

Tuchanka1a=11
vm_ip[$Tuchanka1a]="${vboxnet_prefix}.${Tuchanka1a}"
vm_name[$Tuchanka1a]='Tuchanka1a'
vm_hostname[$Tuchanka1a]='tuchanka1a'
vm_groups[$Tuchanka1a]='/Tuchanka/Tuchanka1'
vm_desc[$Tuchanka1a]='Tuchanka1a node of the Tuchanka1 cluster'

Tuchanka1b=12
vm_ip[$Tuchanka1b]="${vboxnet_prefix}.${Tuchanka1b}"
vm_name[$Tuchanka1b]='Tuchanka1b'
vm_hostname[$Tuchanka1b]='tuchanka1b'
vm_groups[$Tuchanka1b]='/Tuchanka/Tuchanka1'
vm_desc[$Tuchanka1b]='Tuchanka1b node of the Tuchanka1 cluster'

Tuchanka2a=21
vm_ip[$Tuchanka2a]="${vboxnet_prefix}.${Tuchanka2a}"
vm_name[$Tuchanka2a]='Tuchanka2a'
vm_hostname[$Tuchanka2a]='tuchanka2a'
vm_groups[$Tuchanka2a]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2a]='Tuchanka2a node of the Tuchanka2 cluster'

Tuchanka2b=22
vm_ip[$Tuchanka2b]="${vboxnet_prefix}.${Tuchanka2b}"
vm_name[$Tuchanka2b]='Tuchanka2b'
vm_hostname[$Tuchanka2b]='tuchanka2b'
vm_groups[$Tuchanka2b]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2b]='Tuchanka2b node of the Tuchanka2 cluster'

Tuchanka2c=23
vm_ip[$Tuchanka2c]="${vboxnet_prefix}.${Tuchanka2c}"
vm_name[$Tuchanka2c]='Tuchanka2c'
vm_hostname[$Tuchanka2c]='tuchanka2c'
vm_groups[$Tuchanka2c]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2c]='Tuchanka2c node of the Tuchanka2 cluster'

Tuchanka2d=24
vm_ip[$Tuchanka2d]="${vboxnet_prefix}.${Tuchanka2d}"
vm_name[$Tuchanka2d]='Tuchanka2d'
vm_hostname[$Tuchanka2d]='tuchanka2d'
vm_groups[$Tuchanka2d]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2d]='Tuchanka2d node of the Tuchanka2 cluster'
readonly Witness Tuchanka0a Tuchanka0b Tuchanka1a Tuchanka1b Tuchanka2a Tuchanka2b Tuchanka2c Tuchanka2d
readonly -a vm_name vm_ip vm_groups vm_desc

Krogan0a=101
float_ip[$Krogan0a]="${vboxnet_prefix}.${Krogan0a}"
float_hostname[$Krogan0a]='krogan0a'
db_port[$Krogan0a]=5433
db_master[$Krogan0a]=$Tuchanka0a
db_slaves[$Krogan0a]="$Tuchanka0b"
krogan_cluster[$Krogan0a]='krogan0'
Krogan0b=102
float_ip[$Krogan0b]="${vboxnet_prefix}.${Krogan0b}"
float_hostname[$Krogan0b]='krogan0b'
db_port[$Krogan0b]=5434
db_master[$Krogan0b]=$Tuchanka0b
db_slaves[$Krogan0b]="$Tuchanka0a"
Krogan1=103
float_ip[$Krogan1]="${vboxnet_prefix}.${Krogan1}"
float_hostname[$Krogan1]='krogan1'
db_port[$Krogan1]=5432
db_master[$Krogan1]=$Tuchanka1a
db_slaves[$Krogan1]="$Tuchanka1b"
krogan_cluster[$Krogan1]='krogan1'
Krogan1s1=104
float_ip[$Krogan1s1]="${vboxnet_prefix}.${Krogan1s1}"
float_hostname[$Krogan1s1]='krogan1s1'
Krogan2=105
float_ip[$Krogan2]="${vboxnet_prefix}.${Krogan2}"
float_hostname[$Krogan2]='krogan2'
db_port[$Krogan2]=5432
db_master[$Krogan2]=$Tuchanka2a
krogan_cluster[$Krogan2]='krogan2'
# several slaves separated by space
db_slaves[$Krogan2]="$Tuchanka2b $Tuchanka2c $Tuchanka2d"
Krogan2s1=106
float_ip[$Krogan2s1]="${vboxnet_prefix}.${Krogan2s1}"
float_hostname[$Krogan2s1]='krogan2s1'
Krogan2s2=107
float_ip[$Krogan2s2]="${vboxnet_prefix}.${Krogan2s2}"
float_hostname[$Krogan2s2]='krogan2s2'
Krogan2s3=108
float_ip[$Krogan2s3]="${vboxnet_prefix}.${Krogan2s3}"
float_hostname[$Krogan2s3]='krogan2s3'
readonly Krogan0a Krogan0b Krogan1 Krogan1s1 Krogan2 Krogan2s1 Krogan2s2 Krogan2s3
readonly -a float_ip float_hostname db_port db_master db_slaves
# default_config.bash дефолтный конфиг из git, рабочий и достаточный
# если нужно внести изменения, то скопировать default_config.bash в config.bash и его уже править

# $root_dir уже должен быть определен (как правило используется для подключения этого конфига)

# Установка может идти в VirtualBox, в этом случае скрипты запускают
# команды VirtualBox (такие как создание скиншотов файловой системы, запуск и остановка виртуалок)
# автоматический. Для этого в config.bash должена быть раскомментирована строка autoVirtualBox='true'.
# Или при autoVirtualBox='false' установка не будет выполнять команды VirtualBox
# и сисадмин должен будет выполнять аналогичные действия вручную. Это нужно, например, для создания
# стенда на ноутах.
readonly autoVirtualBox='true'
#readonly autoVirtualBox='false'

# Местоположение cib.xml в виртуалках
readonly cib='/var/lib/pacemaker/cib/cib.xml'
# Версия PostgeSQL, используется в качестве суффикса в URL, названиях пакетов, путях у этих пакетов
readonly postgresql_version=11
# Мне выделили 192.168.89/24 подсетку для экспериментов, будет использоваться для связи серверов внутри кластера:
readonly vboxnet_prefix='192.168.89'
# Для хоста назначаю 192.168.89.254:
readonly vboxnet_hostip="${vboxnet_prefix}.254"
# ОЗУ и диск, таймзона для виртуалок (в формате для unattended install)
readonly RAM_MiB=1024 VRAM_MiB=10 HDD_MiB=5120 time_zone='Europe/Moscow'
# really don't need to change in the test bed, password of hacluster unix user
readonly hacluster_password='ChangeMe'
# dirs
readonly setup_dir="${root_dir}/setup" lib_dir="${root_dir}/lib" test_dir="${root_dir}/test"
readonly common_dir="${root_dir}/common" pcs_dir="${root_dir}/pcs" heartbeat_dir="${root_dir}/heartbeat"
# files
readonly ssh_config="${root_dir}/ssh_config" ssh_known_hosts="${root_dir}/ssh_known_hosts" etc_hosts="${root_dir}/etc_hosts"

Witness=251
vm_ip[$Witness]="${vboxnet_prefix}.${Witness}"
vm_name[$Witness]='witness'
vm_group[$Witness]='/Tuchanka'
vm_desc[$Witness]='Witness server for the Tuchanka cluster'

Tuchanka0a=1
vm_ip[$Tuchanka0a]="${vboxnet_prefix}.${Tuchanka0a}"
vm_name[$Tuchanka0a]='tuchanka0a'
vm_group[$Tuchanka0a]='/Tuchanka/Tuchanka0'
vm_desc[$Tuchanka0a]='Tuchanka0a node of the Tuchanka0 cluster'

Tuchanka0b=2
vm_ip[$Tuchanka0b]="${vboxnet_prefix}.${Tuchanka0b}"
vm_name[$Tuchanka0b]='tuchanka0b'
vm_group[$Tuchanka0b]='/Tuchanka/Tuchanka0'
vm_desc[$Tuchanka0b]='Tuchanka0b node of the Tuchanka0 cluster'

Tuchanka1a=11
vm_ip[$Tuchanka1a]="${vboxnet_prefix}.${Tuchanka1a}"
vm_name[$Tuchanka1a]='tuchanka1a'
vm_group[$Tuchanka1a]='/Tuchanka/Tuchanka1'
vm_desc[$Tuchanka1a]='Tuchanka1a node of the Tuchanka1 cluster'

Tuchanka1b=12
vm_ip[$Tuchanka1b]="${vboxnet_prefix}.${Tuchanka1b}"
vm_name[$Tuchanka1b]='tuchanka1b'
vm_group[$Tuchanka1b]='/Tuchanka/Tuchanka1'
vm_desc[$Tuchanka1b]='Tuchanka1b node of the Tuchanka1 cluster'

Tuchanka2a=21
vm_ip[$Tuchanka2a]="${vboxnet_prefix}.${Tuchanka2a}"
vm_name[$Tuchanka2a]='tuchanka2a'
vm_group[$Tuchanka2a]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2a]='Tuchanka2a node of the Tuchanka2 cluster'

Tuchanka2b=22
vm_ip[$Tuchanka2b]="${vboxnet_prefix}.${Tuchanka2b}"
vm_name[$Tuchanka2b]='tuchanka2b'
vm_group[$Tuchanka2b]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2b]='Tuchanka2b node of the Tuchanka2 cluster'

Tuchanka2c=23
vm_ip[$Tuchanka2c]="${vboxnet_prefix}.${Tuchanka2c}"
vm_name[$Tuchanka2c]='tuchanka2c'
vm_group[$Tuchanka2c]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2c]='Tuchanka2c node of the Tuchanka2 cluster'

Tuchanka2d=24
vm_ip[$Tuchanka2d]="${vboxnet_prefix}.${Tuchanka2d}"
vm_name[$Tuchanka2d]='tuchanka2d'
vm_group[$Tuchanka2d]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2d]='Tuchanka2d node of the Tuchanka2 cluster'
readonly Witness Tuchanka0a Tuchanka0b Tuchanka1a Tuchanka1b Tuchanka2a Tuchanka2b Tuchanka2c Tuchanka2d
readonly -a vm_ip vm_name vm_group vm_desc

# ID БД совпадет с ID float_ip(float_name) на котором находится мастер
Krogan0a=101
float_ip[$Krogan0a]="${vboxnet_prefix}.${Krogan0a}"
# так же плавающий IP мастера БД
float_name[$Krogan0a]='krogan0a'
# Имена плавающих IP рабов
db_slaves[$Krogan0a]=''
db_port[$Krogan0a]=5433
db_setup_master[$Krogan0a]='tuchanka0a'
# адреса рабов	БД, которые используются при первичной настройке с помощью pg_ctl
# до создания кластера pacemaker
db_setup_slaves[$Krogan0a]='tuchanka0b'
Krogan0b=102
float_ip[$Krogan0b]="${vboxnet_prefix}.${Krogan0b}"
float_name[$Krogan0b]='krogan0b'
db_slaves[$Krogan0b]=''
db_port[$Krogan0b]=5434
db_setup_master[$Krogan0b]='tuchanka0b'
db_setup_slaves[$Krogan0b]='tuchanka0a'
Krogan1=103
float_ip[$Krogan1]="${vboxnet_prefix}.${Krogan1}"
float_name[$Krogan1]='krogan1'
db_slaves[$Krogan1]='krogan1s1'
db_port[$Krogan1]=5432
db_setup_master[$Krogan1]='tuchanka1a'
db_setup_slaves[$Krogan1]='tuchanka1b'
Krogan1s1=104
float_ip[$Krogan1s1]="${vboxnet_prefix}.${Krogan1s1}"
float_name[$Krogan1s1]='krogan1s1'
Krogan2=105
float_ip[$Krogan2]="${vboxnet_prefix}.${Krogan2}"
float_name[$Krogan2]='krogan2'
db_slaves[$Krogan2]='krogan2s1 krogan2s2 krogan2s3'
db_port[$Krogan2]=5432
db_setup_master[$Krogan2]='tuchanka2a'
# several slaves separated by space
db_setup_slaves[$Krogan2]='tuchanka2b tuchanka2c tuchanka2d'
Krogan2s1=106
float_ip[$Krogan2s1]="${vboxnet_prefix}.${Krogan2s1}"
float_name[$Krogan2s1]='krogan2s1'
Krogan2s2=107
float_ip[$Krogan2s2]="${vboxnet_prefix}.${Krogan2s2}"
float_name[$Krogan2s2]='krogan2s2'
Krogan2s3=108
float_ip[$Krogan2s3]="${vboxnet_prefix}.${Krogan2s3}"
float_name[$Krogan2s3]='krogan2s3'

readonly Krogan0a Krogan0b Krogan1 Krogan1s1 Krogan2 Krogan2s1 Krogan2s2 Krogan2s3
readonly -a float_ip float_name db_slaves db_port db_setup_master db_setup_slaves

# ID кластера совпадает с ID одной (первой) его машины, используется в выборе машины для отправки pcs команд на кластер
# Имя кластера, используется в pcs cluster setup
cluster_name[$Tuchanka0a]='krogan0'
# Все виртуалки кластера, двухмерные массивы в bash отсутствуют, имитирую списком разделенным пробелами
cluster_vms[$Tuchanka0a]='tuchanka0a tuchanka0b'
cluster_dbs[$Tuchanka0a]="$Krogan0a $Krogan0b"

cluster_name[$Tuchanka1a]='krogan1'
cluster_vms[$Tuchanka1a]='tuchanka1a tuchanka1b'
cluster_dbs[$Tuchanka1a]="$Krogan1"

cluster_name[$Tuchanka2a]='krogan2'
cluster_vms[$Tuchanka2a]='tuchanka2a tuchanka2b tuchanka2c tuchanka2d'
cluster_dbs[$Tuchanka2a]="$Krogan2"
readonly -a cluster_name cluster_vms cluster_dbs

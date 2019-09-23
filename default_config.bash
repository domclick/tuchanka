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
readonly RAM_MiB=768 VRAM_MiB=10 HDD_MiB=3072 time_zone='Europe/Moscow'
# really don't need to change in the test bed, password of hacluster unix user
readonly hacluster_password='ChangeMe'
# dirs
readonly setup_dir="${root_dir}/setup" lib_dir="${root_dir}/lib" test_dir="${root_dir}/test" upload_dir="${root_dir}/upload"
readonly common_dir="${upload_dir}/common" pcs_dir="${root_dir}/pcs" heartbeat_dir="${root_dir}/heartbeat"
# files
readonly ssh_config="${root_dir}/ssh_config" ssh_known_hosts="${root_dir}/ssh_known_hosts" etc_hosts="${root_dir}/etc_hosts"
# Команда, с помощью которой можно загрузить ключ в ssh-agent для работы с виртуалками
# Возможны варианты, поэтому команда вынесена в конфиг.
# В default_config эта команда загружает дефолтные ключи из ~/.ssh, пароли для них берет из keychain.
vm_ssh_load_key='ssh-add -A'

Witness=251
vm_ip[$Witness]="${vboxnet_prefix}.${Witness}"
vm_name[$Witness]='witness'
# Группа сервисных серверов, оказывающих услуги для всех кластеров, типа quorum device.
vm_group[$Witness]='/Tuchanka/Tuchanka0'
vm_desc[$Witness]='Witness server for the Tuchanka cluster'

Tuchanka1a=1
vm_ip[$Tuchanka1a]="${vboxnet_prefix}.${Tuchanka1a}"
vm_name[$Tuchanka1a]='tuchanka1a'
vm_group[$Tuchanka1a]='/Tuchanka/Tuchanka1'
vm_desc[$Tuchanka1a]='Tuchanka1a node of the Tuchanka1 cluster'

Tuchanka1b=2
vm_ip[$Tuchanka1b]="${vboxnet_prefix}.${Tuchanka1b}"
vm_name[$Tuchanka1b]='tuchanka1b'
vm_group[$Tuchanka1b]='/Tuchanka/Tuchanka1'
vm_desc[$Tuchanka1b]='Tuchanka1b node of the Tuchanka1 cluster'

Tuchanka2a=11
vm_ip[$Tuchanka2a]="${vboxnet_prefix}.${Tuchanka2a}"
vm_name[$Tuchanka2a]='tuchanka2a'
vm_group[$Tuchanka2a]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2a]='Tuchanka2a node of the Tuchanka2 cluster'

Tuchanka2b=12
vm_ip[$Tuchanka2b]="${vboxnet_prefix}.${Tuchanka2b}"
vm_name[$Tuchanka2b]='tuchanka2b'
vm_group[$Tuchanka2b]='/Tuchanka/Tuchanka2'
vm_desc[$Tuchanka2b]='Tuchanka2b node of the Tuchanka2 cluster'

Tuchanka4a=21
vm_ip[$Tuchanka4a]="${vboxnet_prefix}.${Tuchanka4a}"
vm_name[$Tuchanka4a]='tuchanka4a'
vm_group[$Tuchanka4a]='/Tuchanka/Tuchanka4'
vm_desc[$Tuchanka4a]='Tuchanka4a node of the Tuchanka4 cluster'

Tuchanka4b=22
vm_ip[$Tuchanka4b]="${vboxnet_prefix}.${Tuchanka4b}"
vm_name[$Tuchanka4b]='tuchanka4b'
vm_group[$Tuchanka4b]='/Tuchanka/Tuchanka4'
vm_desc[$Tuchanka4b]='Tuchanka4b node of the Tuchanka4 cluster'

Tuchanka4c=23
vm_ip[$Tuchanka4c]="${vboxnet_prefix}.${Tuchanka4c}"
vm_name[$Tuchanka4c]='tuchanka4c'
vm_group[$Tuchanka4c]='/Tuchanka/Tuchanka4'
vm_desc[$Tuchanka4c]='Tuchanka4c node of the Tuchanka4 cluster'

Tuchanka4d=24
vm_ip[$Tuchanka4d]="${vboxnet_prefix}.${Tuchanka4d}"
vm_name[$Tuchanka4d]='tuchanka4d'
vm_group[$Tuchanka4d]='/Tuchanka/Tuchanka4'
vm_desc[$Tuchanka4d]='Tuchanka4d node of the Tuchanka4 cluster'
readonly Witness Tuchanka1a Tuchanka1b Tuchanka2a Tuchanka2b Tuchanka4a Tuchanka4b Tuchanka4c Tuchanka4d
readonly -a vm_ip vm_name vm_group vm_desc

# ID БД совпадет с ID float_ip(float_name) на котором находится мастер
Krogan1a=101
float_ip[$Krogan1a]="${vboxnet_prefix}.${Krogan1a}"
# так же плавающий IP мастера БД
float_name[$Krogan1a]='krogan1a'
# Имена плавающих IP рабов
db_slaves[$Krogan1a]=''
db_port[$Krogan1a]=5433
db_setup_master[$Krogan1a]='tuchanka1a'
# адреса рабов	БД, которые используются при первичной настройке с помощью pg_ctl
# до создания кластера pacemaker
db_setup_slaves[$Krogan1a]='tuchanka1b'
Krogan1b=102
float_ip[$Krogan1b]="${vboxnet_prefix}.${Krogan1b}"
float_name[$Krogan1b]='krogan1b'
db_slaves[$Krogan1b]=''
db_port[$Krogan1b]=5434
db_setup_master[$Krogan1b]='tuchanka1b'
db_setup_slaves[$Krogan1b]='tuchanka1a'
Krogan2=103
float_ip[$Krogan2]="${vboxnet_prefix}.${Krogan2}"
float_name[$Krogan2]='krogan2'
db_slaves[$Krogan2]='krogan2s1'
db_port[$Krogan2]=5432
db_setup_master[$Krogan2]='tuchanka2a'
db_setup_slaves[$Krogan2]='tuchanka2b'
Krogan2s1=104
float_ip[$Krogan2s1]="${vboxnet_prefix}.${Krogan2s1}"
float_name[$Krogan2s1]='krogan2s1'
Krogan4=105
float_ip[$Krogan4]="${vboxnet_prefix}.${Krogan4}"
float_name[$Krogan4]='krogan4'
db_slaves[$Krogan4]='krogan4s1 krogan4s2 krogan4s3'
db_port[$Krogan4]=5432
db_setup_master[$Krogan4]='tuchanka4a'
# several slaves separated by space
db_setup_slaves[$Krogan4]='tuchanka4b tuchanka4c tuchanka4d'
Krogan4s1=106
float_ip[$Krogan4s1]="${vboxnet_prefix}.${Krogan4s1}"
float_name[$Krogan4s1]='krogan4s1'
Krogan4s2=107
float_ip[$Krogan4s2]="${vboxnet_prefix}.${Krogan4s2}"
float_name[$Krogan4s2]='krogan4s2'
Krogan4s3=108
float_ip[$Krogan4s3]="${vboxnet_prefix}.${Krogan4s3}"
float_name[$Krogan4s3]='krogan4s3'

readonly Krogan1a Krogan1b Krogan2 Krogan2s1 Krogan4 Krogan4s1 Krogan4s2 Krogan4s3
readonly -a float_ip float_name db_slaves db_port db_setup_master db_setup_slaves

# ID кластера совпадает с ID одной (первой) его машины, используется в выборе машины для отправки pcs команд на кластер
# Имя кластера, используется в pcs cluster setup
cluster_name[$Tuchanka1a]='tuchanka1'
# Все виртуалки кластера, двухмерные массивы в bash отсутствуют, имитирую списком разделенным пробелами
cluster_vms[$Tuchanka1a]='tuchanka1a tuchanka1b'
cluster_dbs[$Tuchanka1a]="$Krogan1a $Krogan1b"

cluster_name[$Tuchanka2a]='tuchanka2'
cluster_vms[$Tuchanka2a]='tuchanka2a tuchanka2b'
cluster_dbs[$Tuchanka2a]="$Krogan2"

cluster_name[$Tuchanka4a]='tuchanka4'
cluster_vms[$Tuchanka4a]='tuchanka4a tuchanka4b tuchanka4c tuchanka4d'
cluster_dbs[$Tuchanka4a]="$Krogan4"
readonly -a cluster_name cluster_vms cluster_dbs

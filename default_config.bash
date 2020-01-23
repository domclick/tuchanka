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
# Местоположение pgsql директории на виртуалках
readonly pgsql_dir='/var/lib/pgsql' # в upload/common/postgresql.conf независимо прописан путь /var/lib/pgsql
# Версия PostgeSQL, используется в качестве суффикса в URL, названиях пакетов, путях у этих пакетов
readonly postgresql_version=11
# Мне выделили 192.168.89/24 подсетку для экспериментов, будет использоваться для связи серверов внутри кластера:
readonly vboxnet_prefix='192.168.89'
# Для хоста назначаю 192.168.89.254:
readonly vboxnet_hostip="${vboxnet_prefix}.254"
readonly vm_domain='vault'
# ОЗУ и диск, таймзона для виртуалок (в формате для unattended install)
readonly CPUs=2 CPU_execution_cap=50 RAM_MiB=768 VRAM_MiB=10 HDD_MiB=3072 time_zone='Europe/Moscow'
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
readonly vm_ssh_load_key='ssh-add -A'

# Cluster ID
# Номера кластеров, оформленны в виде переменных, чтобы потом было удобнее искать их использовать.
# 0 фиктивный кластер, по сути это группа серверов общего пользования для оказания вспомогательных услуг.
readonly Group0=0 Cluster1=1 Cluster2=2 Cluster3=3 Cluster4=4

readonly Witness=1
vm_ip[$Witness]="${vboxnet_prefix}.${Witness}"
vm_name[$Witness]='witness'
# Группа сервисных серверов, оказывающих услуги для всех кластеров, типа quorum device.
vm_group[$Witness]=$Group0
vm_desc[$Witness]='Witness server for the Tuchanka cluster'
vm_cursor[$Witness]='#ffd75f'
vm_prompt[$Witness]='221'

readonly Tuchanka1a=11
vm_ip[$Tuchanka1a]="${vboxnet_prefix}.${Tuchanka1a}"
vm_name[$Tuchanka1a]='tuchanka1a'
vm_group[$Tuchanka1a]=$Cluster1
vm_desc[$Tuchanka1a]='Tuchanka1a node of the Tuchanka1 cluster'
vm_cursor[$Tuchanka1a]='#87ff00'
vm_prompt[$Tuchanka1a]='118'

readonly Tuchanka1b=12
vm_ip[$Tuchanka1b]="${vboxnet_prefix}.${Tuchanka1b}"
vm_name[$Tuchanka1b]='tuchanka1b'
vm_group[$Tuchanka1b]=$Cluster1
vm_desc[$Tuchanka1b]='Tuchanka1b node of the Tuchanka1 cluster'
vm_cursor[$Tuchanka1b]='#00ff87'
vm_prompt[$Tuchanka1b]='48'

readonly Tuchanka2a=21
vm_ip[$Tuchanka2a]="${vboxnet_prefix}.${Tuchanka2a}"
vm_name[$Tuchanka2a]='tuchanka2a'
vm_group[$Tuchanka2a]=$Cluster2
vm_desc[$Tuchanka2a]='Tuchanka2a node of the Tuchanka2 cluster'
vm_cursor[$Tuchanka2a]='#00ffd7'
vm_prompt[$Tuchanka2a]='50'

readonly Tuchanka2b=22
vm_ip[$Tuchanka2b]="${vboxnet_prefix}.${Tuchanka2b}"
vm_name[$Tuchanka2b]='tuchanka2b'
vm_group[$Tuchanka2b]=$Cluster2
vm_desc[$Tuchanka2b]='Tuchanka2b node of the Tuchanka2 cluster'
vm_cursor[$Tuchanka2b]='#5fd7ff'
vm_prompt[$Tuchanka2b]='81'

readonly Tuchanka3a=31
vm_ip[$Tuchanka3a]="${vboxnet_prefix}.${Tuchanka3a}"
vm_name[$Tuchanka3a]='tuchanka3a'
vm_group[$Tuchanka3a]=$Cluster3
vm_desc[$Tuchanka3a]='Tuchanka3a node of the Tuchanka3 cluster'
vm_cursor[$Tuchanka3a]='#0087ff'
vm_prompt[$Tuchanka3a]='33'

readonly Tuchanka3b=32
vm_ip[$Tuchanka3b]="${vboxnet_prefix}.${Tuchanka3b}"
vm_name[$Tuchanka3b]='tuchanka3b'
vm_group[$Tuchanka3b]=$Cluster3
vm_desc[$Tuchanka3b]='Tuchanka3b node of the Tuchanka3 cluster'
vm_cursor[$Tuchanka3b]='#5f5fff'
vm_prompt[$Tuchanka3b]='63'

readonly Tuchanka3c=33
vm_ip[$Tuchanka3c]="${vboxnet_prefix}.${Tuchanka3c}"
vm_name[$Tuchanka3c]='tuchanka3c'
vm_group[$Tuchanka3c]=$Cluster3
vm_desc[$Tuchanka3c]='Tuchanka3c node of the Tuchanka3 cluster'
vm_cursor[$Tuchanka3c]='#8700ff'
vm_prompt[$Tuchanka3c]='93'

readonly Tuchanka4a=41
vm_ip[$Tuchanka4a]="${vboxnet_prefix}.${Tuchanka4a}"
vm_name[$Tuchanka4a]='tuchanka4a'
vm_group[$Tuchanka4a]=$Cluster4
vm_desc[$Tuchanka4a]='Tuchanka4a node of the Tuchanka4 cluster'
vm_cursor[$Tuchanka4a]='#ff00ff'
vm_prompt[$Tuchanka4a]='201'

readonly Tuchanka4b=42
vm_ip[$Tuchanka4b]="${vboxnet_prefix}.${Tuchanka4b}"
vm_name[$Tuchanka4b]='tuchanka4b'
vm_group[$Tuchanka4b]=$Cluster4
vm_desc[$Tuchanka4b]='Tuchanka4b node of the Tuchanka4 cluster'
vm_cursor[$Tuchanka4b]='#ff00d7'
vm_prompt[$Tuchanka4b]='200'

readonly Tuchanka4c=43
vm_ip[$Tuchanka4c]="${vboxnet_prefix}.${Tuchanka4c}"
vm_name[$Tuchanka4c]='tuchanka4c'
vm_group[$Tuchanka4c]=$Cluster4
vm_desc[$Tuchanka4c]='Tuchanka4c node of the Tuchanka4 cluster'
vm_cursor[$Tuchanka4c]='#ff00af'
vm_prompt[$Tuchanka4c]='199'

readonly Tuchanka4d=44
vm_ip[$Tuchanka4d]="${vboxnet_prefix}.${Tuchanka4d}"
vm_name[$Tuchanka4d]='tuchanka4d'
vm_group[$Tuchanka4d]=$Cluster4
vm_desc[$Tuchanka4d]='Tuchanka4d node of the Tuchanka4 cluster'
vm_cursor[$Tuchanka4d]='#ff0087'
vm_prompt[$Tuchanka4d]='198'
readonly -a vm_ip vm_name vm_group vm_desc vm_cursor vm_prompt

# ID БД совпадет с ID float_ip(float_name) на котором находится мастер
readonly Krogan1a=15
float_ip[$Krogan1a]="${vboxnet_prefix}.${Krogan1a}"
# так же плавающий IP мастера БД
float_name[$Krogan1a]='krogan1a'
# Имена плавающих IP рабов
db_slaves[$Krogan1a]=''
db_port[$Krogan1a]=5433
db_setup_master[$Krogan1a]="$Tuchanka1a"
# адреса рабов	БД, которые используются при первичной настройке с помощью pg_ctl
# до создания кластера pacemaker
db_setup_slaves[$Krogan1a]="$Tuchanka1b"

readonly Krogan1b=16
float_ip[$Krogan1b]="${vboxnet_prefix}.${Krogan1b}"
float_name[$Krogan1b]='krogan1b'
db_slaves[$Krogan1b]=''
db_port[$Krogan1b]=5434
db_setup_master[$Krogan1b]="$Tuchanka1b"
db_setup_slaves[$Krogan1b]="$Tuchanka1a"

readonly Krogan2=25
float_ip[$Krogan2]="${vboxnet_prefix}.${Krogan2}"
float_name[$Krogan2]='krogan2'
db_slaves[$Krogan2]='krogan2s1'
db_port[$Krogan2]=5432
db_setup_master[$Krogan2]="$Tuchanka2a"
db_setup_slaves[$Krogan2]="$Tuchanka2b"
readonly Krogan2s1=26
float_ip[$Krogan2s1]="${vboxnet_prefix}.${Krogan2s1}"
float_name[$Krogan2s1]='krogan2s1'

readonly Krogan3=35
float_ip[$Krogan3]="${vboxnet_prefix}.${Krogan3}"
float_name[$Krogan3]='krogan3'
db_slaves[$Krogan3]='krogan3s1 krogan3s2'
db_port[$Krogan3]=5432
db_setup_master[$Krogan3]="$Tuchanka3a"
# several slaves separated by space
db_setup_slaves[$Krogan3]="$Tuchanka3b $Tuchanka3c"
readonly Krogan3s1=36
float_ip[$Krogan3s1]="${vboxnet_prefix}.${Krogan3s1}"
float_name[$Krogan3s1]='krogan3s1'
readonly Krogan3s2=37
float_ip[$Krogan3s2]="${vboxnet_prefix}.${Krogan3s2}"
float_name[$Krogan3s2]='krogan3s2'

readonly Krogan4=45
float_ip[$Krogan4]="${vboxnet_prefix}.${Krogan4}"
float_name[$Krogan4]='krogan4'
db_slaves[$Krogan4]='krogan4s1 krogan4s2 krogan4s3'
db_port[$Krogan4]=5432
db_setup_master[$Krogan4]="$Tuchanka4a"
# several slaves separated by space
db_setup_slaves[$Krogan4]="$Tuchanka4b $Tuchanka4c $Tuchanka4d"
readonly Krogan4s1=46
float_ip[$Krogan4s1]="${vboxnet_prefix}.${Krogan4s1}"
float_name[$Krogan4s1]='krogan4s1'
readonly Krogan4s2=47
float_ip[$Krogan4s2]="${vboxnet_prefix}.${Krogan4s2}"
float_name[$Krogan4s2]='krogan4s2'
readonly Krogan4s3=48
float_ip[$Krogan4s3]="${vboxnet_prefix}.${Krogan4s3}"
float_name[$Krogan4s3]='krogan4s3'

readonly -a float_ip float_name db_slaves db_port db_setup_master db_setup_slaves

# Все виртуалки кластера, двухмерные массивы в bash отсутствуют, имитирую списком разделенным пробелами
cluster_vms[$Group0]="$Witness"

cluster_vms[$Cluster1]="$Tuchanka1a $Tuchanka1b"
cluster_dbs[$Cluster1]="$Krogan1a $Krogan1b"
cluster_hb1[$Cluster1]="'${heartbeat_dir}/heart1a'"
cluster_hb2[$Cluster1]="'${heartbeat_dir}/heart1b'"

cluster_vms[$Cluster2]="$Tuchanka2a $Tuchanka2b"
cluster_dbs[$Cluster2]="$Krogan2"
cluster_hb1[$Cluster2]="'${heartbeat_dir}/heart2'"
cluster_hb2[$Cluster2]="'${heartbeat_dir}/reader2'"

cluster_vms[$Cluster3]="$Tuchanka3a $Tuchanka3b $Tuchanka3c"
cluster_dbs[$Cluster3]="$Krogan3"
cluster_hb1[$Cluster3]="'${heartbeat_dir}/heart3'"
cluster_hb2[$Cluster3]="'${heartbeat_dir}/reader3'"

cluster_vms[$Cluster4]="$Tuchanka4a $Tuchanka4b $Tuchanka4c $Tuchanka4d"
cluster_dbs[$Cluster4]="$Krogan4"
cluster_hb1[$Cluster4]="'${heartbeat_dir}/heart4'"
cluster_hb2[$Cluster4]="'${heartbeat_dir}/reader4'"
readonly -a cluster_vms cluster_dbs cluster_hb1 cluster_hb2

# http proxy url
# http proxy должна быть устойчива к эффекту громоподобного стада при первой загрузке
# например squid с опцией collapsed_forwarding on
readonly proxy_url="http://${vm_name[$Witness]}.${vm_domain}:3128"

readonly tmux_default_socket='Tuchanka' tmux_session='Tuchanka' tmux_window='Tuchanka'

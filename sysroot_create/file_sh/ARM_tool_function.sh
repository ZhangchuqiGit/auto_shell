#! /bin/bash

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

################################################################

RootPath=$(pwd)
# DebugOutLog="zcq_debug.log" # 调试日志输出
# Clash_proxychains="proxychains4" # 使用代理
# Time_launch="$(date +%Y.%m.%d_%H.%M.%S)"
Time_launch=$(date +%Y.%m.%d_%H.%M)

################################################################

if [ -z "${Sudo}" ]; then
	Sudo="sudo"
fi
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

# 调试日志输出
if [ -n "${DebugOutLog}" ]; then
	DebugOutLog=${RootPath}/${DebugOutLog}
	if [ ! -f "${DebugOutLog}" ]; then
		${Sudo} rm -rf ${DebugOutLog}
	fi
	if [ ! -e "${DebugOutLog}" ]; then
		echo &>${DebugOutLog}
	fi
fi

if [ -z "${Clash_proxychains}" ]; then
	# Clash_proxychains="proxychains4"
	Clash_proxychains=" "
fi

func_log() {
	if [ -n "${DebugOutLog}" ] && [ -f "${DebugOutLog}" ]; then
		local Time_tmp
		Time_tmp="$(date +%Y.%m.%d_%H.%M.%S)"
		echo "'${Time_tmp}' $*" &>>${DebugOutLog}
	fi
}

Echo_Num_x=30
Echo_Num_y=47
func_echo_loop() {
	if [ ${Echo_Num_x} -gt 37 ]; then
		Echo_Num_x=30
	fi
	if [ ${Echo_Num_y} -lt 40 ]; then
		Echo_Num_y=47
	fi
	echo -e "\033[1;7;${Echo_Num_x};${Echo_Num_y}m $* \e[0m"
	Echo_Num_x=$((${Echo_Num_x} + 1))
	Echo_Num_y=$((${Echo_Num_y} - 1))
}

func_echo() {
	local slt=$1
	case ${slt} in
	-v) # -variable 变量
		shift
		#echo -e " \033[3;7;37;44mVariable\e[0m (\033[37;44m $* \e[0m)"
		func_echo_loop "(Variable) $*"
		func_log "(Variable) $*"
		;;
	-p) # path or file
		shift
		echo -e " \033[3;7;36;40m[Path]\e[0m [\033[36;40m $* \e[0m]"
		func_log "[Path] $*"
		;;
	-e) # error 错误
		shift
		echo -e " \033[1;5;7;30;41m !!! 错误 \e[0m\033[30;41m $* \e[0m"
		func_log "!!! 错误  $*"
		;;
	-c) # shell 命令
		shift
		echo -e " \033[1;3;5;32m\$ \e[0m\033[1;32;40m $* \e[0m"
		func_log "$*"
		;;
	*) # 描述信息
		echo -e "\033[36m $* \e[0m"
		# func_echo_loop "$*"
		;;
	esac
	#	unset slt
}

# func_execute 执行语句 成功与否打印
func_execute() {
	func_echo -c "$*"
	$@
}
func_execute_sudo() {
	func_execute "${Sudo} $*"
}
func_execute_err() {
	# ${?}=0
	func_execute "$@"
	local ret=$?
	if [ $ret -ne 0 ]; then
		func_echo -e "ret=$ret 执行 $*"
		exit $ret
	fi
}
func_execute_err_sudo() {
	func_execute_err "${Sudo} $*"
}
# func_execute pwd ; ifconfig
# func_execute mkdir -m 777 -p -v file # 创建文件夹

## 安装、更新  *.dep
func_apt() {
	#	declare -i mode
	local mode=" "
	while [ $# -gt 0 ]; do
		case "$1" in
		-a)
			func_execute_sudo apt autoremove -y # --allow-unauthenticated
			func_execute_sudo apt autoclean -y  # --allow-unauthenticated
			;;
		-d)
			# func_execute ${Sudo} ${Clash_proxychains} apt update -y
			func_execute ${Sudo} ${Clash_proxychains} apt update -y --fix-missing
			;;
		-g)
			func_execute ${Sudo} ${Clash_proxychains} apt upgrade -y # --allow-unauthenticated
			;;
		-f)
			func_execute_sudo ${Clash_proxychains} apt install -y -f # --allow-unauthenticated
			;;
		-i)
			mode="-i"
			;;
		-ii)
			mode="-ii"
			;;
		-r)
			mode="-r"
			;;
		*)
			if [ "${mode}" = "-i" ]; then
				func_execute_sudo ${Clash_proxychains} apt install -y --allow-unauthenticated $1 -f
			elif [ "${mode}" = "-ii" ]; then
				func_execute_sudo ${Clash_proxychains} aptitude install -y --allow-unauthenticated $1 -f
			elif [ "${mode}" = "-r" ]; then
				func_execute_sudo apt remove -y --purge $1 --allow-unauthenticated
			fi
			;;
		esac
		shift
	done
}

func_apt_repository() {
	#	Examples:
	#        apt-add-repository 'deb http://myserver/path/to/repo stable myrepo'
	#        apt-add-repository 'http://myserver/path/to/repo myrepo'
	#        apt-add-repository 'https://packages.medibuntu.org free non-free'
	#        apt-add-repository http://extras.ubuntu.com/ubuntu
	#        apt-add-repository ppa:user/repository
	#        apt-add-repository ppa:user/distro/repository
	#        apt-add-repository multiverse
	while [ $# -gt 0 ]; do
		#		func_echo -c "${Sudo} ${Clash_proxychains} add-apt-repository $1"
		func_execute_sudo ${Clash_proxychains} add-apt-repository -y "$1"
		func_apt -d -f
		shift
	done
}

func_cd() {
	func_echo -c "cd $1"
	cd $1 || exit 50
}

func_gedit() {
	while [ $# -gt 0 ]; do
		func_echo -c "${Sudo} gedit $1 &>/dev/null"
		${Sudo} gedit $1 &>/dev/null
		shift
	done
}

func_cpf() {
	if [ $# -ne 2 ]; then
		func_echo -e "func_cpl: \$#=$# is != 2"
		exit 7
	fi
	local source="$1"
	local target="$2"
	func_execute_sudo cp -raf "${source}" "${target}"
}

func_cp() {
	if [ $# -ne 2 ]; then
		func_echo -e "func_cpl: \$#=$# is != 2"
		exit 6
	fi
	local source="$1"
	local target="$2"
	func_execute_sudo cp -ra "${source}" "${target}"
}
# func_cpl lib/\* zcq/lib/

func_cpl() {
	if [ $# -ne 2 ]; then
		func_echo -e "func_cpl: \$#=$# is != 2"
		exit 5
	fi
	local source="$1"
	local target="$2"
	func_execute_sudo cp -rad "${source}" "${target}"
}

func_dpkg() {
	# for file in $(ls *.deb)
	# sudo dpkg -i *.deb
	func_apt -d -f
	func_execute_sudo dpkg --add-architecture i386 # 准备添加32位支持
	func_execute_sudo dpkg --configure -a
	while [ $# -gt 0 ]; do
		func_execute_sudo dpkg -i $1
		func_apt -f
		shift
	done
}

func_chmod() {
	local mode=$1
	if [ $# -lt 2 ]; then
		exit 2
	fi
	shift
	func_execute_sudo chmod -R ${mode} "$@"
}
# func_chmod 775 ${RootPath} ./path

func_touch() {
	local mode=$1
	if [ $# -lt 2 ]; then
		exit 3
	fi
	shift
	func_execute_sudo touch "$@"
	func_execute_sudo chmod -R ${mode} "$@"
}
# func_touch 775 file01 file02

func_path_isexit() {
	local targetpath=""
	if [ $# -gt 2 ]; then
		exit 20
	fi
	if [ $# -eq 1 ]; then
		targetpath="$1"
		if [ ! -d "${targetpath}" ]; then
			func_echo -e "no exit: ${targetpath}"
			exit 21
		fi
	else
		targetpath="$2"
		if [ -d "${targetpath}" ]; then
			func_echo -p "$1 : ${targetpath}"
		else
			func_echo -e "no exit: $1 : ${targetpath}"
			exit 22
		fi
	fi
}
# func_path_isexit "is exit" /home/zcq

func_mkdir() {
	local mode=$1
	if [ $# -lt 2 ]; then
		exit 4
	fi
	shift
	# func_echo -c "${Sudo} mkdir -m ${mode} -p -v \ "
	# while [ $# -gt 0 ]; do
	# 	echo -e "$1 \c"
	func_execute_sudo mkdir -m ${mode} -p "$@" # 创建文件夹
	# 	${Sudo} mkdir -m ${mode} -p $1 # 创建文件夹
	# 	shift
	# done
	# echo
}
# func_mkdir 775 file/01 file/02

################################################################

func_echo -p "当前路径    ${RootPath}"
func_echo -v "使用代理    ${Clash_proxychains}"
func_echo -p "调试日志输出 ${DebugOutLog}"
func_echo "--------------------------------------"

#!/bin/bash

################################################################
if [ -z "${Sudo}" ]; then
	Sudo="sudo"
fi
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

################################################################
if [ -z "${Rootpath}" ]; then
	Rootpath=$1
	if [ ! -d "${Rootpath}" ]; then
		Rootpath=""
	fi
	if [ -z "${Rootpath}" ]; then
		Rootpath=$(pwd)
	fi
fi

if [ -z "${Clash_proxychains}" ]; then
	Clash_proxychains=""
fi

#if false; then
if true; then
	if [ -z "${DebugOutLog}" ]; then
		DebugOutLog="zcq_debug.log"
		DebugOutLog=${Rootpath}/${DebugOutLog}
	fi
	if [ ! -f "${DebugOutLog}" ]; then
		${Sudo} rm -rf ${DebugOutLog}
	fi
	if [ ! -e "${DebugOutLog}" ]; then
		echo &>${DebugOutLog}
	fi
fi

######################### function() ##############################
func_log() {
	if [ -n "${DebugOutLog}" ]; then
		local Time
		Time="$(date +%Y.%m.%d_%H.%M.%S)"
		echo "'${Time}'  $*" &>>${DebugOutLog}
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
			func_echo_loop "Variable ( $* )"
			func_log "Variable ( $* )"
			;;
		-p) # path or file
			shift
			echo -e " \033[3;7;36;40mPath\e[0m [\033[36;40m $* \e[0m]"
			func_log "Path [ $* ]"
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
			echo -e "\n \033[35m $* \e[0m"
			#func_echo_loop "$*"
			;;
	esac
	#	unset slt
}

# execute 执行语句 成功与否打印
func_execute() {
	func_echo -c "$*"
	$@
}
func_execute_sudo() {
	func_execute "${Sudo} $*"
}
func_execute_err() {
	$?=0
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
# execute pwd ; ifconfig
# execute mkdir -m 777 -p -v file # 创建文件夹

## 安装、更新  *.dep
func_apt() {
	#	declare -i mode
	local mode=" "
	while [ $# -gt 0 ]; do
		case "$1" in
			-a)
				func_execute_sudo apt autoremove -y
				func_execute_sudo apt autoclean -y
				;;
			-d)
				func_execute ${Sudo} ${Clash_proxychains} apt update -y
				func_execute ${Sudo} ${Clash_proxychains} apt update -y --fix-missing
				;;
			-g)
				func_execute ${Sudo} ${Clash_proxychains} apt upgrade -y
				;;
			-f)
				func_execute_sudo ${Clash_proxychains} apt install -y -f
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
					func_execute_sudo ${Clash_proxychains} apt install -y $1 -f
				elif [ "${mode}" = "-ii" ]; then
					func_execute_sudo ${Clash_proxychains} aptitude install -y $1 -f
				elif [ "${mode}" = "-r" ]; then
					func_execute_sudo apt remove -y --purge $1
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
	func_echo -c "cd $1 || exit"
	cd $1 || exit
}

func_gedit() {
	while [ $# -gt 0 ]; do
		func_echo -c "${Sudo} gedit $1 &>/dev/null"
		${Sudo} gedit $1 &>/dev/null
		shift
	done
}

func_cpf() {
	local source="$1"
	local target="$2"
	if [ -e "${source}" ]; then
		if [ -d "${target}" ]; then
			if [ ! -w "${target}" ]; then
				func_execute_sudo cp -af ${source} ${target}
			else
				func_execute cp -af ${source} ${target}
			fi
		else
			# $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
			# $(basename $Rootpath) # 取出文件: zcq_Create_rootfs
			if [ ! -w "$(dirname ${target})" ]; then
				func_execute_sudo cp -af ${source} ${target}
			else
				func_execute cp -af ${source} ${target}
			fi
		fi
	else
		func_echo -e "shell cp 不存在 ${source}"
	fi
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

######################### function() ##############################
func_system_sudo_close() {
	func_echo "关闭 sudo 密码 ; 修改:  %sudo ALL=(ALL:ALL) NOPASSWD:ALL "
	func_gedit /etc/sudoers
}

func_disk_auto() {
	func_echo "action : 系统自动挂载NTFS硬盘
	查看硬盘情况
	$ sudo fdisk -l
	查看分区个数
	$ ls -l /dev/sd*

# 设置开机自动挂载NTFS分区
# 查看分区：sudo fdisk --list ; 更新设置命令: sudo mount -a
# /etc/fstab 文件一共有 六列

# [Device]  [挂载点]  [文件系统]  [设置挂载分区的特性]  [能否被 dump 备份命令作用]  [是否检验扇区]
# 第一列     第二列    第三列      第四列              第五列                    第六列

# [第一列 Device]: 	磁盘设备文件 或者 该设备的 Label 或者 UUID 。
# [第二列 挂载点]: 	表示你要挂载到哪个目录下。
# [第三列 文件系统]: 	磁盘文件系统的格式，包括 ext4、reiserfs、ntfs、vfat 等
# 	NTFS: 			ntfs-3g 或 ntfs (在Ubuntu20.04中ntfs是链接到ntfs-3g的);
#	FAT32或FAT16或FAT: 	vfat ;
#	自动检测文件系统 : 	auto 。
# [第四列 设置挂载分区的特性]:
# 	auto 和 noauto ：当 mount -a 的命令时，此文件系统是否被主动挂载, 默认为 auto
# 	user 和 nouser ：user 选项允许普通用户也能挂载设备，而 nouser 只允许root用户挂载
# 	exec 和 noexec ：exec 允许执行对应分区中的可执行二进制程序，noexec 作用相反
# 	rw 和 ro ：该分区 rw 读写模式; ro 只读,不论此文件系统的文件是否配置 w 权限，都无法写入！
# 	sync 和 async ：sync 同步,命令立即生效 ; async 异步,命令后很久生效 ; 默认为 async
# 	suid 和 nosuid ：如果不是运行文件放置目录，可以配置为 nosuid 来取消这个功能
# 	Usrquota : 启动文件系统 支持 磁盘 配额模式
# 	Grpquota : 启动文件系统 对 群组 磁盘 配额模式的支持
# 	defaults ：同时具有 auto, nouser, exec, rw, async, suid, dev, 等参数
# [第五列 能否被 dump 备份命令作用]: dump 是一个用来作为备份的命令
# 	0	代表不要做 dump 备份
# 	1	代表要每天进行 dump 的操作
# 	2	代表不定日期的进行 dump 的操作
# [第六列 是否检验扇区]: 开机的过程中，系统默认会以 fsck 检验我们系统是否为完整（clean）
# 	0	不要检验
# 	1	最早检验（一般根目录会选择）
# 	2	1级别检验完成之后进行检验

auto - 在启动时或键入了 mount -a 命令时自动挂载。
noauto - 只在你的命令下被挂载。
exec - 允许执行此分区的二进制文件。
noexec - 不允许执行此文件系统上的二进制文件。
ro - 以只读模式挂载文件系统。
rw - 以读写模式挂载文件系统。
user - 允许任意用户挂载此文件系统，若无显示定义，隐含启用 noexec, nosuid, nodev 参数。
users - 允许所有 users 组中的用户挂载文件系统.
nouser - 只能被 root 挂载。
owner - 允许设备所有者挂载.
sync - I/O 同步进行。
async - I/O 异步进行。
dev - 解析文件系统上的块特殊设备。
nodev - 不解析文件系统上的块特殊设备。
suid - 允许 suid 操作和设定 sgid 位。这一参数通常用于一些特殊任务，使一般用户运行程序时临时提升权限。
nosuid - 禁止 suid 操作和设定 sgid 位。
noatime - 不更新文件系统上 inode 访问记录，可以提升性能。
nodiratime - 不更新文件系统上的目录 inode 访问记录，可以提升性能(参见 atime 参数)。
relatime - 实时更新 inode access 记录。只有在记录中的访问时间早于当前访问才会被更新。（与 noatime 相似，但不会打断如 mutt 或其它程序探测文件在上次访问后是否被修改的进程。），可以提升性能。
flush - vfat 的选项，更频繁的刷新数据，复制对话框或进度条在全部数据都写入后才消失。
defaults - 使用文件系统的默认挂载参数，例如 ext4 的默认参数为:rw, suid, dev, exec, auto, nouser, async.

2.挂载光盘
     a.mkdir  /mnt/cdrom/      建立挂载点
     b.mount -t iso9660 /dev/cdrom  /mnt/cdrom  挂载
     c.umount   /mnt/cdrom     卸载
3.挂载U盘
     a.fdisk -l  查看U盘设备文件名
     b.mount -t vfat /dev/sdb1 /mnt/USB/       fat32 识别为vfat ，fat16识别为fat
4.挂载移动硬盘（Linux默认不识别NTFS格式）
     a.下载NTFS-3G 
     b.使用gcc 安装
     c.mount -t ntfs-3g  /dev/sda5  /mnt/USB/  （可以参考NTFS-3g官网

\!\!\!\!\!\!\!\!  

修改 /etc/fstab 文件 并添加 : ----------------------------
#/dev/sda4 /media/zcq/office ntfs rw,suid,nodev,exec,auto,users,async 0 0
#/dev/sda5 /media/zcq/data ntfs rw,suid,nodev,exec,auto,users,async 0 0 

/dev/sda4 /media/zcq/office auto defaults 0 1
/dev/sda5 /media/zcq/data auto defaults 0 1 "
	func_gedit /etc/fstab
	func_execute_sudo mount -a
	echo "----- 支持 exfat"
	func_apt -i exfat-fuse exfat-utils
}

func_system_time_set() {
	func_echo "统一 Win10 和 Ubuntu 双系统的时间 ; 修改:  "
	func_execute_sudo timedatectl set-local-rtc 1 --adjust-system-clock
	# 更新ubuntu的系统时间
	func_apt -i ntpdate
	func_execute_sudo ntpdate time.windows.com
	# 将时间更新到硬件上
	func_execute_sudo hwclock --localtime --systohc
}

func_clash_input() {
	func_echo "请在 ' 新 ' 终端输入 $ clash ; 请在设置中启动网络代理 ; 修改:  "
	echo -n "part 1 --------------------------设置网络代理
		设置>网络代理:
				HTTP 代理   127.0.0.1  7890
				HTTPS 代理  127.0.0.1  7890
				FTP 代理    127.0.0.1  7890
				Socks 主机  127.0.0.1  7891
part 2 --------------------------新打开终端，输入 $ clash
已完成 y or n [ n ] : "
	local read_date
	read read_date
	if [ "${read_date}" = "y" ]; then
		func_echo "使用 网络代理！"
		Clash_proxychains="proxychains" # 使用网络代理
	else
		func_echo "不 使用网络代理！"
		Clash_proxychains=""
	fi
}

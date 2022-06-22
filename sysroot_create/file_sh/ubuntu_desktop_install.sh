#! /bin/bash

# ./1_prepare.sh ${DIR_base_rootfs}

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

if [ -z "$1" ]; then
	source /opt/ARM_tool_function.sh
fi

################################################################

f_nfs() {
	func_echo_loop "nfs 服务搭建"
	func_echo "开发板的文件系统放在 PC 端（Ubuntu） ， 
    开发板的文件系统类型设置为 nfs， 就可以挂载文件系统了。"

	func_echo "01 - 安装 nfs 服务"
	func_apt -i nfs-kernel-server rpcbind
	func_apt -i nfs-common libnfs-utils

	func_echo "02 - 创建文件夹，存放开发板的根文件系统 "
	func_mkdir 777 ~/arm_nfs

	func_echo "03 - 更改配置文件 /etc/exports 
    # 文件末尾添加：

    /home/${USER}/arm_nfs *(rw,sync,no_root_squash)

    # rw ： 读写访问
    # sync ： 所有数据在请求时写入共享
    # async ： NFS 在写入数据前可以相应请求
    # secure ： NFS 通过 1024 以下的安全 TCP/IP 端口发送
    # insecure ： NFS 通过 1024 以上的端口发送
    # wdelay ： 如果多个用户要写入 NFS 目录， 则归组写入（默认）
    # no_wdelay ： 如果多个用户要写入 NFS 目录， 则立即写入， 当使用 async 时， 无需此设置。
    # no_hide 共享 NFS 目录的子目录
    # subtree_check 如果共享/usr/bin 之类的子目录时， 强制 NFS 检查父目录的权限
    # no_subtree_check 和上面相对， 不检查父目录权限
    # all_squash 共享文件的 UID 和 GID 映射匿名用户 anonymous， 适合公用目录。
    # no_all_squash 保留共享文件的 UID 和 GID
    # root_squash root 用户的所有请求映射成如 anonymous 用户一样的权限
    # no_root_squas root 用户具有根目录的完全管理访问权限 "
	func_gedit /etc/exports

	func_echo '
    挂载 Ubuntu18 系统及更高版本的系统下的 nfs 共享目录， 
    若 uboot 无法通过 nfs 启动 Ubuntu 系统内的共享目录，
    需要在 /etc/default/nfs-kernel-server 文件进行修改

# Number of servers to start up
#RPCNFSDCOUNT=8
RPCNFSDCOUNT="-V 2 8"

#RPCMOUNTDOPTS="--manage-gids"
RPCMOUNTDOPTS="-V 2 --manage-gids"

# Options for rpc.svcgssd.
#RPCSVCGSSDOPTS=""
RPCSVCGSSDOPTS="--nfs-version 2,3,4 --debug --syslog" '

	func_echo "04 -  重启 nfs 服务 "
	func_execute_sudo service nfs-kernel-server restart
	func_execute_sudo /etc/init.d/nfs-kernel-server restart

	func_apt -i openssh-server openssh-client ssh
	# ssh 的配置文件为 /etc/ssh/sshd_config，使用默认配置即可

	func_echo "执行以下指令设置开发板 IP，
    创建一个 get 目录，
    将虚拟机（192.168.10.100） NFS 共享目录 挂载到到 开发板的 get 目录中。
    mkdir get
    mount -t nfs -o nolock,nfsvers=3 192.168.10.100:/home/alientek/linux/nfs get/ "
}

f_tftp() {
	func_echo_loop "tftp 服务搭建"
	func_echo "tftp 是一个简单的基于 udp 的文本文件传输协议，
    我们用它将内核镜像和设备树下载到开发板内存中，
    并指定地址， 只在 Ubuntu 上配置好 tftp 服务器即可"

	func_echo "01 - 安装 tftp 服务 "
	func_apt -i tftp-hpa tftpd-hpa xinetd

	func_echo "02 - 创建文件夹，存放开发板的根文件系统 "
	func_mkdir 777 ~/arm_tftpboot

	func_echo "03 - 新建文件 /etc/xinetd.d/tftp, 
    如果没有 /etc/xinetd.d 目录的话自行创建，
    然后在里面输入如下内容：

service tftp
{
	socket_type = dgram
	protocol = udp
	wait = yes
	disable = no
	user = root
	server = /usr/sbin/in.tftpd
	server_args = -s /home/zcq/ARM_tftpboot -c
	#log_on_success += PID HOST DURATION
	#log_on_failure += HOST
	per_source= 11
	cps = 100 2
	flags = IPv4
}		"
	func_gedit /etc/xinetd.d/tftp

	func_echo '03 - 更改配置文件 /etc/default/tftpd-hpa 
    # 文件末尾添加：

TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/home/zcq/ARM_tftpboot"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="-l -c -s" 
# TFTP_OPTIONS="--secure" '
	func_gedit /etc/default/tftpd-hpa

	# 04 - 重启 tftp 服务
	func_execute_sudo service tftpd-hpa restart
}

f_net() {
	func_echo_loop "网络服务传输"
	local tmp_print01="
vsftpd 是一个在 UNIX 类操作系统上运行的 FTP 服务器名字，
全称是\“very secure FTP daemon\”，
vsftpd 是一个完全免费、开源的 FTP 服务器软件， vsftpd 在 linux 发行版中非常流行。
ubuntu 下安装 vsfptd 很简单，直接 apt 命令安装。
根文件系统 安装 vsftpd，需要移植 vsfpd。
	1、解压缩： tar -xzf vsftpd-3.0.3.tar.gz
	2、打开 Makefile，修改 Makefile 中 CC 变量 为
	交叉编译器 CC = arm-linux-gnueabihf-gcc
	3、make # 编译 vsftpd
	4、编译完成，得到两个文件： vsftpd 和 vsftpd.conf，
	将 vsftpd 拷贝到 根文件系统 /usr/sbin 目录下，
	将 vsftpd.conf 拷贝到 根文件系统 /etc 目录下。
	5、拷贝完成以后给予 vsftpd 可执行权限，
	修改 vsfptd.conf 所属用户为 root，命令如下：
	chmod +x /usr/sbin/vsftpd
	chown root:root /etc/vsftpd.conf
	6、取消前面的 \“#\”
	local_enable=YES
	write_enable=YES
至此， vsftpd 已移植成功"
	func_echo "${tmp_print01}"
	func_apt -i vsftpd

	local tmp_print02="
OpenSSH 是 SSH 协议的免费开源版本。
SSH 全称为 Secure Shell (安全外壳协议，简称 SSH)，是一种加密的网络传输协议，
用于在不安全的网络中为网络服务提供安全的传输环境。
远程登录 到开发板上对系统进行一些操作，这个时候就要使用到 SSH 服务。
SSH 是较可靠、专为远程登录会话和其他网络服务提供安全性的协议，
OpenSSH 是 SSH 协议的免费开源版本。
SSH 全称为 Secure Shell (安全外壳协议，简称 SSH)，是一种加密的网络传输协议，
用于在不安全的网络中为网络服务提供安全的传输环境。
	OpenSSH 提供了很多程序，常用有以下几个：
		1、 ssh 用于替换 rlogin 与 Telnet。
		2、 scp 和 sftp  将文件复制到其他主机上，用于替换 rcp。
		3、 sshd  服务器 SSH
OpenSSH 移植: 需要移植三个软件包： zlib、 openssl 和 openssh
	1、解压缩  zlib-1.2.11.tar.gz openssl-OpenSSL_1_1_1l.zip
	openssh-8.2p1.tar.gz
	2、	目录 zlib-1.2.11
		CC=arm-linux-gnueabihf-gcc
		LD=arm-linux-gnueabihf-ld
		AD=arm-linux-gnueabihfas
		./configure --prefix=/openssh/zlib
		make -j6
		make install
	将 /openssh/zlib 复制到 根文件系统
	将 /openssh/zlib/lib/* 复制到 /usr/lib/
	3、	目录 openssl-OpenSSL_1_1_1l
		# \“ linux-armv4\”表示 32 位 ARM 凭条，并没有\“linux-armv7\”这个选项
		./Configure linux-armv4 shared no-asm
			--prefix=/openssh/openssl
			CROSS_COMPILE=arm-linux-gnueabihf-
			make -j6
			make install
	将 /openssh/openssl 复制到 根文件系统
	将 /openssh/openssl/lib/* 复制到 /usr/lib/
	4、	目录 openssh-8.2p1
	至此， OpenSSH 已移植成功"
	func_echo "${tmp_print02}"

	func_apt -i openssh-server openssh-client ssh zlib1g-dev
	# ssh 的配置文件为 /etc/ssh/sshd_config，使用默认配置即可
	func_execute /etc/init.d/ssh start # 打开
	# scp命令
	#（1）将本地文件拷贝到远程：scp 文件名 用户名@计算机IP或者计算机名称:远程路径
	#（2）从远程将文件拷回本地：scp 用户名@计算机IP或者计算机名称:文件名本地路径
	#（3）将本地目录拷贝到远程：scp -r 目录名 用户名@计算机IP或者计算机名称:远程路径
	#（4）从远程将目录拷回本地：scp -r 用户名@计算机IP或者计算机名称:目录名本地路径

	# 修改了网络配置文件后,会用以下命令重新启动网络
	func_execute /etc/init.d/networking restart
}

f_install_common() {
	func_echo_loop "安装 常用 命令/软件"
	func_apt -a # 清除所有已下载的安装包
	func_apt -d

	func_apt -i apt-utils aptitude software-properties-common -d

	func_apt -i language-pack-en-base      # 英文语言包
	func_apt -i language-pack-zh-hans-base # 中文语言包

	func_apt -g

	func_apt -i sudo vim
	func_apt -i bash bash-completion # 自动补全工具
	func_apt -i net-tools            # ifconfig命令
	func_apt -i ethtool ifupdown iproute2
	func_apt -i gcc g++ make cmake build-essential gdb gdbserver

	func_apt -i kmod                   # 是为了以后使用 insmod 与 lsmod
	func_apt -i mmc-utils              # 使能启动分区 mmc bootpart enable 1 1 /dev/mmcblk1
	func_apt -i libdata-hexdumper-perl # 查看二进制文件 hexdump

	func_echo "select the city or region:
	6. Asia
	70. Shanghai 	 "
	func_apt -i network-manager

	func_apt -i rsyslog htop iputils-ping
	func_apt -i ssh git

	func_apt -i python python2 python2-dev python3 python3-dev
	# func_apt -i python-dev-is-python2
	# func_apt -i python2.7 python2.7-dev python3.8 python3.8-dev

	func_echo "图片"
	func_apt -i libjpeg-dev # libjpeg-tools
	func_apt -i libpng-dev  # libpng-tools
	func_apt -i libgif-dev

	func_echo "ALSA音频架构
查看声卡 $ cat /proc/asound/cards"
	# ALSA 是 Advanced Linux Sound Architecture，高级 Linux 声音架构的简称,
	# ALSA是一个全然开放源码的音频驱动程序集，除了像OSS那样提供了一组内核驱动程序模块之外，
	# ALSA还专门为简化应用程序的编写提供了对应的函数库，与OSS提供的基于ioctl的原始编程接口相比。
	# ALSA函数库使用起来要更加方便一些。利用该函数库，开发人员能够方便快捷的开发出自己的应用程序，
	# 细节则留给函数库内部处理。当然 ALSA也提供了类似于OSS的系统接口，
	# 只是ALSA的开发人员建议应用程序开发人员使用音频函数库而不是驱动程序的API。
	# alsa-lib 是ALSA 应用库(必需基础库)，alsa-utils 包含一些ALSA小的测试工具.
	# 如 aplay、arecord 、amixer 播放、录音和调节音量小程序，
	func_apt -i libasound2 libasound2-dev
	func_apt -i alsa-base alsa-utils alsa-oss alsa-tools
	func_apt -i alsaplayer-alsa alsaplayer-common

	func_echo "播放器"
	func_apt -i zlib1g-dev # zlib 库
	func_apt -i mplayer    # 播放器
	#	func_apt -i libmad0-dev
	# func_apt -i smplayer # SMPlayer 是 MPlayer 前端，支持视频、dvd和VCD
}

f_install_32() {
	func_apt -d -f
	func_execute_sudo dpkg --add-architecture i386 # 准备添加32位支持
	func_execute_sudo dpkg --configure -a

	func_apt -i lsb-core

	func_apt -i libc6 libc6-i386
	func_apt -i libc6-amd64-cross libc6-armhf-cross
	func_apt -i libc6-amd64-i386-cross libc6-dbg-i386-cross
	func_apt -i libc6-dev-amd64-i386-cross libc6-dev-i386
	func_apt -i libc6-dev-i386-amd64-cross
	func_apt -i libc6-dbg libc6-dev libc6-dev-armhf-cross

	func_apt -i libncurses5 libncurses5-dev libstdc++6-i386-cross

	func_apt -i libstdc++6

	func_apt -i lib32gcc1 lib32gcc-9-dev
	func_apt -i lib32gcc-9-dev-amd64-cross

	func_apt -i lib32stdc++6 lib32stdc++6-10-dbg
	func_apt -i lib32stdc++6-10-dbg-amd64-cross lib32stdc++6-10-dbg-x32-cross
	func_apt -i lib32stdc++6-7-dbg
	func_apt -i lib32stdc++6-8-dbg
	func_apt -i lib32stdc++6-8-dbg-amd64-cross lib32stdc++6-8-dbg-x32-cross
	func_apt -i lib32stdc++6-9-dbg
	func_apt -i lib32stdc++6-amd64-cross lib32stdc++6-x32-cross

	func_apt -i gcc-9-multilib gcc-9-multilib-arm-linux-*
	func_apt -i g++-9-multilib g++-9-multilib-arm-linux-*
}

################################################################

main_desktop() {
	func_apt -d
	f_install_common
	f_install_32
	f_nfs
	f_tftp
	f_net
	func_apt -a # 清除所有已下载的安装包
}

################################################################

if [ -z "$1" ]; then
	main_desktop
fi

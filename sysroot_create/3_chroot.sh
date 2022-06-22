#! /bin/bash

# ./1_prepare.sh ${DIR_base_rootfs}

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

################################################################

# 任意路径下 获取 Zcq_Create_rootfs=/.../zcq_sysroot_Create_ubuntu_base_20.04
if [ -z "${Zcq_Create_rootfs}" ]; then
	#	if false; then
	if true; then
		Zcq_Create_rootfs=$(dirname $0)
	else
		Zcq_Create_rootfs=$0
		# $Zcq_Create_rootfs= ./rootfs.sh or ./file/rootfs.sh
		Zcq_Create_rootfs=${Zcq_Create_rootfs%/*} # . or ./file
	fi
	if [ "$Zcq_Create_rootfs" == "." ]; then
		Zcq_Create_rootfs=$(pwd)
	else
		#		if [ -d "${Zcq_Create_rootfs}" ]; then
		cd ${Zcq_Create_rootfs} || exit 31
		Zcq_Create_rootfs=$(pwd)
		#		fi
	fi
fi

################################################################

ARM_tool_function=""
f_ARM_tool_function() {
	local arm_tool_function=""
	arm_tool_function="${Zcq_Create_rootfs}/file_sh/ARM_tool_function.sh
	/opt/ARM_tool_function.sh"
	for tmp in ${arm_tool_function}; do
		if [ -f ${tmp} ]; then
			source ${tmp}
			ARM_tool_function=${tmp}
			return
		else
			echo -e "No exit : ${tmp}"
		fi
	done
	exit 1
}
f_ARM_tool_function

source ${Zcq_Create_rootfs}/0_val_path_file.sh
f_setval_3

if [ ${DIR_base_rootfs} != "/" ]; then
	DIR_base_rootfs=""
	exit 12
fi

source ${Zcq_Create_rootfs}/file_sh/install_qt5_lib.sh no_opt
source ${Zcq_Create_rootfs}/file_sh/install_qt5_ubuntu.sh no_opt

################################################################

func_cd ${DIR_base_rootfs} # 根文件系统 base rootfs

func_chmod 777 ${Zcq_Create_rootfs}

# bin boot dev etc home lib media mnt opt proc
# root run sbin srv sys tmp usr var
func_chmod 777 dev home media mnt opt tmp

# 创建文件夹
#func_mkdir 777 proc sys dev/pts

################################################################

f_root_user() {
	func_echo_loop "用户"
	echo "linux 下取消用户名和密码直接登录, 假定目前 只有 root 用户
01. 去掉登录密码
    方式一：但 ssh 必须要有用户名和密码 !!!
            $ passwd -d root
    方式二：
        修改 /etc/passwd, 去掉 root 后面的 x
        修改前: root:x:0:0:root:/root:/bin/bash
        修改后: root::0:0:root:/root:/bin/bash
        修改 /etc/shadow
        修改前: root:\$6\$KSC.MN5x\$d9Lfh...7uN6a/:18971:0:99999:7:::
        修改后: root::18971:0:99999:7:::
02. 添加  --autologin root
    Serial 串口自动登录 root, 修改 /usr/lib/systemd/system/serial-getty\@.service 
        # ExecStart=-/sbin/agetty -o '-p -- \\\\u' --keep-baud 115200,38400,9600 %I \$TERM
        ExecStart=-/sbin/agetty -o '-p -- \\\\u' --autologin root 115200,38400,9600 %I \$TERM  
        或 ExecStart=-/sbin/agetty --autologin root -8 -L %I 115200 \$TERM 
    LCD 修改 /usr/lib/systemd/system/getty\@.service
        # ExecStart=-/sbin/agetty -o '-p -- \\\\u' --noclear %I \$TERM
        ExecStart=-/sbin/agetty -o '-p -- \\\\u' --noclear %I \$TERM --autologin root  "

	func_echo "设置 root 用户 密码"
	func_execute passwd root
	# func_echo "删除 root 帐户的密码"
	# func_execute passwd -d root
	# func_echo "添加 普通 用户"
	# func_execute adduser arm
	# func_execute passwd arm
	# func_echo "删除 arm 帐户的密码"
	# func_execute passwd -d arm
	# func_echo "删除用户"
	# func_execute deluser arm
}

f_host() {
	func_echo_loop "设置 主机名 和 IP 地址"
	func_execute hostname arm
	echo "arm" >/etc/hostname ### 设置 主机名
	echo "127.0.0.1 localhost
127.0.0.1 $(cat /etc/hostname)" >/etc/hosts
	func_execute cat /etc/hostname
	func_execute cat /etc/hosts
}

f_install_common() {
	func_echo_loop "安装 常用 命令/软件"
	func_apt -a # 清除所有已下载的安装包
	func_apt -d

	func_apt -i apt-utils aptitude
	func_apt -i software-properties-common # add-apt-repository：找不到命令

	func_apt -i language-pack-en-base      # 英文语言包
	func_apt -i language-pack-zh-hans-base # 中文语言包

	func_apt -g

	func_apt -i sudo vim
	func_apt -i bash bash-builtins bash-completion # 自动补全工具
	func_apt -i net-tools                          # ifconfig命令
	func_apt -i ethtool ifupdown iproute2 curl git
	func_apt -i gcc g++ make cmake build-essential gdb gdbserver

	func_apt -i kmod                   # 是为了以后使用 insmod 与 lsmod
	func_apt -i mmc-utils              # 使能启动分区 mmc bootpart enable 1 1 /dev/mmcblk1
	func_apt -i libdata-hexdumper-perl # 查看二进制文件 hexdump

	func_apt -i xorg libx11-dev libwayland-dev # 显示环境
	# func_apt -i ubuntu-desktop tasksel
	# func_apt -i ubuntu-desktop-minimal
	# func_apt -i ubuntu-defaults-zh-cn

	func_echo "select the city or region:
	6. Asia
	70. Shanghai 	 "
	func_apt -i network-manager

	func_apt -i m4
	# func_apt -i gcc-multilib
	# func_apt -i g++-multilib
	# func_apt -i gcc-multilib-arm-linux-gnueabihf
	# func_apt -i g++-multilib-arm-linux-gnueabihf

	# func_apt -i pkg-config
	# func_apt -i pkg-config-arm-linux-*

	func_apt -i python python2 python2-dev python3 python3-dev
	# func_apt -i python-dev-is-python2
	# func_apt -i python2.7 python2.7-dev python3.8 python3.8-dev
	# func_apt -i python3-pip

	func_apt -i rsyslog htop iputils-ping ssh
	func_apt -i fbset initramfs-tools

	func_apt -i udev libudev1 libudev-dev
	func_apt -i libinput-bin libinput-dev libinput-tools

	func_echo "eglfs 支持"
	func_apt -i libgbm-dev libdrm-dev

	func_echo "pulseaudio 开发库及服务"
	func_apt -i pulseaudio libpulse-dev

	func_echo "tslib 触摸库"
	func_apt -i libts-dev

	func_echo "键盘支持"
	func_apt -i libxkbcommon-dev libxkbcommon-x11-dev

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

	func_apt -i libkqueue-dev

	func_apt -i ttf-mscorefonts-installer # 安装 Arial、Times New Roman 等字体
	func_execute fc-cache                 # 生效
	# $ fc-match Arial # 查看 Arial
	# $ fc-match Times # 查看 Times New Roman
}

f_time() {
	func_echo_loop "时间校正
4 Asia
10 China
1 Beijing Time
1 Yes "
	tzselect # 时间校正 依次选择 亚洲 Asia，中国 China，北京 Beijing
	if [ -f "usr/share/zoneinfo/Asia/Shanghai" ]; then
		func_execute ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime # 创建时区软链接
	fi
	# 与 时间服务器 同步
	func_apt -i ntpdate # 安装 ntpdate 工具
	# func_execute ntpdate 20.189.79.72  # time.windows.com  20.189.79.72
	# func_execute ntpdate 114.118.7.163 # 和国家授时中心时间对齐  ntp.ntsc.ac.cn  114.118.7.163
	# func_execute ntpdate 94.130.49.186 # 设置系统时间与网络时间同步  cn.pool.ntp.org  94.130.49.186
	# func_execute hwclock --systohc     # 将系统时间写入硬件时间
	# func_execute hwclock -s -f /dev/rtc # 硬件时钟
	# func_execute timedatectl set-timezone Asia/Shanghai # 更改当前时区为 东八区
	# 需要 24小时制，修改 /etc/default/locale；修改 一行：LC_TIME=en_DK.UTF-8
}

language_locale() {
	func_execute locale-gen en_US.UTF-8
	func_execute locale-gen zh_CN.UTF-8   # 添加中文支持 zh_CN.UTF-8 UTF-8
	func_execute locale-gen zh_CN.GBK     # 添加中文支持 zh_CN.GBK GBK
	func_execute locale-gen zh_CN.GB18030 # 添加中文支持 zh_CN.GB18030 GB18030
	func_execute locale-gen zh_CN         # 添加中文支持 zh_CN GB2312
	if [ -f /etc/locale.gen ]; then       # 语言列表
		#	func_execute cat /etc/locale.gen
		#	func_execute vim /etc/locale.gen
		${Sudo} grep -E "en_US.UTF-8" /etc/locale.gen
		${Sudo} grep -E "zh_CN.UTF-8" /etc/locale.gen
		${Sudo} grep -E "zh_CN.GBK" /etc/locale.gen
		${Sudo} grep -E "zh_CN.GB18030" /etc/locale.gen
		${Sudo} grep -E "zh_CN GB2312" /etc/locale.gen
	fi
}
f_language() {
	func_echo_loop "语言支持"

	# Alt + Ctrl + F3 / Alt + F3 -->> /dev/tty3
	# func_apt -i -y zhcon -f # 解决 控制终端 (/dev/tty) 中文乱码
	func_apt -i zhcon # 解决 控制终端 (/dev/tty) 中文乱码
	#func_execute zhcon --utf8 --drv=vga # 启动 zhcon，root 模式，中文乱码。
	#func_execute zhcon --utf8 --drv=fb # 启动 zhcon，root 模式，中文显示正常。
	#func_execute zhcon --utf8 --drv=auto # 启动 zhcon，user 模式，中文显示正常。

	# fbterm--支持中文显示的控制台
	# fbterm 提供了一个快速的终端仿真器，
	# 它直接运行在你的系统中的帧缓冲 (framebuffer) 之上。
	# 使用帧缓冲可以在终端渲染 UTF-8 文本时可以提高性能。
	# fbterm 旨在提供国际化和现代字体支持时至少与 Linux 内核终端一样快，
	# 它允许你在同一个帧缓冲上创建多达 10 个不同的终端窗口，每个窗口都有它的回滚历史。
	# 要运行 fbterm，首先检查当前用户是否在 video 组，如不在，则加入。
	# 当运行 fbterm 后，会在用户主目录下生成 ~/.fbtermrc 配置文件，
	# 其中可以更换字体样式及大小、默认前/背景色。
	# 若你不能看到中文，按 Ctrl+Alt+E 退出 fbterm，再运行下面的命令：
	# LANG=zh_CN.utf-8 fbterm
	# func_apt -i -y fbterm -f # 解决 控制终端 (/dev/tty) 中文乱码
	func_apt -i fbterm # 支持中文显示的控制台
	# sudo fbterm # 运行 fbterm
	# fbterm 功能是很强大的，支持字体样式、大小、样色设置等，修改配置文件 .fbtermrc 即可，
	# 在控制台输入以下命令： sudo gedit ~/.fbtermrc

	# Ubuntu下增加中文字符编码的方法
	# 1、首先，安装中文支持包 language-pack-zh-hans：
	# 	func_apt -i -y language-pack-zh-hans -f
	# 2、Ubuntu默认的中文字符编码
	# 	然后，修改 /etc/environment （在文件的末尾追加）：
	# PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
	# 追加 LANG=\"zh_CN.UTF-8\"
	# 追加 LANGUAGE=\"zh_CN:zh:en_US:en\"
	# 3、
	# 	方式01 执行命令：
	# 		sudo locale-gen zh_CN.UTF-8 # 添加中文支持
	# 		sudo locale-gen zh_CN.GBK # 添加中文支持
	# 		sudo locale-gen zh_CN.GB18030 # 添加中文支持
	# 			#发现 /var/lib/locales/supported.d/local 多一行 zh_CN.GB18030 GB18030
	# 	方式02
	# 	找到有效支持的列表 /usr/share/i18n/SUPPORTED
	# 	编辑文件 /etc/locale.gen
	# 		删掉最前面的注释符号#
	# 		en_US.UTF-8 UTF-8
	# 		zh_CN GB2312
	# 		zh_CN.GB18030 GB18030
	# 		zh_CN.GBK GBK
	# 		zh_CN.UTF-8 UTF-8
	# 		然后产生 locale 文件： sudo locale-gen
	# 4、再修改 /var/lib/locales/supported.d/local (没有这个文件就新建，同样在末尾追加)：
	# 		en_US.UTF-8 UTF-8
	# 		zh_CN GB2312
	# 		zh_CN.GB18030 GB18030
	# 		zh_CN.GBK GBK
	# 		zh_CN.UTF-8 UTF-8
	# 5、对于中文乱码是空格的情况，安装中文字体解决。
	# func_apt -i -y fonts-droid-fallback ttf-wqy-zenhei
	# 		ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming

	func_apt -i language-pack-zh-hans # 中文语言包
	func_apt -i language-pack-en      # 英文语言包

	func_chmod 775 /etc/environment
	#Linux中shell去除空行的几种方法
	#用sed命令
	#cat 文件名 | sed '/^$/d'
	#用awk命令
	#cat 文件名 | awk '{if($0!="")print}'
	#cat 文件名 | awk '{if(length !=0) print $0}'
	#用grep命令
	#grep -v '^$' 文件名
	${Sudo} sed -i -E -e '/^LANG="/d' -e '/^LANGUAGE="/d' -e '/^$/d' /etc/environment
	echo '
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh:en_US:en" ' >>/etc/environment

	language_locale

	#if [ -f /usr/share/i18n/SUPPORTED ]; then
	#	func_execute cat usr/share/i18n/SUPPORTED
	#fi

	local tmp_locales=/var/lib/locales/supported.d/local
	if [ ! -f ${tmp_locales} ]; then
		func_mkdir 777 $(dirname ${tmp_locales})
		func_execute touch ${tmp_locales}
	fi
	func_chmod 777 ${tmp_locales}
	${Sudo} sed -i -E -e '/^zh_CN/d' -e '/^en_US/d' -e '/^$/d' ${tmp_locales}
	echo "
en_US.UTF-8 UTF-8
zh_CN GB2312
zh_CN.GB18030 GB18030
zh_CN.GBK GBK
zh_CN.UTF-8 UTF-8" >>${tmp_locales}

	func_apt -i fonts-droid-fallback ttf-wqy-zenhei
	func_apt -i fonts-wqy-microhei fonts-arphic-ukai fonts-arphic-uming
}

f_serial() {
	func_echo_loop "配置串口终端"
	local tmp_dir=/etc/systemd/system/getty.target.wants
	func_mkdir 777 ${tmp_dir}
	if [ -n "${Getty_ttymxc}" ]; then
		func_execute ln -sf /lib/systemd/system/getty\@.service ${tmp_dir}/${Getty_ttymxc}
	fi
	if [ -n "${Getty_ttySAC}" ]; then
		# 针对iTop-4412精英版，其调试串口为ttySAC2
		func_execute ln -sf /lib/systemd/system/getty\@.service ${tmp_dir}/${Getty_ttySAC}
	fi
	if [ -n "${Getty_tty}" ]; then
		func_execute ln -sf /lib/systemd/system/getty\@.service ${tmp_dir}/${Getty_tty}
	fi
}

f_rclocal() {
	func_echo_loop "开机自动启动脚本设置"
	func_cpf ${Rc_local} /etc/rc.local
	func_chmod 777 /etc/rc.local
	func_cpf ${Rc_local_service} /usr/lib/systemd/system/rc-local.service
	func_execute ln -sf /usr/lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service
}

f_nfs() {
	func_echo_loop "nfs 服务搭建"
	func_echo "开发板的文件系统放在 PC 端（Ubuntu） ，
    开发板的文件系统类型设置为 nfs， 就可以挂载文件系统了。"

	func_echo "01 - 安装 nfs 服务"
	func_apt -i nfs-kernel-server rpcbind
	func_apt -i nfs-common libnfs-utils

	func_echo "02 - 创建文件夹，存放开发板的根文件系统 "
	func_mkdir 777 /mnt/nfs

	if false; then
		func_echo "03 - 更改配置文件 /etc/exports
    # 文件末尾添加：

    /home/zuozhongkai/linux/nfs *(rw,sync,no_root_squash)
    # /home/${USER}/ARM_nfs_rootfs *(rw,nohide,insecure,no_subtree_check,async,no_root_squash)

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

		func_echo ' 挂载 Ubuntu18 系统及更高版本的系统下的 nfs 共享目录，
    uboot 无法通过 nfs 启动 Ubuntu 系统内的共享目录。
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
	fi

	# ssh 的配置文件为 /etc/ssh/sshd_config，使用默认配置即可

	func_echo "执行以下指令设置开发板 IP，
    创建一个 get 目录，
    将虚拟机（192.168.10.100） NFS 共享目录 挂载到到 开发板的 get 目录中。
    mkdir get
	mount -t nfs -o nolock 192.168.10.100:/home/zcq/arm_nfs /mnt/nfs"
}

f_tftp() {
	func_echo_loop "tftp 服务搭建"
	func_echo "tftp 是一个简单的基于 udp 的文本文件传输协议，
    我们用它将内核镜像和设备树下载到开发板内存中，
    并指定地址， 只在 Ubuntu 上配置好 tftp 服务器即可"

	func_echo "01 - 安装 tftp 服务 "
	func_apt -i tftp-hpa tftpd-hpa xinetd

	func_echo "02 - 创建文件夹，存放开发板的根文件系统 "
	func_mkdir 777 /mnt/nfs

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
    }     "

	func_echo '03 - 更改配置文件 /etc/default/tftpd-hpa
        # 文件末尾添加：
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/home/zcq/ARM_tftpboot"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="-l -c -s"
# TFTP_OPTIONS="--secure" '

	# 04 - 重启 tftp 服务
	# func_execute_sudo service tftpd-hpa restart
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
	if false; then
		func_cpf vsftpd /usr/sbin/
		func_cpf vsftpd.conf /etc/
		func_chmod +x /usr/sbin/vsftpd
		func_execute chown root:root /etc/vsftpd.conf
		func_mkdir 777 -p -v /usr/share/empty /var/log
		func_execute touch /var/log/vsftpd.log
		func_chmod 777 /var/log/vsftpd.log
	else
		func_apt -i vsftpd
	fi
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
	if false; then
		func_cpf /openssh/zlib/lib/\* /usr/lib/
		func_cpf /openssh/openssl/lib/\* /usr/lib/
	else
		func_apt -i openssh-server openssh-client ssh zlib1g-dev
		# ssh 的配置文件为 /etc/ssh/sshd_config，使用默认配置即可
		func_execute /etc/init.d/ssh start # 打开
	# scp命令
	#（1）将本地文件拷贝到远程：scp 文件名 用户名@计算机IP或者计算机名称:远程路径
	#（2）从远程将文件拷回本地：scp 用户名@计算机IP或者计算机名称:文件名本地路径
	#（3）将本地目录拷贝到远程：scp -r 目录名 用户名@计算机IP或者计算机名称:远程路径
	#（4）从远程将目录拷回本地：scp -r 用户名@计算机IP或者计算机名称:目录名本地路径
	fi
	func_mkdir 777 /etc/network
	func_chmod 777 /etc/network
	func_cpf ${Interfaces} /etc/network/interfaces # 配置网络接口
	# 修改了网络配置文件后,会用以下命令重新启动网络
	# func_execute /etc/init.d/networking restart
}

busybox_ln() {
	local cmd_force='-s'
	local bin_path='bin'
	while [ $# -gt 0 ]; do
		case $1 in
		-s)
			cmd_force='-s'
			;;
		-sf)
			cmd_force='-sf'
			;;
		-bin)
			bin_path='bin'
			;;
		-sbin)
			bin_path='sbin'
			;;
		*)
			func_execute ln ${cmd_force} /usr/bin/busybox /usr/${bin_path}/$1
			;;
		esac
		shift
	done
}
f_busybox() {
	if [ -n "${Busybox}" ]; then
		func_echo_loop "f_busybox()"
		func_cpf ${Busybox} /usr/bin/busybox
		# func_execute ln -s /usr/bin/busybox /linuxrc
		# func_execute ln -s /usr/bin/busybox /usr/bin/hexdump
		# busybox_ln hexdump
		# busybox_ln hush iostat ipcalc kdb_mode lzop makemime mpstat nuke
		# busybox_ln pipe_progress reformime resume rpm setserial usleep
		busybox_ln -sbin mkfs.vfat
		# busybox_ln -sbin acpid ipaddr iplink ipneigh iproute iprule loadkmap
		# busybox_ln -sbin logread mdev mkdosfs makedevs udhcpc uevent watchdog
		#	else
		#		func_apt -i busybox
		#		busybox_ln -sbin mkfs.vfat
	fi
}

f_fonts() {
	func_echo_loop "更新字体库"
	func_apt -i fontconfig
	# 字库目录
	func_cpf ${Fonts_add}/* /usr/share/fonts/
	func_chmod 777 /usr/share/fonts
	func_execute mkfontscale
	func_execute mkfontdir
	func_execute fc-cache -f -v
}

f_pkgconfig() {
	func_echo_loop "创建 pkgconfig 软链接"
	func_cp /usr/lib/pkgconfig/\* /usr/lib/arm-linux-gnueabihf/pkgconfig/
	func_execute rm -rf /usr/lib/pkgconfig
	func_execute ln -srf /usr/lib/arm-linux-gnueabihf/pkgconfig /usr/lib/pkgconfig
}

f_tty_grap() {
	func_echo_loop "文本界面,tty/图形界面"
	systemctl set-default multi-user.target # 文本界面
	# systemctl set-default graphical.target  # 图形界面
}

f_qt5_pip() {
	func_echo_loop " 解决 ubuntu 使用 pyqt5 的 WebEngine 模块出现
	Could not find QtWebEngineProcess
	安装的pyqt5的版本过高！ "
	func_apt -d
	func_apt_repository universe
	# func_apt -i python python2 python2-dev python3 python3-dev
	# func_apt -i python-dev-is-python2
	# func_apt -i python2.7 python2.7-dev python3.8 python3.8-dev
	func_apt -i python3-pip
	func_execute pip3 --version
	#	func_execute curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
	#	func_execute python2 get-pip.py
	#	func_execute pip --version
	func_execute pip3 uninstall pyqt5
	func_execute pip3 install pyqt5==5.15.0
}

################################################################

all_function() {
	f_root_user
	f_host
	f_install_common
	f_time
	f_language
	f_serial
	f_rclocal
	f_nfs
	#	f_tftp
	f_net
	f_busybox
	f_fonts
	# f_pkgconfig
	f_tty_grap
	# f_qt5_pip
}

echo_function="\e[0m
=======================================
0 --- all_function ---
1	f_root_user
2	f_host
3	f_install_common
4	f_time
5	f_language
6	f_serial
7	f_rclocal
8	f_nfs
9	#	f_tftp
10	f_net
11	f_busybox
12	f_fonts
13	# f_pkgconfig
14	f_tty_grap
15	# f_qt5_pip
----
20	f_install_qt5_lib
21	f_install_qt5_ubuntu
---------------------------------------
	example : 0 [回车]
	exit    : q [回车] "

main() {
	local choice
	while [[ : ]]; do
		echo -e "${echo_function}"
		echo -e " \033[1;5;7mselect\e[0m : \c"
		read choice
		case ${choice} in
		q)
			break
			;;
		0)
			all_function
			;;
		1)
			f_root_user
			;;
		2)
			f_host
			;;
		3)
			f_install_common
			;;
		4)
			f_time
			;;
		5)
			f_language
			;;
		6)
			f_serial
			;;
		7)
			f_rclocal
			;;
		8)
			f_nfs
			;;
		9)
			# f_tftp
			;;
		10)
			f_net
			;;
		11)
			f_busybox
			;;
		12)
			f_fonts
			;;
		13)
			# f_pkgconfig
			;;
		14)
			f_tty_grap
			;;
		15)
			# f_qt5_pip
			;;
		20)
			f_install_qt5_lib
			;;
		21)
			f_install_qt5_ubuntu
			;;
		*)
			echo -e "\033[1;5;7;31;40m error \e[0m"
			;;
		esac
	done
}
main

func_apt -a # 清除所有已下载的安装包

exit 0

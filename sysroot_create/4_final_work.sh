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
f_setval_4

if [ ${DIR_base_rootfs} == "/" ]; then
	DIR_base_rootfs=""
	exit 12
fi

################################################################

func_cd ${DIR_base_rootfs} # 根文件系统 base rootfs

func_chmod 777 ${Zcq_Create_rootfs}

# bin boot dev etc home lib media mnt opt proc
# root run sbin srv sys tmp usr var
func_chmod 777 dev home media mnt opt tmp root snap

# 创建文件夹
#func_mkdir 777 proc sys dev/pts

################################################################

f_sudoers() {
	func_echo_loop "
添加用户
arm\tALL=(ALL:ALL) ALL

免密执行 sudo 修改
%sudo\tALL=(ALL:ALL) NOPASSWD:ALL "
	func_gedit etc/sudoers
}

f_net() {
	func_echo_loop "网络服务传输"

	func_echo "
vsftpd 是一个在 UNIX 类操作系统上运行的 FTP 服务器名字，
全称是\“very secure FTP daemon\”，
vsftpd 是一个完全免费、开源的 FTP 服务器软件， vsftpd 在 linux 发行版中非常流行。
ubuntu 下安装 vsfptd 很简单，直接 apt 命令安装。
根文件系统 安装 vsftpd，需要移植 vsfpd。
	取消前面的 \“#\”
	local_enable=YES
	write_enable=YES "
	func_gedit etc/vsftpd.conf

	func_echo "远程传输 scp 出现 Permission denied 问题解决方法
将 /etc/ssh/sshd_config 文件中的
 PasswordAuthentication no 		改为
 PasswordAuthentication yes
 重启sshd服务：systemctl restart ssh.service "
	func_gedit etc/ssh/sshd_config

	func_echo "远程传输 scp 出现 Permission denied 问题解决方法
最终才知道问题原来是由于没有该目录的操作权限，默认的是在 /tmp 有权限
这样的话，我们以后在进行传输的时候，可以先把文件放到tmp文件目录下，
然后在进行 mv 或者 scp 到其他目录，即可。 "
	if [ ! -f ~/.ssh/id_rsa.pub ] && [ ! -f /root/.ssh/id_rsa.pub ]; then
		echo -e "
	Generating public/private rsa key pair.
    Enter file in which to save the key (/root/.ssh/id_rsa): \033[7;33m#回车\e[0m
    Enter passphrase (empty for no passphrase): \033[7;33m#回车\e[0m
    Enter same passphrase again: \033[7;33m#回车\e[0m 
	Overwrite:\033[7;33m y \e[0m    "
		func_execute_sudo ssh-keygen -t rsa
	fi
	if [ -f /root/.ssh/id_rsa.pub ]; then
		func_echo "不提示密码
将当前 Linux 主机上的 id_rsa.pub 文件拷贝到远程 Linux 主机
的 root 用户目录下的 .ssh 目录下，并且改名为 authorized_keys 。
若已经有该文件覆盖掉内容即可 "
		func_cpf /root/.ssh/id_rsa.pub root/authorized_keys # 不提示密码
	elif [ -f ~/.ssh/id_rsa.pub ]; then
		func_echo "不提示密码
将当前 Linux 主机上的 id_rsa.pub 文件拷贝到远程 Linux 主机
的 root 用户目录下的 .ssh 目录下，并且改名为 authorized_keys 。
若已经有该文件覆盖掉内容即可 "
		func_cpf ~/.ssh/id_rsa.pub root/authorized_keys # 不提示密码
	fi
}

f_language() {
	func_echo_loop "语言"

	func_echo 'Ubuntu终端中文乱码和无法输入中文
修改 locale 文件配置
	中文语言环境中 /etc/default/locale 文件的默认内容:
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh:en_US:en"
LC_NUMERIC="zh_CN.UTF-8"

# 需要 24小时制
LC_TIME="en_DK.UTF-8"

LC_MONETARY="zh_CN.UTF-8"
LC_PAPER="zh_CN.UTF-8"
LC_IDENTIFICATION="zh_CN.UTF-8"
LC_NAME="zh_CN.UTF-8"
LC_ADDRESS="zh_CN.UTF-8"
LC_TELEPHONE="zh_CN.UTF-8"
LC_MEASUREMENT="zh_CN.UTF-8"
	英文文语言环境中 /etc/default/locale 文件的默认内容：
		# File generated by update-locale
LANG="en_US.UTF-8"
LANGUAGE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"

# 需要 24小时制
LC_TIME="en_DK.UTF-8"

LC_MONETARY="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
	LC_ALL=en_US.UTF-8 # 如果该值设置了，则该值会覆盖所有LC_*的设置值。
		# 注意，LANG 的值不受该宏影响 '
	func_chmod 777 etc/default
	if [ -f etc/default/locale ]; then
		local tmpp=$(${Sudo} grep -E "^LANG=" etc/default/locale)
		if [ -z "${tmpp}" ]; then
			${Sudo} echo '# File generated by update-locale
LANG="en_US.UTF-8"
LANGUAGE="en_US:en:zh_CN:zh"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_DK.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"  ' >etc/default/locale
		else
			func_gedit etc/default/locale
		fi
		# unset tmpp
	else
		${Sudo} echo '# File generated by update-locale
LANG="en_US.UTF-8"
LANGUAGE="en_US:en:zh_CN:zh"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_DK.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"  ' >etc/default/locale
	fi

	func_echo "Ubuntu终端中文乱码和无法输入中文
	添加中文字符编码的方法
	再修改 /var/lib/locales/supported.d/local
	(没有这个文件就新建，同样在末尾追加)：
	zh_CN.UTF-8 UTF-8
	zh_CN.GB18030 GB18030
	zh_CN.GBK GBK
	en_US.UTF-8 UTF-8
	zh_CN GB2312 "
	if [ ! -f var/lib/locales/supported.d/local ]; then
		func_mkdir 777 var/lib/locales/supported.d
		func_touch 777 var/lib/locales/supported.d/local
		func_chmod 777 var/lib/locales/supported.d/local
		# ${Sudo} sed -i -E -e '/^zh_CN.*/d' -e '/^en_US.*/d' -e '/^$/d' var/lib/locales/supported.d/local
		${Sudo} echo "
zh_CN.UTF-8 UTF-8
zh_CN.GB18030 GB18030
zh_CN.GBK GBK
en_US.UTF-8 UTF-8
zh_CN GB2312 " >var/lib/locales/supported.d/local
	else
		func_execute_sudo cat var/lib/locales/supported.d/local
	fi
}

f_copy_files() {
	func_echo_loop "copy"

	func_cd ${DIR_base_rootfs} # 根文件系统 base rootfs

	func_cpf ${Systen_set_store} ./
	func_cpf ${Modules_ko} ./
	func_cpf ${File_sh} ./

	func_cpf ${Code_test_c_cpp} ./
	func_cpf ${Code_test_qt} ./

	func_cd -
}

opt_copy() {
	while [ $# -gt 0 ]; do
		func_execute_sudo rm -rf opt/${1##*/}
		if [ -d "${1}" ]; then
			func_cpf ${1} opt/
			func_chmod 777 opt/${1##*/}
		else
			func_echo -e "不存在 ${1}"
		fi
		shift
	done
}
f_opt_copy() {
	func_echo_loop "f_opt_copy()"

	opt_copy ${Opt_images} # 相册图片
	opt_copy ${Opt_music}  # 音乐
	opt_copy ${Opt_video}  # 视频

	opt_copy ${Opt_arm_qt}    # qt 库
	opt_copy ${Opt_arm_tslib} # 触摸库

	# opt_copy ${Opt_arm_alsa} # 音频以及 ALSA 驱动框架

	# opt_copy ${Opt_arm_zlib} # 视频播放软件 mplayer 用到了 zlib 库
	# opt_copy ${Opt_arm_libmad}  # 视频播放软件 mplayer 用到了 libmad 库

	# opt_copy ${Opt_arm_MPlayer} # 移植 视频播放软件 mplayer
}

f_alsa() {
	# 音频以及 ALSA 驱动框架 sudo apt install -y alsa*
	func_echo_loop "音频以及 ALSA 驱动框架
	ALSA 是 Advanced Linux Sound Architecture，高级 Linux声音架构的简称,
它在Linux上提供了音频和MIDI（Musical Instrument Digital Interface，
音乐设备数字化接口）的支持。在2.6系列内核中，ALSA已经成为默认的声音子系统，
用来替换2.4系列内核中的OSS（Open Sound System。开放声音系统）。
ALSA的主要特性包含：高效地支持从消费类入门级声卡到专业级音频设备全部类型的音频接口，
全然模块化的设计。 支持对称多处理（SMP）和线程安全。
对OSS的向后兼容，以及提供了用户空间的alsa-lib库来简化应用程序的开发。
	ALSA是一个全然开放源码的音频驱动程序集，除了像OSS那样提供了一组内核驱动程序模块之外，
ALSA还专门为简化应用程序的编写提供了对应的函数库，与OSS提供的基于ioctl的原始编程接口相比。
ALSA函数库使用起来要更加方便一些。利用该函数库，开发人员能够方便快捷的开发出自己的应用程序，
细节则留给函数库内部处理。当然 ALSA也提供了类似于OSS的系统接口，
只是ALSA的开发人员建议应用程序开发人员使用音频函数库而不是驱动程序的API。
	alsa-lib 是ALSA 应用库(必需基础库)，alsa-utils 包含一些ALSA小的测试工具.
如 aplay、arecord 、amixer播放、录音和调节音量小程序，
对于一些应用开发者只需要以上两个软件包就可以了。"

	# opt_copy ${Opt_arm_alsa}   # 音频以及 ALSA 驱动框架

	# 开发板根文件系统中的 /etc/profile 文件内容
	# ALSA_CONFIG_PATH 用于指定 alsa 的 配置文件，这个配置文件是 alsa-lib 编译出来的
	# export ALSA_CONFIG_PATH=/opt/arm_alsa_lib/config/alsa.conf
	#	func_execute_sudo rm -rf opt/${Opt_arm_alsa##*/}
	#	func_mkdir 777 opt/${Opt_arm_alsa##*/}
	#	func_cpl ${Opt_arm_alsa}/config opt/${Opt_arm_alsa##*/}/

	func_cpl ${Opt_arm_alsa}/bin/\* usr/bin/
	# func_cpf ${Opt_arm_alsa}/include/\* usr/include/
	func_cpf ${Opt_arm_alsa}/lib/\* usr/lib/
	func_cpf ${Opt_arm_alsa}/sbin/\* usr/sbin/
	func_cpf ${Opt_arm_alsa}/share/\* usr/share/

	# 录音播放测试命令
	# record_line=record_line.wav
	# arecord  -f cd  -d 5  ${record_line} # 录制 音频
	# aplay ${record_line} # 播放 音频

	func_echo "ALSA音频架构简单介绍
	开机自动配置声卡
	使用 alsactl 保存/恢复 声卡设置
		声卡设置的保存通过 alsactl 工具来完成，此工具也是 alsa-utils 编译出来的。
	因为 alsactl 默认将声卡配置文件保存在 /var/lib/alsa 目录下。
	$ alsactl -f /var/lib/alsa/asound.state store # 保存根文件系统的声卡设置
	修改 /var/lib/alsa/asound.state 文件
	打开 /etc/rc.local 文件，在最后面追加如下内容
		if [ -f \"/var/lib/alsa/asound.state\" ]; then
			echo \"ALSA: Restoring mixer setting ...\"
			alsactl -f /var/lib/alsa/asound.state restore & # 恢复(自定义的)声卡设置
		fi      "
	func_mkdir 777 var/lib/alsa # 创建文件夹
}

f_MPlayer() {
	func_echo_loop "移植 mplayer 这个强大的视频播放软件。
mplayer 是一款开源的多媒体播放器，可以用来播放音、视频，
mplayer 自带多种格式的解码器，不需要我们再另外安装 
mplayer test.avi -fs //居中播放视频 "
	if false; then
		if true; then
			# opt_copy ${Opt_arm_zlib}    # 视频播放软件 mplayer 用到了 zlib 库
			# opt_copy ${Opt_arm_libmad}  # 视频播放软件 mplayer 用到了 libmad 库
			# opt_copy ${Opt_arm_MPlayer} # 移植 视频播放软件 mplayer

			# 视频播放软件 mplayer 用到了 zlib 库
			func_cpf ${Opt_arm_zlib}/prefix/lib/\* usr/lib/
			func_cpf ${Opt_arm_zlib}/prefix/share/\* usr/share/
			# func_cpf ${Opt_arm_zlib}/prefix/include/\* usr/include/

			# 视频播放软件 mplayer 用到了 libmad 库
			func_cpf ${Opt_arm_libmad}/prefix/lib/\* usr/lib/
			# func_cpf ${Opt_arm_libmad}/prefix/include/\* usr/include/

			# 移植 视频播放软件 mplayer
			func_cpf ${Opt_arm_MPlayer}/prefix/bin/\* usr/bin/
		else
			# 移植 视频播放软件 mplayer
			func_cpf ${MPlayer} usr/bin/
		fi
	else
		local tmp_print="播放器问题解决：
1 有声音无图像 查找 (ARM + fbdev)
	vo=xv,x11,fbdev 
	$ mplayer -vo help # 更多的显示模式
2 无法全屏 查找 #zoom=yes 去掉 # 即可
3 混音工具(可选) #mixer = /dev/mixer 
4 设置输出频率(可选) #af=lavcresample=44100
5 开启默认缓存(可选) # cache settings
#cache = 8192
#cache-min = 20.0
#cache-seek-min = 50 
--------------------
ao=oss	声音播放模式，oss是兼容性最好的播放模式，推荐；也可以试试sdl模式
fs=yes 	全屏模式
gui = yes	默认是图形化操作界面，需要你先前用./configure --enable-gui 来编译，
framedrop = yes	允许跳帧，如果你的机器CPU速度非常非常慢的话,对于366MHZ以上的机器，建议都设成no或前面加#号 "
		func_echo "${tmp_print}"
		${Sudo} sed -i -E -e 's/^# vo=xv,x11*/vo=fbdev,xv,x11/' etc/mplayer/mplayer.conf
		# func_execute_sudo gedit etc/mplayer/mplayer.conf
	fi
}

f_dhcp() {
	func_echo_loop "配置 DHCP 联网
	默认没有配置 DHCP，ubuntu 启动以后不能直接联网"
	func_echo "开发板有1个网卡，在 linux 系统下的 网卡名字 为 eth0"
	func_chmod 777 etc/network
	if [ ! -f etc/network/interfaces.d/eth0 ]; then
		func_touch 777 etc/network/interfaces.d/eth0
	fi
	# 超时模式
	${Sudo} echo "auto eth0" >etc/network/interfaces.d/eth0
	# 热插拔模式
	${Sudo} echo "allow-hotplug eth0" >>etc/network/interfaces.d/eth0
	${Sudo} echo "iface eth0 inet dhcp" >>etc/network/interfaces.d/eth0
	# 无状态
	${Sudo} echo "iface eth0 inet6 auto" >>etc/network/interfaces.d/eth0
}

# Ubuntu server 开机网络需要等待5分钟 修改 成 30sec
TimeoutStartSec_modify_sec() {
	#while [ $# -gt 0 ]; do
	#sed -i -E -e 's/^TimeoutStartSec=([[:alnum:]].)*(.)*/TimeoutStartSec=2sec/' $1
	${Sudo} sed -i -E -e 's/^TimeoutStartSec=([[:alnum:]].)*(.)*/TimeoutStartSec='$2'sec/' $1
	func_echo "$1"
	${Sudo} grep -E "^TimeoutStartSec=" $1
	#shift
	#done
}
f_time() {
	func_echo_loop "修改服务等待时间  TimeoutStartSec=5min"
	TimeoutStartSec_modify_sec usr/lib/systemd/system/networking.service 20
	TimeoutStartSec_modify_sec usr/lib/systemd/system/ifup@.service 20
}

env_set() {
	if [ $# -ne 3 ]; then
		func_echo -e "env_set()"
		exit
	fi
	#	local chmod=777
	#	local source=$2
	#	local target=$3
	#	func_chmod ${chmod} ${target}
	#	sed -i -E -e "/^### BEGIN #!!!*/,/^### END #!!!*/d" ${target}
	#	cat ${source} | sed -n -E -e "/^### BEGIN #!!!*/,/^### END #!!!*/p" >>${target}

	func_chmod $1 $3
	sed -i -E -e "/^### BEGIN #!!!*/,/^### END #!!!*/d" $3
	cat $2 | sed -n -E -e "/^### BEGIN #!!!*/,/^### END #!!!*/p" >>$3
}

f_env() {
	func_echo_loop "环境变量"

	env_set 777 ${Profile} etc/profile
	env_set 777 ${Profile} root/.bashrc

	#	if true; then
	if false; then
		local homefiles
		homefiles="$(ls home)"
		for tmp in ${homefiles}; do
			if [ -f "home/${tmp}/.bashrc" ]; then
				# # 增加文件内容 alias h='history'
				# ${Sudo} sed -i -E -e "/^alias h='history'/d" home/${tmp}/.bashrc
				# #	i 上面插入;		a 下面插入
				${Sudo} sed -i -E -e "/^alias l=/ a alias h='history'" home/${tmp}/.bashrc
			fi
		done
	fi

	func_echo "修改文件 ~/.bashrc 尾，
删除 自动补全工具 bash-completion 前注释符 #，使 bash-completion 生效。

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi     "
	func_gedit root/.bashrc
}

f_root_user() {
	func_echo_loop "帐户 密码"
	echo -e "linux 下取消用户名和密码直接登录, 假定目前 只有 root 用户
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
02. 添加 --autologin root
    Serial 串口自动登录 root, 修改 /usr/lib/systemd/system/serial-getty\@.service 
        # ExecStart=-/sbin/agetty -o '-p -- \\\\u' --keep-baud 115200,38400,9600 %I \$TERM
        ExecStart=-/sbin/agetty -o '-p -- \\\\u' --autologin root 115200,38400,9600 %I \$TERM 
        或 ExecStart=-/sbin/agetty --autologin root -8 -L %I 115200 \$TERM 
    LCD 修改 /usr/lib/systemd/system/getty\@.service
        # ExecStart=-/sbin/agetty -o '-p -- \\\\u' --noclear %I \$TERM
        ExecStart=-/sbin/agetty -o '-p -- \\\\u' --noclear %I \$TERM --autologin root  "
	func_echo "修改 etc/passwd"
	func_gedit etc/passwd
	func_echo "修改 etc/shadow"
	func_gedit etc/shadow
	func_echo "Serial 串口自动登录 root, 修改 usr/lib/systemd/system/serial-getty\@.service"
	func_gedit usr/lib/systemd/system/serial-getty\@.service
	func_echo "LCD 修 usr/lib/systemd/system/getty\@.service"
	func_gedit usr/lib/systemd/system/getty\@.service

	func_echo_loop "免密+登录 root"
	func_echo "在末尾添加：
greeter-show-manual-login=true
all-guest=false "
	func_gedit usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
	func_echo "注釋掉:
# auth required	pam_succeed_if.so user != root quiet_success "
	func_gedit etc/pam.d/gdm-autologin etc/pam.d/gdm-password
	func_echo "修改:
	mesg n 2> /dev/null || true
	为
	tty -s && mesg n || true   	"
	func_gedit root/.profile
	func_echo "在末尾添加：
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=root
TimedLoginEnable=true
TimedLogin=root
TimedLoginDelay=10 "
	func_gedit etc/gdm*/custom.conf
}

f_link_abs_rel() {
	# func_cd ${DIR_base_rootfs}
	func_echo_loop '将 根文件系统 sysroot 目录下所有的 符号链接 进行 "绝对->相对" 转换'
	${Link_abs_rel}
	# func_cd -
}

################################################################

all_function() {
	f_sudoers
	f_net
	f_language
	f_copy_files
	f_opt_copy
	# f_alsa
	f_MPlayer
	# f_dhcp
	f_time
	f_env
	f_root_user
	f_link_abs_rel
}

echo_function="\e[0m
=======================================
0 --- all_function ---
1	f_sudoers
2	f_net
3	f_language
4	f_copy_files
5	f_opt_copy
6	# f_alsa
7	f_MPlayer
8	# f_dhcp
9	f_time
10	f_env
11	f_root_user
20	f_link_abs_rel
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
			break
			;;
		1)
			f_sudoers
			;;
		2)
			f_net
			;;
		3)
			f_language
			;;
		4)
			f_copy_files
			;;
		5)
			f_opt_copy
			;;
		6)
			# f_alsa
			;;
		7)
			f_MPlayer
			;;
		8)
			# f_dhcp
			;;
		9)
			f_time
			;;
		10)
			f_env
			;;
		11)
			f_root_user
			;;
		20)
			f_link_abs_rel
			;;
		*)
			echo -e "\033[1;5;7;31;40m error \e[0m"
			;;
		esac
	done
}
main

exit 0
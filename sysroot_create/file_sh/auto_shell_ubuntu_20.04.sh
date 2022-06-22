#! /bin/bash
#  #! /bin/bash -e

f_ARM_tool_function() {
	local ARM_tool_function=""
	ARM_tool_function="/opt/ARM_tool_function.sh
	/file_sh/ARM_tool_function.sh"
	for tmp in ${ARM_tool_function}; do
		if [ -f ${tmp} ]; then
			source ${tmp}
			return
		else
			echo -e "No exit : ${tmp}"
		fi
	done
	exit 1
}
f_ARM_tool_function

################################################################

func_echo -p "auto_shell_ubuntu_20.04.sh  begin"

func_chmod 777 dev home media mnt opt tmp dev

######################### modify #########################

# 自动挂载 nfs 服务器"
IP_host_nfs=10.23.21.204
Dir_host_nfs=/home/zcq/arm_nfs

System_set_store=/system_set_store
func_mkdir 777 ${System_set_store}

################################################################

f_modules() {
	func_echo_loop "加载驱动模块"
	/modules/insmod.ko.sh # 2>>/dev/null # 加载驱动模块
}

f_network() {
	func_echo_loop "配置 DHCP 联网"
	# Linux重启网卡的三种方法：
	# 一、network
	#   利用root帐户
	#   service network restart
	#   或者 /etc/init.d/networking restart
	# 二、ifdown/ifup
	#   ifdown eth0 # 禁用网卡
	#   ifup eth0 # 启用网卡
	# 三、ifconfig
	#   ifconfig eth1 down
	#   ifconfig eth1 up

	local val_net=""
	val_net="$(ip addr)"
	# val_net="$(echo "${val_net}" | grep -P "^([[:digit:]])+:")"
	val_net="$(echo "${val_net}" | awk -F ': ' '/^[[:digit:]]+/ {print $2}')"
	# val_net="$(echo "${val_net}" | grep -v 'lo')"           # 去掉包含 lo 的行
	val_net="$(echo "${val_net}" | grep -P -v 'lo|usb[0-9]+|sit[[:alnum:]]+')"
	${Sudo} echo "${val_net}" >${System_set_store}/network_info.log # eth0

	if false; then
	# if true; then
		for for_i in ${val_net}; do
			if [ -f /etc/network/interfaces.d/${for_i} ]; then
				return
			fi
		done
	fi

	if false; then
		local num_i=0
		local IP=0
		local Mask=255.255.255.0
		#	local DNS=192.168.6.1
		local Broadcast=192.168.6.255
		local MAC=0
		local Gateway=192.168.6.1
	fi

	local dir_interfaces=/etc/network/interfaces
	func_chmod 777 ${dir_interfaces}
	${Sudo} sed -i -E -e '/^###----### Begin/,/^###----### End/ d' ${dir_interfaces}

	echo "###----### Begin" >>${dir_interfaces}

	for for_i in ${val_net}; do
		func_echo "配置 网卡 ${for_i}"

		${Sudo} echo "auto ${for_i}
allow-hotplug ${for_i}
iface ${for_i} inet dhcp
iface ${for_i} inet6 auto " >/etc/network/interfaces.d/${for_i}

		echo "
auto ${for_i} # 超时模式
allow-hotplug ${for_i}  # 热插拔模式
iface ${for_i} inet dhcp
# iface ${for_i} inet6 dhcp
iface ${for_i} inet6 auto # 无状态
" >>${dir_interfaces}

		if false; then
			IP=192.168.6.$((45 + ${num_i}))
			MAC=40:50:60:70:80:$((10 + ${num_i}))
			func_execute_sudo ifconfig ${for_i} down
			func_execute_sudo ifconfig ${for_i} add $IP
			func_execute_sudo ifconfig ${for_i} netmask $Mask
			func_execute_sudo ifconfig ${for_i} broadcast $Broadcast
			func_execute_sudo ifconfig ${for_i} hw ether $MAC
			func_execute_sudo route add default gw $Gateway # 为AF修改路由表
			func_execute_sudo ifconfig ${for_i} up
			let 'num_i++'
		fi
	done

	echo "###----### End" >>${dir_interfaces}

	func_chmod 777 /etc/network/
}

f_check_network() {
	func_echo_loop "检测网络是否通畅"
	local DOMAIN=www.baidu.com
	ping -c 2 $DOMAIN >/dev/null
	local ping_status=$?
	if [ $ping_status -eq 0 ]; then
		func_echo "Network to $DOMAIN is ok: 网络通畅: "
		val_check_network=Y
	else
		func_echo -e "Network to $DOMAIN is error: 网络不通畅"
		val_check_network=N
	fi
}

f_time() {
	func_echo_loop "时间校正"
	local printstr="
	设置当前时间: 
	$ sudo date -s '2019-08-31 18:13:00'	
	与 时间服务器 同步:
	$ sudo timedatectl set-timezone Asia/Shanghai # 更改当前时区为 东八区
	需要 24小时制，修改 /etc/default/locale 一行: LC_TIME=en_DK.UTF-8 
	$ sudo hwclock --systohc # 将系统时间写入硬件时间 "
	func_echo "${printstr}"

	# 与 时间服务器 同步
	# func_apt -i ntpdate # 安装 ntpdate 工具
	# func_execute ntpdate 20.189.79.72  # time.windows.com  20.189.79.72
	# func_execute ntpdate 114.118.7.163 # 和国家授时中心时间对齐  ntp.ntsc.ac.cn  114.118.7.163
	# func_execute ntpdate 94.130.49.186 # 设置系统时间与网络时间同步  cn.pool.ntp.org  94.130.49.186
	# func_execute hwclock --systohc     # 将系统时间写入硬件时间
	# func_execute hwclock -s -f /dev/rtc # 硬件时钟
	# func_execute timedatectl set-timezone Asia/Shanghai # 更改当前时区为 东八区
	# 需要 24小时制，修改 /etc/default/locale；修改 一行：LC_TIME=en_DK.UTF-8

	if [ "${val_check_network}" == "Y" ]; then
		# 网络通畅
		func_execute_sudo ntpdate cn.pool.ntp.org
		func_execute_sudo timedatectl set-timezone Asia/Shanghai # 更改当前时区为 东八区
		func_execute_sudo hwclock --systohc                      # 将系统时间写入硬件时间
	else
		# 网络不通畅
		func_execute_sudo hwclock -s -f /dev/rtc # 将硬件时钟写入系统时间
	fi
}

f_brightness() {
	local brightness_info=${System_set_store}/brightness_info.log
	if [ -f ${brightness_info} ]; then
		return
	fi
	func_echo_loop "屏幕亮度"
	local dir_brightness=""
	dir_brightness=/sys/class/backlight/backlight
	# dir_brightness=/sys/devices/platform/backlight/backlight/backlight
	if [ -d "${dir_brightness}" ]; then
		local max_brightness=""
		max_brightness="$(cat ${dir_brightness}/max_brightness)"
		local now_brightness=""
		now_brightness="$(cat ${dir_brightness}/brightness)"
		local printstr="
背光设备树节点设置了 ${max_brightness} 个等级的背光调节，
可以设置为 0 ~ ${max_brightness}, 通过设置背光等级来实现 LCD 屏幕背光亮度的调节。
修改屏幕亮度，
	输入命令 查看 当前屏幕背光 最大值(${max_brightness}):
	$ cat /sys/class/backlight/backlight/max_brightness
	输入命令 查看 当前屏幕背光 值:
	$ cat /sys/class/backlight/backlight/brightness
	设置当前屏幕背光值:
	$ echo ${max_brightness} > /sys/class/backlight/backlight/brightness
	$ echo ${max_brightness} > /sys/devices/platform/backlight/backlight/backlight/brightness
	设置 brightness 为 0 的话 就会 关闭 LCD 背光, 屏幕熄灭。
	屏幕背光 最大值: max_brightness=${max_brightness}
	屏幕背光 当前值: now_brightness=${now_brightness}
	屏幕背光 修改值: brightness=${max_brightness}	"
		# func_echo "${printstr}"
		echo "${printstr}" >${brightness_info}
		echo ${max_brightness} >${dir_brightness}/brightness
	else
		func_echo -e "empty: ${dir_brightness}"
	fi
}

f_blankinterval() {
	func_echo_loop "熄屏功能"
	func_echo "
关闭 10 分钟熄屏功能
在 Linux 源码中找到 drivers/tty/vt/vt.c 文件，
在此文件中找到 blankinterval 变量，值改为 0 即可关闭熄屏
如果产品需要去掉光标，只需要修改VT代码，
vc->vc_cursor_type = CUR_DEFAULT 修改为 CUR_NONE 即可"
	for i in 0 1 2 3 4 5 6; do
		if [ -e "/dev/tty${i}" ]; then
			echo "关闭熄屏 /dev/tty${i}"
			echo -e "\033[9;0]" >/dev/tty${i} # 关闭熄屏
		fi
	done
}

f_alsa() {
	func_echo_loop "ALSA 音频架构"
	local printstr="
	ALSA 是 Advanced Linux Sound Architecture，高级 Linux声音架构的简称,
	alsa-lib 是ALSA 应用库(必需基础库)，alsa-utils 包含一些ALSA小的测试工具.
	如 aplay、arecord 、amixer 播放、录音和调节音量小程序
	声卡设置的保存通过 alsactl 工具来完成，此工具也是 alsa-utils 编译出来的。
	因为 alsactl 默认将声卡配置文件保存在 /var/lib/alsa 目录下。

	修改 /var/lib/alsa/asound.state 文件, 设置/恢复(自定义的)声卡设置
	保存 根文件系统的声卡设置: $ alsactl -f /var/lib/alsa/asound.state store #
	恢复 (自定义的)声卡设置:  $ alsactl -f /var/lib/alsa/asound.state restore  "
	func_echo "${printstr}"

	# 保存根文件系统的声卡设置
	local file_asound=${System_set_store}/old_asound.state
	if [ ! -f ${file_asound} ]; then
		func_execute_sudo alsactl -f ${file_asound} store
	fi

	local set_audio_rclocal=""
	if true; then
		set_audio_rclocal=/file_sh/zdyz_set_audio_rc.local.sh
	else
		set_audio_rclocal=/file_sh/itop4412_set_audio_rc.local.sh
	fi
	if [ -f ${set_audio_rclocal} ]; then
		${Sudo} ${set_audio_rclocal} &>${System_set_store}/${set_audio_rclocal##*/}.log
	fi

	# amixer + [Available commands]

	# amixer scontrols   	显示 所有 混音器控件
	# amixer scontents		显示 所有 混音器控件内容
	# amixer sset sID P  	set contents for one mixer simple control / scontrols
	# amixer sget sID    	get contents for one mixer simple control / scontrols

	# amixer controls    	显示 给定卡 的所有控件
	# amixer contents    	显示 给定卡 的所有控件的内容
	# amixer cset cID P 	set control contents for one control / controls
	# amixer cget cID    	get control contents for one control / controls

	# amixer --help //查看 amixer 帮助信息
	# 4、 设置声卡
	# 知道了设置项和设置值，那么设置声卡就很简单了，直接使用下面命令即可：
	# amixer sset 设置项目 设置值
	# 或：
	# amixer cset 设置项目 设置值
	# 5、获取声卡设置值
	# 如果要读取当前声卡某项设置值的话使用如下命令：
	# amixer sget 设置项目
	# 或：
	# amixer cget 设置项目

	func_echo "
	播放音乐,在命令行输入：
	$ aplay Music_20.wav # 不可以播放 *.mp3 文件
	查看控制单元, amixer 主要完成控制部分， 命令行执行：
	$ amixer controls    # 查看可使用的接口
	$ amixer scontrols   # 查看可使用的接口 "

	file_asound=${System_set_store}/"amixer_controls.log"
	if [ ! -f ${file_asound} ]; then
		# Ubuntu 文件系统声卡的配置
		# func_execute_sudo amixer controls # 查看可使用的接口
		echo "$(${Sudo} amixer controls)" >${System_set_store}/"amixer_controls.txt"
	fi
	file_asound=${System_set_store}/"amixer_scontrols.log"
	if [ ! -f ${file_asound} ]; then
		echo "$(${Sudo} amixer scontrols)" >${System_set_store}/"amixer_scontrols.txt"
	fi

	if true; then
		# 由于 Ubuntu 在 root 用户下，为了安全考虑默认是关闭了声音系统的。
		# 因为 root 登录后 pulseaudio 没有启动， 所以要先启动它，
		# 需要将 root 加到 pulse 和 pulse-access 组， 在控制台使用以下命令启动
		func_execute_sudo usermod -a -G pulse-access root
		func_execute_sudo gpasswd -a root pulse
		func_execute_sudo gpasswd -a root pulse-access
	fi

	# 编辑  /etc/default/pulseaudio
	# 修改 pulseaudio 文件中
	# 参数 PULSEAUDIO_SYSTEM_START 修改为 1，
	# 参数 DISALLOW_MODULE_LOADING 修改为 0。
	# 表示允许运行在 system 环境， 允许动态加载模块
	# ${Sudo} sed -i -E -e '/^PULSEAUDIO_SYSTEM_START=/d' xx
	# ${Sudo} sed -i -E -e '/^DISALLOW_MODULE_LOADING=/d' xx
}

f_disk() {
	func_echo_loop "挂载盘"
	func_echo "注意 U 盘要为 FAT32 格式的！
	NTFS 和 exFAT 由于版权问题在 Linux 下支持不完善，
操作的话可能会有问题，比如只能读，不能写或者无法识别等
mount  -t vfat  -o iocharset=utf8   /dev/sdb1   /mnt/disk/ # 挂载
-t vfat 指定挂载所使用的文件系统类型，vfat 是 FAT 文件系统，
-o iocharset=utf8 设置硬盘编码格式为 utf8，否则的话 U 盘里面的中文会显示乱码！
umount /mnt/disk # 卸载
	${Sudo} /bin/mount -a # 挂载 fstab 中的所有文件系统 /etc/fstab "
	# func_execute_sudo mount -a # 挂载 fstab 中的所有文件系统 /etc/fstab

	# 参考 busybox
	# /dev/fd0        /media/floppy0  auto        rw,user,noauto,exec,utf8    0   0
	# devpts          /dev/pts        devpts      gid=5,mode=620              0   0
	# tmpfs           /dev/shm        tmpfs       defaults                    0   0
}

f_nfs() {
	func_echo_loop "支持 nfs 挂载 为了每次开发板开启时，自动挂载nfs服务器"
	# if false; then
	if [ "${val_check_network}" == "Y" ]; then
		func_mkdir 777 /mnt/nfs
		# pc端 虚拟机 linux 的 ip  192.168.6.40
		echo "${Sudo} mount -t nfs -o nolock ${IP_host_nfs}:/home/zcq/arm_nfs /mnt/nfs &"
		${Sudo} mount -t nfs -o nolock ${IP_host_nfs}:${Dir_host_nfs} /mnt/nfs &
	fi
}

f_language() {
	# sudo apt-get install -y zhcon -f # 解决 控制终端 (/dev/tty) 中文乱码
	#execute_sudo zhcon --utf8 --drv=vga # 启动 zhcon，中文乱码。
	#execute_sudo zhcon --utf8 --drv=fb # 启动 zhcon，中文显示正常。
	#execute_sudo zhcon --utf8 --drv=auto # 启动 zhcon，中文显示正常。
	func_echo_loop "支持中文显示的控制台"
	func_echo "
zhcon --utf8 --drv=fb 		
zhcon --utf8 --drv=auto		
fbterm 					# 控制台中 按 Ctrl+Alt+E 退出 fbterm 
    alias zhconf='zhcon --utf8 --drv=fb' 		
    alias zhcona='zhcon --utf8 --drv=auto'		"
}

##############################################################

all_function() {
	f_modules
	f_network
	f_check_network
	f_time
	f_brightness
	f_blankinterval
	f_alsa
	# f_disk
	f_nfs
	f_language
}
all_function

################################################################

if [ -e /proc/sys/kernel/hung_task_timeout_secs ]; then
	func_echo "/proc/sys/kernel/hung_task_timeout_secs"
	echo 0 >/proc/sys/kernel/hung_task_timeout_secs
fi

${Sudo} dmesg >${System_set_store}/"linux_boot_info.log"

func_chmod 777 ${System_set_store}

################################################################

# vsftpd &
# /sbin/sshd &

#/bin/qtopia &
#/bin/qt4 &

################################################################

func_echo -p "auto_shell_ubuntu_20.04.sh end"

exit 0

# chown root:tty /dev/ttySAC*
# chmod 777 /dev/ttySAC*
# func_execute_sudo chown root:root /usr/bin/sudo
# func_execute_sudo chmod 4755 /usr/bin/sudo

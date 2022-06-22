### BEGIN #!!!#

if [ -z "${ZCQ_ubuntu_arm_env}" ]; then
	export ZCQ_ubuntu_arm_env="set env"

	if [ -z "${Sudo}" ]; then
		Sudo="sudo"
	fi
	if [ "$(whoami)" = "root" ]; then
		Sudo=""
	fi

	################################################################################

	# No core files by default
	# ulimit -S -c 0 >/dev/null 2>&1

	if false; then
		if [ -n "$(/bin/hostname)" ]; then
			/bin/hostname "itop4412"
		fi

		if false; then
			USER="$(id -un)"
			HOME=/
		else
			USER=root
			HOME=/root
		fi

		HOSTNAME="$(/bin/hostname)"
		LOGNAME=${USER}

		# PS1="[${USER}@${HOSTNAME}]\W\# "
		PS1="[\033[1;32m${USER}\e[0m@\033[1;34m${HOSTNAME}\e[0m]\033[34m\W\e[0m\033[35m\#\e[0m "

		export USER HOME HOSTNAME LOGNAME PS1
	fi

	# if true; then
	if false; then
		# PATH 环境变量保存着可执行文件可能存在的目录
		PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}
		export PATH
	fi

	if false; then
		runlevel=S
		prevlevel=N
		umask 022
		export runlevel prevlevel
	fi

	################################################################################

	if true; then
		# enable color support of ls and also add handy aliases
		#alias dir='dir --color=auto'
		#alias vdir='vdir --color=auto'
		# alias grep='grep --color=auto'
		# alias fgrep='fgrep --color=auto'
		# alias egrep='egrep --color=auto'
		# alias vi='vi --color=auto'
		# alias ll='ls -alF'
		# alias la='ls -a'
		# alias l='ls -CF'
		alias h='history'
		alias zhconf='${Sudo} zhcon --utf8 --drv=fb'
		alias zhcona='${Sudo} zhcon --utf8 --drv=auto'
	fi

	################################################################################

	EVENT_tslib=/dev/input/event1 # 触摸屏设备
	#	mouse_dev=/dev/input/event4    # mouse 设备

	# EVENT_num=$(cat /proc/bus/input/devices | grep -E 'edt-ft5|edt_ft5x06|TSC2007|ft5x0x_ts|goodix-ts' -A4 | tail -n1 | awk '{print $NF}')

	if false; then
		#	if true; then

		# 配置 tslib 的环境变量
		# 支持触摸屏 首先应用程序要链接 ts 库，在 qtcreator 的工程文件 *.pro 里加上 LIBS += -lts

		export TSLIB_ROOT=/opt/arm_tslib # 触摸库

		# 设定控制台设备为 none ， 否则默认为 /dev/tty ，
		# 这样可以避免出现“ open consoledevice:
		# No such file or directory KDSETMODE: Bad file descriptor ” 的错误
		export TSLIB_CONSOLEDEVICE=none

		export TSLIB_FBDEVICE=/dev/fb0                # 指定 frambuffer 帧缓冲设备 /dev/fb0
		export TSLIB_TSDEVICE=${EVENT_tslib}          # 触摸屏设备
		export TSLIB_CONFFILE=$TSLIB_ROOT/etc/ts.conf # tslib 配置文件
		export TSLIB_PLUGINDIR=$TSLIB_ROOT/lib/ts     # 指定 tslib 插件文件的路径

		export TSLIB_TSEVENTTYPE=input # 事件类型

		export LD_PRELOAD=$TSLIB_ROOT/lib/libts.so

		# 电阻屏专用，如果是电容屏，可不用加这项
		# export TSLIB_CALIBFILE=/etc/pointercal # 指定校准文件的存放位置
		# 电容屏加了这项，如果使用 ts_calibrate 校准后会生成 /etc/pointercal 文件，请把它删除！
		# 否则可以触摸不准确，因为电容屏不需要校准。
	fi

	if false; then
		#	if true; then

		# 配置 Qt5 的环境变量

		export QT_ROOT=/opt/arm_qt_ubuntu # qt 库

		#添加输入设备
		export QWS_MOUSE_PROTO=tslib:${EVENT_tslib} # 指定触摸设备
		#	export QT_QPA_EVDEV_MOUSE_PARAMETERS=${mouse_dev}

		# 将触摸屏的点击事件配置成qt的鼠标点击事件以后会有一个光标，
		export QT_QPA_FB_HIDECURSOR=1
		# 这样隐藏不掉的，在 qt 项目中配置 QWSServer::setCursorVisible(FALSE); /* ARM下隐藏鼠标 */

		# 屏幕的宽度和高度（以像素为单位）
		export QT_QPA_EGLFS_WIDTH=1024
		export QT_QPA_EGLFS_HEIGHT=600

		# export QT_QPA_EGLFS_PHYSICAL_WIDTH=1024 #根据你的显示器设置宽度，单位 mm
		# export QT_QPA_EGLFS_PHYSICAL_HEIGHT=600 #根据你的显示器设置高度，单位 mm

		_QT_WIDTH_HEIGHT=${QT_QPA_EGLFS_WIDTH}x${QT_QPA_EGLFS_HEIGHT}

		export QT_QPA_GENERIC_PLUGINS=tslib:${EVENT_tslib}:edevmouse:${mouse_dev}

		export QT_QPA_FONTDIR=/usr/share/fonts # 可以从 C:\Windows\Fonts 目录拷贝字体到此处
		# export QT_QPA_FONTDIR=$QT_ROOT/lib/fonts            # qt 字库的目录

		export QT_QPA_PLATFORM_PLUGIN_PATH=${QT_ROOT}/plugins/platforms

		# 添加显示设备，可以为：linuxfb, minimal, offscreen, vnc，
		# 比较全的：eglfs, linuxfb, minimal, minimalegl, offscreen, xcb 根据编配置不同而不同
		# export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0:size=800x480:mmsize=800x480:offset=0x0:tty=/dev/tty1
		#size 指定屏幕大小(以像素为单位)，软件可以自己查询到可以不设置，可以显式地指定值
		#mmsize 指定物理宽度和高度，单位为毫米
		#offset 屏幕左上角的偏移量(以像素为单位)
		#旋转90°显示(已修改源码编译可以这样)，或者运行程序时加入参数:
		# ./app -platform linuxfb:fb=/dev/fb0:rotation=90
		#export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0:rotation=90

		# QT_QPA_DEFAULT_PLATFORM=linuxfb:fb=/dev/fb0
		# QT_QPA_PLATFORM 指定 QT 的运行平台，这里使用 linuxfb
		# export QT_QPA_PLATFORM=eglfs                        # 设置平台插件
		QT_QPA_PLATFORM=linuxfb:fb=$TSLIB_FBDEVICE
		# size=<宽度>x<高度> 以像素为单位指定屏幕大小
		QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:size=${_QT_WIDTH_HEIGHT}
		# mmsize=<宽度>x<高度>	以毫米为单位指定物理宽度和高度
		QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:mmSize=${_QT_WIDTH_HEIGHT}
		# offset=<宽度>x<高度>	以像素为单位指定屏幕左上角的偏移量。默认位置在(0, 0)。
		QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:offset=0x0
		QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:tty=/dev/tty1
		# nographicsmodeswitch	指定不将虚拟终端切换到图形模式 ( KD_GRAPHICS)。
		# 通常，启用图形模式会禁用闪烁的光标和屏幕空白。但是，当设置此参数时，这两个功能也会被跳过。
		# tty=/dev/ttyN	覆盖虚拟控制台。仅在 nographicsmodeswitch 未设置时使用。
		export QT_QPA_PLATFORM

		# 使用的 X11 显示，需设置显示地址
		# export DISPLAY=:0.0

		# 执行 gui 程序可显示错误信息方便调试！
		# export QT_DEBUG_PLUGINS=1

		export QT_PLUGIN_PATH=$QT_ROOT/plugins # qt 插件的目录
		export QML2_IMPORT_PATH=$QT_ROOT/qml

		# 注意本次反转180也就是Y轴翻转，【是触摸，非显示】这个是触摸屏幕的旋转和颠倒
		# export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=${EVENT_tslib}:rotate=180:invertx

		# 表示 EGLFS【显示】旋转90度，此配置需要编译 opengl。
		# export QT_QPA_EGLFS_ROTATION=90

		#	export QT_DEBUG_PLUGINS=1   # 使用 debug 模式
		export QT_QPA_EGLFS_TSLIB=1 # Qt启用 Tslib 触摸
		export QT_QPA_FB_TSLIB=1
		# screen_size=$(echo $(fbset | grep -E "timings" | awk '{print $3}'))
		# case $screen_size in
		# 220)
		#     unset QT_QPA_FB_TSLIB
		#     ;;
		# 213)
		#     unset QT_QPA_FB_TSLIB
		#     ;;
		# esac
		################################################################################

		export PKG_CONFIG_LIBDIR=${QT_ROOT}/lib # 设置 pkg-config

		# 添加 QT 和 触摸库 的环境变量
		LD_LIBRARY_PATH=${QT_ROOT}/lib:${QT_ROOT}/plugins/platforms:${LD_LIBRARY_PATH}
		LD_LIBRARY_PATH=${TSLIB_ROOT}/lib:${LD_LIBRARY_PATH}

		# 添加 qt 和 tslib 执行件路径
		PATH=${QT_ROOT}/bin:${TSLIB_ROOT}/bin:${PATH}

		################################################################################
		export TERM=vt100
		export TERMINFO=/usr/share/terminfo
	fi

	################################################################################

	# 开发板根文件系统中的 /etc/profile 文件内容
	# ALSA_CONFIG_PATH 用于指定 alsa 的配置文件，这个配置文件是 alsa-lib 编译出来的
	export ALSA_CONFIG_PATH=/usr/share/alsa/alsa.conf
	# export ALSA_CONFIG_PATH=/opt/arm_alsa_lib/config/alsa.conf

	# LD_LIBRARY_PATH 环境变量保存着库文件所在的目录
	LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib:/usr/lib/arm-linux-gnueabihf:${LD_LIBRARY_PATH}
	export LD_LIBRARY_PATH

	# PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig:/usr/share/pkgconfig:/usr/lib/arm-linux-gnueabihf/pkgconfig:${PKG_CONFIG_LIBDIR}

	# PATH 环境变量保存着可执行文件可能存在的目录
	# export PATH=${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	export PATH

################################################################################

fi

### END #!!!#

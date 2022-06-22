#!/usr/bin/env bash

### BEGIN #!!!#
################################################################################

# 环境变量
profunc_env_set() {
	# LD_LIBRARY_PATH 库文件目录
	if [ -z "${LD_LIBRARY_PATH}" ]; then
		LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/usr/lib/arm-linux-gnueabihf:/lib
	fi

	# PATH 可执行文件目录
	if [ -z "${PATH}" ]; then
		PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	fi
}

# 环境变量
profunc_env_out() {
	# LD_LIBRARY_PATH 库文件目录
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

	# PATH 可执行文件目录
	export PATH=${PATH}

	# ALSA_CONFIG_PATH 用于指定 alsa 的配置文件，这个配置文件是 alsa-lib 编译出来的
	if [ -z "${ALSA_CONFIG_PATH}" ]; then
		export ALSA_CONFIG_PATH=/usr/share/alsa/alsa.conf
		# export ALSA_CONFIG_PATH=/opt/arm_alsa/config/alsa.conf
	fi

	if [ -z "${PKG_CONFIG_PATH}" ]; then
		export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib/arm-linux-gnueabihf/pkgconfig:/usr/share/pkgconfig
	fi
}

profunc_alias() {
	alias h='history'
	alias zhconf='zhcon --utf8 --drv=fb'
	alias zhcona='zhcon --utf8 --drv=auto'
}

Proval_event=
dev_input_event() {
	Proval_event="$(cat /proc/bus/input/devices | grep -E "$1" -A4)"
	Proval_event="$(echo "$Proval_event" | grep -E 'Handlers=' | awk '{print $NF}')"
	Proval_event="$(echo "$Proval_event" | sed -n -e '1 p' | sed -E -e 's/Handlers=//g')"
	if [ -z "${Proval_event}" ]; then
		Proval_event=/dev/input/event1
	fi
}

profunc_imx6() {
	local qt_root=/opt/arm_qt_imx6 # qt 库
	local fbdevice=/dev/fb0        # 指定 frambuffer 帧缓冲设备 /dev/fb0

	dev_input_event 'edt-ft5|edt_ft5|ft5x0x_ts|ft5x'
	local tslib_dev=/dev/input/${Proval_event} # 触摸屏设备

	#	dev_input_event 'USB Mouse'
	#	local mouse_dev=/dev/input/${Proval_event} # mouse 设备

	# EVENT_num=$(cat /proc/bus/input/devices | grep -E 'edt-ft5|edt_ft5x06|TSC2007|ft5x0x_ts|goodix-ts' -A4 | tail -n1 | awk '{print $NF}')

	# 配置 tslib 的环境变量
	#	if false; then
	if true; then
		export TSLIB_FBDEVICE=${fbdevice}  # 指定 frambuffer 帧缓冲设备 /dev/fb0
		export TSLIB_TSDEVICE=${tslib_dev} # 触摸屏设备
		# export TSLIB_CONFFILE=/etc/ts.conf # tslib 配置文件
		export TSLIB_TSEVENTTYPE=INPUT # 事件类型
		# export LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libts.so

		# 指定 tslib 插件文件的路径
		# export TSLIB_PLUGINDIR=/usr/lib/arm-linux-gnueabihf/ts0

		# 设定控制台设备为 none ， 否则默认为 /dev/tty ，
		# 这样可以避免出现 “ open consoledevice:
		# No such file or directory KDSETMODE: Bad file descriptor ” 的错误
		# export TSLIB_CONSOLEDEVICE=none
	fi

	# 配置 Qt5 的环境变量
	if [ -d "${qt_root}" ]; then
		export QT_ROOT=${qt_root}
		export QT_PLUGIN_PATH=$QT_ROOT/plugins # qt 插件的目录
		export QT_QPA_PLATFORM_PLUGIN_PATH=${QT_ROOT}/plugins/platforms
		export QML2_IMPORT_PATH=$QT_ROOT/qml

		LD_LIBRARY_PATH=${QT_ROOT}/lib:${LD_LIBRARY_PATH}
		PATH=${QT_ROOT}/bin:${PATH}
	fi

	#	if false; then
	if true; then
		export QWS_MOUSE_PROTO=tslib:${tslib_dev} # 指定触摸设备
		# export QT_QPA_EVDEV_MOUSE_PARAMETERS=${mouse_dev} # mouse 设备

		export QT_QPA_GENERIC_PLUGINS=tslib:${tslib_dev}
		# export QT_QPA_GENERIC_PLUGINS=tslib:${tslib_dev}:edevmouse:${mouse_dev}

		export QT_QPA_EGLFS_TSLIB=1 # EGLFS 启用 Tslib 触摸
		export QT_QPA_FB_TSLIB=1    # FB 启用 Tslib 触摸
		# export QT_DEBUG_PLUGINS=1   # 使用 debug 模式

		# export QT_QPA_FB_HIDECURSOR=1 # 隐藏鼠标
		# 将触摸屏的点击事件配置成qt的鼠标点击事件以后会有一个光标，
		# 这样隐藏不掉的，在 qt 项目中配置 QWSServer::setCursorVisible(FALSE);

		# EGLFS【显示】旋转，此配置需要编译 opengl
		# export QT_QPA_EGLFS_ROTATION=180

		# 可以从 C:\Windows\Fonts 目录拷贝字体到此处
		# export QT_QPA_FONTDIR=/usr/share/fonts

		# 指定 QT 的运行平台
		# 显示设备 eglfs, linuxfb, minimal, xcb
		# export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0\
		# 	:size=800x480:mmsize=800x480:offset=0x0:tty=/dev/tty1\
		#	:rotation=90:invertx
		# size 		指定屏幕大小(以像素为单位)，软件可以自己查询到可以不设置
		# mmsize 	指定物理宽度和高度，单位为毫米
		# offset 	屏幕左上角的偏移量(以像素为单位)
		# rotation 	旋转90°显示(已修改源码编译可以这样)，或者运行程序时加入参数:
		# 			./app -platform linuxfb:fb=/dev/fb0:rotation=90
		# invertx 	Y轴翻转
		QT_QPA_PLATFORM=linuxfb:fb=${fbdevice}
		#		if false; then
		if true; then
			# 屏幕的宽度和高度（以像素为单位）
			export QT_QPA_EGLFS_WIDTH=1024
			export QT_QPA_EGLFS_HEIGHT=600
			# size=<宽度>x<高度> 以像素为单位指定屏幕大小
			local qpa_size=${QT_QPA_EGLFS_WIDTH}x${QT_QPA_EGLFS_HEIGHT}
			QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:size=${qpa_size}
		fi
		if false; then
			#	if true; then
			export QT_QPA_EGLFS_PHYSICAL_WIDTH=1024 #根据你的显示器设置宽度，单位 mm
			export QT_QPA_EGLFS_PHYSICAL_HEIGHT=600 #根据你的显示器设置高度，单位 mm
			# mmsize=<宽度>x<高度>	以毫米为单位指定物理宽度和高度
			local qpa_mmsize=${QT_QPA_EGLFS_PHYSICAL_WIDTH}x${QT_QPA_EGLFS_PHYSICAL_HEIGHT}
			QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:mmSize=${qpa_mmsize}
		fi
		#		if false; then
		if true; then
			# offset=<宽度>x<高度>	以像素为单位指定屏幕左上角的偏移量。默认位置在(0, 0)。
			QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:offset=0x0
		fi
		if false; then
			#	if true; then
			QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:rotation=180 # 旋转显示
		fi
		export QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:tty=/dev/tty

		# QT_QPA_DEFAULT_PLATFORM=eglfs:fb=/dev/fb0:tty=/dev/console
	fi
}

profunc_itop4412() {
	local qt_root=/opt/arm_qt_itop4412 # qt 库
	local fbdevice=/dev/fb0            # 指定 frambuffer 帧缓冲设备 /dev/fb0

	dev_input_event 'edt-ft5|edt_ft5|ft5x0x_ts|ft5x'
	local tslib_dev=/dev/input/${Proval_event} # 触摸屏设备

	#	dev_input_event 'USB Mouse'
	#	local mouse_dev=/dev/input/${Proval_event} # mouse 设备

	# EVENT_num=$(cat /proc/bus/input/devices | grep -E 'edt-ft5|edt_ft5x06|TSC2007|ft5x0x_ts|goodix-ts' -A4 | tail -n1 | awk '{print $NF}')

	# 配置 tslib 的环境变量
	#	if false; then
	if true; then
		export TSLIB_FBDEVICE=${fbdevice}  # 指定 frambuffer 帧缓冲设备 /dev/fb0
		export TSLIB_TSDEVICE=${tslib_dev} # 触摸屏设备
		# export TSLIB_CONFFILE=/etc/ts.conf # tslib 配置文件
		export TSLIB_TSEVENTTYPE=INPUT # 事件类型
		# export LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libts.so

		# 指定 tslib 插件文件的路径
		# export TSLIB_PLUGINDIR=/usr/lib/arm-linux-gnueabihf/ts0

		# 设定控制台设备为 none ， 否则默认为 /dev/tty ，
		# 这样可以避免出现 “ open consoledevice:
		# No such file or directory KDSETMODE: Bad file descriptor ” 的错误
		# export TSLIB_CONSOLEDEVICE=none
	fi

	# 配置 Qt5 的环境变量
	if [ -d "${qt_root}" ]; then
		export QT_ROOT=${qt_root}
		export QT_PLUGIN_PATH=$QT_ROOT/plugins # qt 插件的目录
		export QT_QPA_PLATFORM_PLUGIN_PATH=${QT_ROOT}/plugins/platforms
		export QML2_IMPORT_PATH=$QT_ROOT/qml

		LD_LIBRARY_PATH=${QT_ROOT}/lib:${LD_LIBRARY_PATH}
		PATH=${QT_ROOT}/bin:${PATH}
	fi

	#	if false; then
	if true; then
		export QWS_MOUSE_PROTO=tslib:${tslib_dev} # 指定触摸设备
		# export QT_QPA_EVDEV_MOUSE_PARAMETERS=${mouse_dev} # mouse 设备

		export QT_QPA_GENERIC_PLUGINS=tslib:${tslib_dev}
		# export QT_QPA_GENERIC_PLUGINS=tslib:${tslib_dev}:edevmouse:${mouse_dev}

		export QT_QPA_EGLFS_TSLIB=1 # EGLFS 启用 Tslib 触摸
		export QT_QPA_FB_TSLIB=1    # FB 启用 Tslib 触摸
		# export QT_DEBUG_PLUGINS=1   # 使用 debug 模式

		# export QT_QPA_FB_HIDECURSOR=1 # 隐藏鼠标
		# 将触摸屏的点击事件配置成qt的鼠标点击事件以后会有一个光标，
		# 这样隐藏不掉的，在 qt 项目中配置 QWSServer::setCursorVisible(FALSE);

		# EGLFS【显示】旋转，此配置需要编译 opengl
		# export QT_QPA_EGLFS_ROTATION=180

		# 可以从 C:\Windows\Fonts 目录拷贝字体到此处
		# export QT_QPA_FONTDIR=/usr/share/fonts

		# 指定 QT 的运行平台
		# 显示设备 eglfs, linuxfb, minimal, xcb
		# export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0\
		# 	:size=800x480:mmsize=800x480:offset=0x0:tty=/dev/tty1\
		#	:rotation=90:invertx
		# size 		指定屏幕大小(以像素为单位)，软件可以自己查询到可以不设置
		# mmsize 	指定物理宽度和高度，单位为毫米
		# offset 	屏幕左上角的偏移量(以像素为单位)
		# rotation 	旋转90°显示(已修改源码编译可以这样)，或者运行程序时加入参数:
		# 			./app -platform linuxfb:fb=/dev/fb0:rotation=90
		# invertx 	Y轴翻转
		QT_QPA_PLATFORM=linuxfb:fb=${fbdevice}
		# if false; then
		if true; then
			# 屏幕的宽度和高度（以像素为单位）
			export QT_QPA_EGLFS_WIDTH=1024
			export QT_QPA_EGLFS_HEIGHT=600
			# size=<宽度>x<高度> 以像素为单位指定屏幕大小
			local qpa_size=${QT_QPA_EGLFS_WIDTH}x${QT_QPA_EGLFS_HEIGHT}
			QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:size=${qpa_size}
		fi
		# if false; then
		if true; then
			export QT_QPA_EGLFS_PHYSICAL_WIDTH=1024 #根据你的显示器设置宽度，单位 mm
			export QT_QPA_EGLFS_PHYSICAL_HEIGHT=600 #根据你的显示器设置高度，单位 mm
			# mmsize=<宽度>x<高度>	以毫米为单位指定物理宽度和高度
			local qpa_mmsize=${QT_QPA_EGLFS_PHYSICAL_WIDTH}x${QT_QPA_EGLFS_PHYSICAL_HEIGHT}
			QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:mmSize=${qpa_mmsize}
		fi
		#		if false; then
		if true; then
			# offset=<宽度>x<高度>	以像素为单位指定屏幕左上角的偏移量。默认位置在(0, 0)。
			QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:offset=0x0
		fi
		if false; then
			#	if true; then
			QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:rotation=180 # 旋转显示
		fi
		export QT_QPA_PLATFORM=${QT_QPA_PLATFORM}:tty=/dev/tty

		# QT_QPA_DEFAULT_PLATFORM=eglfs:fb=/dev/fb0:tty=/dev/console
	fi
}

profunc_qt() {
	#	local select_board=
	if [ -f /arm_imx6 ]; then
		profunc_imx6
		#		select_board=arm_itop4412
	elif [ -f /arm_itop4412 ]; then
		profunc_itop4412
		#		select_board=arm_imx6
	fi
	#	case "${select_board}" in
	#	arm_imx6)
	#		profunc_imx6
	#		;;
	#	arm_itop4412)
	#		profunc_itop4412
	#		;;
	#	esac
}

################################################################################

if [ -z "${ZCQ_ubuntu_arm_env}" ]; then
	# export ZCQ_ubuntu_arm_env="set env"
	ZCQ_ubuntu_arm_env="set env"
	profunc_env_set
	profunc_alias
	profunc_qt
	profunc_env_out
fi

################################################################################
### END #!!!#

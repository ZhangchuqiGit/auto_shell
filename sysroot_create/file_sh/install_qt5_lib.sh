#! /usr/bin/bash

# ./1_prepare.sh ${DIR_base_rootfs}

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

if [ -z "$1" ]; then
	source /opt/ARM_tool_function.sh
fi

################################################################

f_install_qt5_QtWebengine() {
	# https://wiki.qt.io/QtWebEngine/How_to_Try

	func_echo "QtWebengine for Ubuntu"
	func_apt -i bison build-essential gperf flex python2
	func_apt -i libasound2-dev libcups2-dev libdrm-dev libegl1-mesa-dev
	func_apt -i libnss3-dev libpci-dev libpulse-dev libudev-dev nodejs
	func_apt -i libxtst-dev gyp

	func_echo "libninja"
	func_apt -i re2c ninja-build

	func_echo "QtWebengine for Ubuntu 20.04+"
	func_apt -i libssl-dev libxcursor-dev libxcomposite-dev libxdamage-dev
	func_apt -i libxrandr-dev libdbus-1-dev libfontconfig1-dev libxss-dev
	func_apt -i libsrtp2-dev libdbus-c++-dev
	func_apt -i libcap-dev
	func_apt -i libwebp-dev libjsoncpp-dev libopus-dev libminizip-dev
	func_apt -i libavutil-dev libavformat-dev libavcodec-dev
	func_apt -i libevent-dev libvpx-dev libsnappy-dev
	func_apt -i libre2-dev libprotobuf-dev protobuf-compiler libxcb-xinerama0-dev
}

f_install_qt5_other_packages() {
	func_echo_loop "Other packages"

	func_apt -i xorg                      # 显示环境
	func_apt -i libx11-dev libwayland-dev # 显示环境

	func_apt -i libgcrypt20 libgcrypt20-dev
	func_apt -i libgles-dev perl libproxy-dev

	func_echo "Xcb"
	func_apt -i xcb libxcb1 libxcb1-dev
	func_apt -i libxcb-*-dev
	func_apt -i libxcb-*

	func_echo "X11"
	func_apt -i libx11-dev libx11-xcb-dev
	func_apt -i libfontconfig1-dev libfreetype6-dev
	func_apt -i libxext-dev libxfixes-dev libxi-dev libxrender-dev
	func_apt -i libxcb1-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev
	func_apt -i libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync0-dev libxcb-xfixes0-dev
	func_apt -i libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev
	func_apt -i libxcb-xinerama0-dev
	func_apt -i libxkbcommon-dev libxkbcommon-x11-dev

	func_echo "OpenGL"
	func_apt -i build-essential mesa-common-dev
	func_apt -i libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libegl1-mesa-dev

	if true; then
		# if false; then
		func_echo " QDoc Documentation Generator Tool"
		func_apt -i libclang-dev libclang1 llvm llvm-dev

		func_echo "llvm
		如果 不用 QDoc 则不需要安装。不建议安装，费时费力费空间 "
		func_apt -i clang-format clang-tidy clang-tools clang clangd libc++-dev
		func_apt -i libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1
		func_apt -i libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev
		func_apt -i llvm-runtime llvm python-clang libegl1-mesa-dev
	fi

	func_echo "Qt WebKit"
	func_apt -i flex bison gperf libicu-dev libxslt1-dev ruby

	func_echo " Qt Multimedia"
	func_apt -i gstreamer1.0-qt5 qml-module-qtgstreamer
	func_apt -i libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
	func_apt -i libasound2-dev

	if true; then
		# if false; then
		func_echo "Bluetooth"
		func_apt -i bluez libbluetooth-dev
	fi

	if true; then
		# if false; then
		func_echo "Databases (PostgreSQL, MariaDB/MySQL)"
		func_apt -i libpq-dev libmariadbclient-dev
	fi

	func_echo "Printing support using CUPS"
	func_apt -i libcups2-dev

	func_echo "Wayland"
	func_apt -i libwayland-dev

	func_echo "Accessibility"
	func_apt -i libatspi2.0-dev

	func_echo "SCTP"
	func_apt -i libsctp-dev

	func_echo "harfbuzz"
	func_apt -i libharfbuzz-dev

	func_echo "sqlite"
	func_apt -i sqlite libsqlite3-dev

	func_echo "dbus-runtime"
	func_apt -i libdbus-1-dev

	func_echo "jasper"
	func_apt -i jasper

	func_echo "libinput libudev"
	func_apt -i libinput-dev libudev-dev

	func_echo "assimp"
	func_apt -i libassimp-dev assimp-utils # assimp-testmodels
}

f_install_qt_common() {
	func_apt -i m4
	# func_apt -i gcc-multilib
	# func_apt -i g++-multilib
	# func_apt -i gcc-multilib-arm-linux-gnueabihf
	# func_apt -i g++-multilib-arm-linux-gnueabihf

	# func_apt -i pkg-config
	# func_apt -i pkg-config-arm-linux-*

	func_apt -i python python2 python2-dev python3 python3-dev
	func_apt -i python-dev-is-python2
	# func_apt -i python2.7 python2.7-dev python3.8 python3.8-dev

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

	func_echo "ALSA 音频架构 
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
	# func_apt -i smplayer # SMPlayer 是 MPlayer 前端，支持视频、dvd和VCD
}

################################################################

f_install_qt5_lib() {
	func_echo_loop "交叉编译 qt 需要的库"

	func_apt_repository universe

	f_install_qt5_QtWebengine
	f_install_qt5_other_packages

}

################################################################

main_qt5() {
	# f_install_qt_common
	f_install_qt5_lib
}

################################################################

if [ -z "$1" ]; then
	main_qt5
fi

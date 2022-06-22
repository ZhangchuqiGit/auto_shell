#! /bin/bash

# qt5 移植
# https://www.toradex.com/zh-cn/blog/qian-ru-shi-arm-ping-tai-jiao-cha-bian-yi-qt5-yuan-dai-ma

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

#####################################################################

opt_arm_qt=/opt/arm_imx6ull_qt_5.12.9 # 编译输出路径
func_execute_sudo rm -rf ${opt_arm_qt}
func_mkdir 777 ${opt_arm_qt}

func_chmod 777 ${RootPath}

#####################################################################

func_echo_loop "嵌入式 Arm 平台交叉编译 Qt5 源代码"

func_echo "Qt 图形开发框架 作为嵌入式 Arm 平台配合 Embedded Linux 系统
最常用的图形界面开发工具已经被广泛使用，针对基于 Ycoto 项目编译的 Embedded Linux 系统，
可以非常方便的通过 OpenEmbedded 开发环境将特定版本的 Qt 开源版本运行库集成到 Embedded Linux 系统里面，
比如 Ycoto release 2.4支持的是 Qt 5.9 版本，而当所需要的 Qt 版本不是这个版本的时候，
比如Qt 5.12，那么就需要通过源代码进行交叉编译，本文即进行相关测试示例。"

func_echo_loop "编译环境配置"

func_echo "首先下载 i.MX6 对应的 SDK。
下载地址: https://developer.toradex.com/files/toradex-dev/uploads/media/Colibri/Linux/SDKs/
选择对应的版本和模块进行下载，如 2.8/apalis-imx6/angstrom-lxde-image/ 下进行下载
安装SDK，可以安装到默认目录 /usr/local/oecore-x86_64，
也可以安装到其他定制目录，如 opt/armv7at2hf_toolchain 下面"

# 工具链路径 编译环境
DIR_toolchain=opt/armv7at2hf_toolchain

# 配置文件(修改)
source_code_compile=../Qt5.12_source_code_compile-master
func_path_isexit "source_code_compile" ${source_code_compile}

func_cpf ${source_code_compile}/qmake.conf \
	${RootPath}/qtbase/mkspecs/devices/linux-imx6-g++/

func_echo "修改环境变量"

source ${source_code_compile}/environment-setup-qt-default
# source ${DIR_toolchain}/environment-setup-armv7at2hf-neon-angstrom-linux-gnueabi

################################################################

Dir_Build=${RootPath}/zcq_build
func_execute_sudo rm -rf ${Dir_Build}
func_mkdir 777 ${Dir_Build}
func_cd ${Dir_Build}

################################################################

function Distclean() {
	if [ -f Makefile ]; then
		echo -e "\033[1;36m read 1: make distclean \e[0m"
		local _enter=1
		#		read _enter
		if [ "${_enter}" = "1" ]; then
			#	make ARCH=arm CROSS_COMPILE=${gnueabihf}- distclean # 驱动开发，不清理
			func_execute_sudo make distclean
			# rm -f Makefile &>>/dev/null
		fi
	fi
}
Distclean

Val_configure=""
Val_num=0
f_add_val() {
	# while [ $# -gt 0 ]; do
	# 	Val_configure="${Val_configure} $1 "
	# 	let 'Val_num++'
	# done
	Val_configure="${Val_configure} $@ "
	Val_num=$((${Val_num} + $#))
	# func_echo "Val_configure=${Val_configure}"
	func_echo "$#;${Val_num}"
}

################################################################
# configure bash for qt5.12.3
# https://www.toradex.com/zh-cn/blog/qian-ru-shi-arm-ping-tai-jiao-cha-bian-yi-qt5-yuan-dai-ma
# 选定 xcb（X11）支持等，也可以通过 -skip <qtmodule> 来忽略编译某些qt模块，本文默认编译全部

func_echo "生成 Makefile，以编译源码"
func_echo "${RootPath}/configure"

if true; then
	# if false; then

	# Top-level installation directories:
	f_add_val \
		-prefix ${opt_arm_qt}
	# Configure meta:
	f_add_val \
		-recheck-all
	# Build options:
	f_add_val \
		-opensource \
		-confirm-license \
		-release \
		-optimized-qmake \
		-shared \
		-device linux-imx6-g++ \
		-device-option CROSS_COMPILE=${CROSS_COMPILE} \
		--sse2=no \
		--rpath=no \
		-pch
	# Build environment:
	f_add_val \
		-sysroot ${SDKTARGETSYSROOT} \
		-pkg-config \
		-I ${SDKTARGETSYSROOT}/usr/include \
		-L ${SDKTARGETSYSROOT}/usr/lib
	# Component selection:
	f_add_val \
		-make libs \
		-nomake examples \
		-nomake tools \
		-nomake tests \
		-gui \
		-widgets \
		-dbus \
		-dbus-runtime \
		-accessibility
	# Core options:
	f_add_val \
		-no-glib \
		--iconv=no \
		--pcre=qt \
		--zlib=system \
		-I${Opt_arm_zlib}/prefix/include \
		-L${Opt_arm_zlib}/prefix/lib
	# Network options:
	f_add_val \
		-no-openssl
	# Gui, printing, widget options:
	f_add_val \
		--freetype=qt \
		--harfbuzz=qt \
		-no-opengl \
		-opengl es2 \
		-xcb-xlib
	# Platform backends:
	f_add_val \
		-no-eglfs \
		-linuxfb \
		-xcb \
		-qpa xcb

	# Multimedia options:
	f_add_val \
		-no-pulseaudio \
		-gstreamer
	# WebEngine options:
	f_add_val \
		-no-webengine-pulseaudio \
		-webengine-embedded-build \
		--webengine-icu=qt \
		--webengine-ffmpeg=qt \
		--webengine-opus=qt \
		--webengine-webp=qt \
		-webengine-proprietary-codecs

	${RootPath}/configure -v ${Val_configure} &>>_zcq_build_info.txt
fi
################################################################

# --prefix=编译输出路径
# -I tslib 头文件路径
# -L tslib 库文件路径

func_chmod 777 ${RootPath}

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_echo "make -j${cpu_cores} &>>_zcq_make_info.txt # 编译"
make -j${cpu_cores} &>>_zcq_make_info.txt # 编译

func_chmod 777 ${RootPath}

if false; then
	# if true; then
	func_echo "
	# if false; then
	# 编译完成以后打开 config.mak 文件，找到 “INSTALLSTRIP = -s”这一行，
	# 取消掉后面的“-s”，否则 “make install” 命令会失败！ "
	${Sudo} sed -i -E -e "s/^INSTALLSTRIP/#INSTALLSTRIP/" config.mak
	#	i 上面插入;		a 下面插入
	${Sudo} sed -i -E -e '/^#INSTALLSTRIP/ a INSTALLSTRIP = ' config.mak
fi

func_echo "make install -j${cpu_cores} &>>_zcq_make_install_info.txt # 安装 编译结果"

make install -j${cpu_cores} &>>_zcq_make_install_info.txt # 安装 编译结果

#####################################################################

func_chmod 777 ${RootPath}
func_chmod 777 ${opt_arm_qt}
